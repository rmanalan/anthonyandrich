class Hamming
  require 'digest/sha1'
  $orig_digest = Digest::SHA1.hexdigest('I am not a big believer in fortune telling').hex
  $sentence = ""
  $distance = 1000
  $next_sentence = ""
  $next_random_mask = ""
  $test = true
  $dictionary = ["test", "hamming"]
  $dictionary_array = [0, 0]


  def self.get_next_sentence
    #need to get next sentence 1 more time
    dict_length = $dictionary.length
    array_length = $dictionary_array.length
    sentence = []
    0.upto(array_length -1) do | curr |
      sentence << $dictionary[$dictionary_array[curr]]
    end
    if $next_sentence == "" then
        $next_sentence = sentence
        return get_next_sentence
    end
    i = 0
    while i < array_length && $dictionary_array[i] == (dict_length -1) do
      $dictionary_array[i] = 0
      i = i + 1
    end
#    puts "#{i} -- #{$dictionary_array.join('-')}"
    if i >= array_length then
      $dictionary_array = []
    else
      $dictionary_array[i] = $dictionary_array[i] + 1
    end
    sentence.join(" ")
  end

  
  def self.get_next_batch
    current_random_mask = String.new $next_random_mask
    if $next_sentence == ""
      $next_sentence = get_next_sentence
    end
    current_sentence = String.new $next_sentence
     i = 0
     max_length = 4
     last_character = "Z"
    if $test then
      max_length = 2
      last_character = "B"
    end
    while i < $next_random_mask.length && $next_random_mask[i, 1] == last_character do
       $next_random_mask[i] = "0"
        i = i + 1
    end
    if i >= $next_random_mask.length
       if i >= max_length
          $next_random_mask = ""
          $next_sentence = get_next_sentence
       else
          $next_random_mask << "0"
       end
    else
       $next_random_mask[i] = get_next_char($next_random_mask[i, 1])
    end   
    [(current_sentence), current_random_mask]
  end

def self.get_next_char(curr_char)
  if !$test then
    curr_char = curr_char.to_s
    if curr_char == "Z" then
       curr_char = "0"
    elsif curr_char == "9" then
       curr_char = "a"
    elsif curr_char == "z" then
       curr_char = "A"
     else
       curr_char = (curr_char[0] + 1).chr
     end
     return curr_char
  else
    curr_char = curr_char.to_s
    if curr_char == "B" then
       curr_char = "0"
    elsif curr_char == "1" then
       curr_char = "a"
    elsif curr_char == "b" then
       curr_char = "A"
     else
       curr_char = (curr_char[0] + 1).chr
     end
     return curr_char    
  end
end

  def self.bit_count(value, min = 1000)
    mask = 1
    count = 0
    while value > 0
      count = count + (mask & value)
      value = value >> 1
      if count >= min then
        return count + 1
      end
    end
    count
  end

  def self.compute_hamming(sentence)
    digest = Digest::SHA1.hexdigest(sentence).hex
    distance = bit_count($orig_digest^digest, $distance)
#    puts "#{digest} -- #{sentence}"
    if distance <= $distance then
       $sentence = sentence
       $distance = distance
       puts "Changed #{$distance} -- #{$sentence}"
    end
  end    

  def self.process_batch
    if (batch = get_next_batch)[0] == "" then
      return nil
    end
    if batch[1] == "" then
      compute_hamming(batch[0])
    end
    if $test then
      char = "B"
      iteration = 6
    else
      char = "Z"
      iteration = 62
    end
    1.upto(iteration) do | curr |
      char = get_next_char(char)
      sentence = batch[0] + " " + batch[1] + char
      compute_hamming(sentence)
    end
    return [$distance, $sentence]
  end
    
  def get_result
    return [$distance, $sentence]
  end
  
  def self.test_run
    batch_number = 0
    run = true
    while run == true do
      puts "==========#{batch_number}=========="
      return_value = process_batch
      if return_value.nil?
        run = false
        return
      end
      batch_number = batch_number + 1
    end  
  end 
  
end