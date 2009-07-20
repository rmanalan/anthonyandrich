require 'bumble.rb'
class State
  include Bumble
  ds :distance, :sentence, :next_sentence, :next_random_mask, :test, :dictionary, :dictionary_array

  def self.create
    state = State.create! :sentence => "", :next_sentence => "", :next_random_mask => "", :test => false
  end
end