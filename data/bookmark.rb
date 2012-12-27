require 'date'

class Bookmark
  attr_accessor :id, :name, :notes, :added_on, :url, :is_pinned
  
  def initialize(params = {})
    self.id = params[:id] || params['id']
    self.name = params[:name] || params['name']
    self.notes = params[:notes] || params['notes']
    add_date = params[:added_on] || params['added_on']
    self.added_on = DateTime.parse(add_date) if add_date
    self.url = params[:url] || params['url']
    pin = params[:is_pinned] || params['is_pinned']
    if pin == nil then pin = false end   
    @is_pinned = pin 
  end
  
  def Bookmark.build(bms)
    bookmarks = []    
    bms.each do |bm|
      bookmarks << Bookmark.new(bm)
    end
    bookmarks
  end
  
end