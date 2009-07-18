require 'rubygems'
require 'sinatra'
require 'appengine-apis/datastore'

get '/new/*' do
  @post = AppEngine::Datastore::Entity.new("Post")
  @post[:message] = params["splat"]
  AppEngine::Datastore.put(@post)
  "Hello from #{params['splat']}"
end

get '/results' do
  out = ""
  @post = AppEngine::Datastore::Query.new("Post")
  @post.each do |p|
    out << p[:message] + "<br/>"
  end
  out
end