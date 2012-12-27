$: << File.expand_path(File.dirname(__FILE__) + "/data")
require 'data_store'

ds = DataStore.new

params = {"url"=>"http://www.rediff.com", "name"=>"Rediff Home Page", "notes"=>"This is a good site for India news."}
bookmark_proto = Bookmark.new(params)
puts bookmark_proto.inspect
new_bookmark = ds.create_bookmark_for_user(1, bookmark_proto)