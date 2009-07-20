require 'bumble.rb'
class State
  include Bumble
  ds :distance, :sentence, :next_sentence, :next_random_mask, :test, :dictionary, :dictionary_array
end