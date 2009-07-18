require 'rubygems'
require 'sinatra'
require 'appengine-apis/datastore'
require 'lib/hamming'
require 'lib/testing'

get '/new/*' do
  @post = AppEngine::Datastore::Entity.new("Post")
  @post[:message] = params["splat"]
  AppEngine::Datastore.put(@post[:message])
  "Hello from #{params['splat']}"
end

get '/delete_results' do
  @entries = AppEngine::Datastore::Query.new("Entry")
  @entries.fetch
  AppEngine::Datastore.delete(@entries)
  "Entries deleted: #{keys.join(', ')}"
end

get '/process_batch' do
  Hamming.process_batch 
  "Best sentence: #{Hamming.sentence}, Closest distance: #{Hamming.distance}"
end

get '/test' do
  Testing.test_var = Testing.test_var + 1
  "testing #{Testing.test_var}"  
end
