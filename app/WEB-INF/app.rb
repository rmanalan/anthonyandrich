require 'rubygems'
require 'sinatra'
require 'appengine-apis/datastore'
require 'lib/hamming'
require 'lib/testing'
require 'lib/bumble'

class State
  include Bumble
  ds :distance, :sentence, :next_sentence, :next_random_mask, :test, :dictionary, :dictionary_array
end

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

get '/show_results' do
    "Best sentence: #{Hamming.sentence}, Closest distance: #{Hamming.distance}" 
#     ", Dict Array: #{Hamming.dictionary_array.join('-')" +
#     ", Next sentence: #{Hamming.next_sentence}" +
#     ", Next random mask: #{Hamming.next_random_mask}"
end

get '/test' do
  state = State.all({})
  if state.nil? || state.first.nil?
    state =  State.create! :distance => 1000    
  end
  state = state.first
  state.distance = state.distance + 1
  state.save!
#  "success"
#  Testing.test_var = Testing.test_var + 1
  "testing state: #{state.distance}"  
end
