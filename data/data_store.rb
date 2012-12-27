require 'pg'
require 'digest/sha2'
require 'securerandom'
require 'bookmark'
require 'user'

class DataStore

  def initialize(logger = nil)
    @conn = PG.connect(dbname: 'bookmarker_sinatra') # TODO get the db name from the settings file based on the env    
    @logger = logger
  end
  
  def close_conn
    @conn.close
  end

  def authenticate(guest)
    query = "SELECT * FROM users WHERE email = $1"   
    if user = @conn.exec(query, [guest.email]).first
      if user['hashed_password'] == hash_password(guest.password, user['salt'])        
        u = User.new(id: user['id'], name: user['name'], email: user['email'])         
      end        
    end
  end

  def create_user(user_proto)
    user = User.new
    query = "SELECT count(*) FROM users WHERE email = $1"
    count = Integer(@conn.exec(query, [user_proto.email]).first["count"])
    if count == 0
      salt = generate_salt
      hashed_password = hash_password(user_proto.password, salt)
      ins_query = <<-EOS
        INSERT INTO users (name, email, hashed_password, salt)
        VALUES ($1, $2, $3, $4)
        RETURNING id
      EOS
      uid = @conn.exec(ins_query, [user_proto.name, user_proto.email, hashed_password, salt]).
        first["id"]
      user.id = uid
      user.password = nil
    else
      user.errors.push({"email" => "This email is already in use!"})      
    end
    user.email = user_proto.email
    user.name = user_proto.name
    user
  end
  
  # Returns an empty array if this user does not have any bookmarks
  def get_bookmarks_for_user(user_id)
    query = <<-EOS
      SELECT b.id, b.name, b.notes, b.added_on, w.url
      FROM bookmarks b, web_pages w
      WHERE b.web_page_id = w.id
      AND user_id = $1
    EOS
    bms = @conn.exec(query, [user_id])
    Bookmark.build(bms)
  end

  # Returns an empty array if this user does not have any pinned bookmarks
  def get_pinned_bookmarks_for_user(user_id)
    query = <<-EOS
      SELECT b.id, b.name, b.notes, b.added_on, w.url
      FROM bookmarks b, web_pages w
      WHERE b.web_page_id = w.id
      AND user_id = $1
      AND is_pinned = TRUE
    EOS
    pbms = @conn.exec(query, [user_id])
    Bookmark.build(pbms)
  end
  
  # Returns nil if the user and bookmark do not match
  def get_bookmark_for_user(user_id, bookmark_id)
    query = <<-EOS
      SELECT b.id, b.name, b.notes, b.added_on, w.url 
      FROM bookmarks b, users u, web_pages w
      WHERE b.user_id = u.id
      AND b.web_page_id = w.id
      AND b.user_id = $1
      AND b.id = $2
    EOS
    bm = @conn.exec(query, [user_id, bookmark_id]).first
    unless bm == nil
      bm = Bookmark.new(bm)
    end
    bm  
  end
  
  # Returns nil if user and bookmark do not match
  def pin_bookmark_for_user(user_id, bookmark_id)
    bm = get_bookmark_for_user(user_id, bookmark_id)
    unless bm == nil
      bm.is_pinned = true
      bm = update_bookmark_for_user(user_id, bm)
    end
    bm
  end
  
  def update_bookmark_for_user(user_id, updated_bookmark)
    @logger.info "********* Inside update_bookmark_for_user #{updated_bookmark.inspect}"
    query = <<-EOS
      UPDATE bookmarks SET name = $1, notes = $2, is_pinned = #{updated_bookmark.is_pinned}
      WHERE id = $3
    EOS
    @logger.info "******** #{updated_bookmark.id}"
    @logger.info "********* #{query}"
    @conn.exec(query, [updated_bookmark.name, updated_bookmark.notes, updated_bookmark.id])
    get_bookmark_for_user(user_id, updated_bookmark.id)
  end
  
  def delete_bookmark_for_user(user_id, bookmark_id)
    bm = get_bookmark_for_user(user_id, bookmark_id)
    unless bm == nil
      query = "DELETE FROM bookmarks WHERE id = $1"
      @conn.exec(query, [bookmark_id])
    end    
  end 

  def create_bookmark_for_user(user_id, bookmark_proto)
    #check if this url already exists in web_pages
    query = "SELECT id FROM web_pages WHERE url = $1"
    wp = @conn.exec(query, [bookmark_proto.url])
    if wp.count == 0
      ins_query = 'INSERT INTO web_pages (title, url) VALUES ($1, $2) RETURNING id'
      # TODO get the title by downloading the url
      title = 'Some sample title'
      wp = @conn.exec(ins_query, [title, bookmark_proto.url])    
    end

    ins_query2 = <<-EOS
      INSERT INTO bookmarks (user_id, web_page_id, added_on, is_pinned, name, notes)
      VALUES ($1, $2, $3, FALSE, $4, $5) RETURNING id
    EOS
    bid = @conn.exec(ins_query2, [user_id, wp[0]['id'], Time.new, bookmark_proto.name, bookmark_proto.notes])
    get_bookmark_for_user(user_id, bid[0]['id'])
  end

  def hash_password(password, salt)
    Digest::SHA2.hexdigest(password + salt)
  end

  def generate_salt
    SecureRandom.uuid
  end

  private :hash_password, :generate_salt
end

