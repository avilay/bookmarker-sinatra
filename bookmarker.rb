$: << File.expand_path(File.dirname(__FILE__) + "/data")
require 'sinatra'
require 'sinatra/reloader'
require 'data_store'

enable :sessions

helpers do
  def partial(page, options = {})
    erb page, options.merge!(:layout => false)
  end

  def set_user_session(user)
    session[:user] = user
    session[:authenticated] = true
    redirect to('/bookmarks/')
  end
end

# Filters
before do
  @ds = DataStore.new(logger)
  @flash = {}
  @flash[:errors] = session[:errors] || []
  @flash[:notices] = session[:notices] || []
  session[:errors] = nil
  session[:notices] = nil
  if session[:authenticated] && session[:user]
    @user = session[:user]
    @flash[:errors].push(*@user.errors)    
    @pinned_bookmarks = @ds.get_pinned_bookmarks_for_user(@user.id)
  end
end

before '/bookmarks/*' do
  redirect to('/login/') unless session[:authenticated]
  @bookmarks_active = 'active'
end

# Routes
# Routes for account management
get '/login/' do
  erb :login
end

post '/login/' do
  guest = User.new(email: params[:email], password: params[:password])
  if user = @ds.authenticate(guest)     
    set_user_session(user)
  else
    session[:errors] = ['Invalid credentials!']
    redirect back
  end
end

get '/register/' do  
  erb :register
end

post '/register/' do
  # TODO: Move this validation to client-side
  unless params[:password] == params[:confirm_password]
    session[:errors] << 'Passwords do not match!'
    redirect back
  end

  user_proto = User.new(name: params[:name], email: params[:email], password: params[:password])
  user = @ds.create_user(user_proto)
  if user.errors.count == 0
    set_user_session(user)
  else    
    (session[:errors] ||= []).push(*user.errors)
    redirect back
  end
end

# Routes for bookmarks
get '/bookmarks/' do  
  @bookmarks = @ds.get_bookmarks_for_user(@user.id)  
  erb :list_bookmarks  
end

get '/bookmarks/:id' do
  @bookmark = @ds.get_bookmark_for_user(@user.id, params[:id])
  # TODO If @bookmark == nil show 404
  erb :show_bookmarks
end

get '/bookmarks/:id/edit/' do
  @bookmark = @ds.get_bookmark_for_user(@user.id, params[:id])
  # TODO if @bookmark == nil show 404
  erb :edit_bookmarks
end

#Real REST call would be put '/bookmarks/:id'
post '/bookmarks/:id' do
  bookmark = @ds.get_bookmark_for_user(@user.id, params[:id])
  # TODO if bookmark == nil show 404
  bookmark.name = params[:name]
  bookmark.notes = params[:notes]  
  new_bookmark = @ds.update_bookmark_for_user(@user.id, bookmark)
  # TODO if new_bookmark == nil throw error
  redirect to("/bookmarks/#{new_bookmark.id}")
end

get '/bookmarks/:id/delete/' do
  @ds.delete_bookmark_for_user(@user.id, params[:id])
  redirect to('/bookmarks/')
end

get '/bookmarks/:id/pin/' do
  bm = @ds.pin_bookmark_for_user(@user.id, params[:id])
  # if bm == nil throw 404
  redirect to('/bookmarks/')
end

get '/bookmarks/new/' do
  erb :new_bookmarks
end

post '/bookmarks/' do
  bookmark_proto = Bookmark.new(params)
  new_bookmark = @ds.create_bookmark_for_user(@user.id, bookmark_proto)
  # TODO if new_bookmark is nil throw 500 ISE
  session[:notices] = ['Bookmark was successfully added.']
  redirect to("/bookmarks/#{new_bookmark.id}")
end

