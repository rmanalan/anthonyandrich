class Hamming
  require 'digest/sha1'
  require 'appengine-apis/datastore'
  @@orig_digest = Digest::SHA1.hexdigest('I am not a big believer in fortune telling').hex
  @@sentence = ""
  @@distance = 1000
  @@next_sentence = ""
  @@next_random_mask = ""
  @@test = true
  @@dictionary = %w(solo flex scalable rubyonrails rails cloud web hosting ec2 aws git 3des abbrev accessor actionpack active activereload addon adjoin aes agile ajax alberti algol alias allen allman aloha amazon AMI amp andreessen android apache apple applet apricot ar arcade array assert assoc atbash atkinson awk awsm awstats babbage backus balancers bartle base64 based bash bazeries bdd beck becker behavior behlendorf bell benchmark benchmarks berkeleydb berners beta betas bford bigdecimal bignum bigtable biham bin bina binaries binary bitsweat bizstone blank bletchley block blocks blog blogs boole boolean bot box bricklin bridge brin browser browsers bsd bug bugs build builder builders builds bytesize c10k cache caches caching caesar call camp capistrano cardelli carmack carribault case catalyst center cerf cgi chabaud chain channel chars cheezburger chef chen child chomp chop chore church ci city class classes cleanup clear client clients clone closures cluster clusters cmd cochran code coder codes codex collect collossus colocated colocation combine combines command commands commit commits complex computer computes computing concat config configs console contest controller converge cook cooley core cores count counter counters cows cpu cpus cray creation creator crispin cryptanalysis css csshsh csv cucumber cunningham cvs daemon daemons damgard dastels data db dbfile dbm dclone debug decode decode64 dedicated defect deicaza delayedjob delegate delete demos denmark dependency deploy deployment deprecate des development dhh diffie digest dijkstra dirty disk display div dix django dll dom dongarra driver dry dst ducktype dup dupe dynamic dystopia eager edge editor eff eich eiffel eight eighty elastic element emacs encode encode64 end enebo engine engineyard eniac enigma enum enumerator environment equal erb error escape etc eval event events exception exceptions excerpt excerpts exist exists expert experts expire expo extend ezmobius facets fairchild fastcgi fastxs fcgi fcntl feature fedora feigenbaum ferret fetch file filesystem fileutils filo filter finish fips first fix fixnum fixture flowers floyd flush footer foreign form format formt formula formulas fowler fragment fragments fraser free freebsd freeware freeze friedman front frozen ftools ftp function functional gadget gate gem gems generator generators generic gentoo gets gfs ginsburg github gitignore glob global globals glue godel goldberg golden golub gosling gray greater greenblatt grep grok group groups grove gsub gutmans h1 h2 h3 habtm hack hacker hackers hacks haml hamming handler handlers handling hansson haproxy hash hashing hawkes headers headius heinemeier hejlsberg hellman hello helper hex hexadecimal hibernate hillis hoedown hopper host hosted hosts howcast hpricot href html htonl http https i10n i18n icanhaz icann ichbiah icon iconv id ietf imap include index ingalls inject injection inline inode insert inspect install instance integer integration intern internet internets interpreter interpreters invalid io iphone iphones ipsec irb irbrc is iterators ivarsoy iverson iwatani jacobson jakarta jalby javascript join joshp joux joy jquery jruby json kahan kahn kaigi kapor karpinski kasiski katz kay kconv kemeny kemper kerckhoff kernighan key keyboard kindi king kit knuth koenig koichi korn koster koz kri kurtz label lacida lamport lampson landing last layer layout legacy lehey lemuet length lesk less lib libcrypt library lifo lift lighttpd limit line lines link linus linux lisp load locale locales localize lock locks logger lolcode love lovelace lua macro macromates mailer mailers managed many map maps marking mash master masters match matsumoto matz mccarthy mcdonald mcilroy mckusick md5 memcached memory merb merkle mesh meta metaclass metaprogramming metcalfe method methods mime minam miner minsky mixmax miyamoto mock mocks mod module modules moler mongrel monitor monitoring montulli moolenaar moore moravec morhaime mozilla mri multicore mysql naik named nested netbeans network new newman next nginx nil nine nist nitems node nodes nodoc noradio norton notift nsa nzkoz object objects observer offline oikarinen olson one online open opera opscode optimize optimizes option options order orders oriented oscon oss oswald ousterhout outer output outputs package page pages pair pajitnov papert parameter parameters params parent parents parse parser partition passenger path paths pattern patterns peek peeks penny perform performs perl pgp phoenix php phusion pica pieprzyk pivot pixel plugin poe polybius pop3 pops portable portage postel postgres postgressql private proc process processes procs program programmer programming programs properties proxy pstore puppet puts python qalqashandi quantity query queue rack railsconf railties raise rake rakefile ram rassoc rational raymond rb rdoc reader readline readme reaper reapers received recipes record records redhat redis reduce reduces reflection regex regexp reject rejewski reliable remote remotes render renders replace replaces reports request requests require rescue reset resig resource response rest restful return returns rfc1034 rfc1036 rfc1058 rfc1059 rfc114 rfc1157 rfc1321 rfc1429 rfc1730 rfc1855 rfc1889 rfc1945 rfc1964 rfc2131 rfc2195 rfc2440 rfc2616 rfc2810 rfc2812 rfc2813 rfc2965 rfc3022 rfc4634 rfc768 rfc783 rfc791 rfc792 rfc793 rfc826 rfc868 rfc937 rfc959 rijmen ritchie rivest rjs rjust robot robots roller root ror rossum rout route router routes routing rows rozycki rspec rss rstrip rubigen rubinius ruby rubyforge rubymine runtime sass scaffolding scala scale sccs schema schneier scope scotland scribd script scrum scytale secure self send sent serve server servers service services servlet servlets session sessions sha1 sha256 sha3 sha512 shamir shannon shard sharding shards share shared shaw shell shenker shift shifts shuffle sigaba sigpipe silence simon simonyi simpledb sinatra site six size slice slices smime smtp snapshot snapshots soap socket sockets software source space spencer sphinx split spring sql sqlite sqlserver sqs ssl stable stack stacks stallman standard standards station stations stats stdin stearns steele steganography sti stonebraker storage strachey string stringio strings stroustrup struct structure structures struts sub subclass subversion summit support suppress suraski sussman svn sweeper sync syntax syslog syslogs sysoev tab table tables tag taguri tanenbaum tatham tcpip tdd tech technical template tender tesler test testing tests textmate theory thin thompson thread threaded threading threads ticket tickets tiered tmp tokyo torvalds trithemius trubshaw tsort tube tubes tukey turing typedef typex tyrant ubuntu ulysses unicode union uniq unit unix upcase upto url utc utf utf8 velocity venema vernam vi vigenere vm voynich vps vsphere w3c wadler wall wang watson webcal webdav webrat webrick welchman wep whitfield whittling wiki williams win32 winer winograd wirth wolfram wozniak wsdl www wycats wysiwyg xal xkcd xml yamauchi yaml yin yu zakalwe zawinski zehm zimmerman zlib zygalski) 
  @@dictionary_array = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
  
  def self.distance
    @@distance
  end
  
  def self.sentence
    @@sentence
  end

  def self.dictionary_array
    @@dictionary_array
  end

  def self.next_sentence
    @@next_sentence
  end

  def self.next_random_mask
    @@next_random_mask
  end

  def self.get_next_sentence
    #need to get next sentence 1 more time
    dict_length = @@dictionary.length
    array_length = @@dictionary_array.length
    sentence = []
    0.upto(array_length -1) do | curr |
      sentence << @@dictionary[@@dictionary_array[curr]]
    end
    if @@next_sentence == "" then
        @@next_sentence = sentence
        return get_next_sentence
    end
    i = 0
    while i < array_length && @@dictionary_array[i] == (dict_length -1) do
      @@dictionary_array[i] = 0
      i = i + 1
    end
#    puts "#{i} -- #{@@dictionary_array.join('-')}"
    if i >= array_length then
      @@dictionary_array = []
    else
      @@dictionary_array[i] = @@dictionary_array[i] + 1
    end
    sentence.join(" ")
  end

  
  def self.get_next_batch
    current_random_mask = String.new @@next_random_mask
    if @@next_sentence == ""
      @@next_sentence = get_next_sentence
    end
    current_sentence = String.new @@next_sentence
     i = 0
     max_length = 4
     last_character = "Z"
    if @@test then
      max_length = 2
      last_character = "B"
    end
    while i < @@next_random_mask.length && @@next_random_mask[i, 1] == last_character do
       @@next_random_mask[i] = "0"
        i = i + 1
    end
    if i >= @@next_random_mask.length
       if i >= max_length
          @@next_random_mask = ""
          @@next_sentence = get_next_sentence
       else
          @@next_random_mask << "0"
       end
    else
       @@next_random_mask[i] = get_next_char(@@next_random_mask[i, 1])
    end   
    [(current_sentence), current_random_mask]
  end

def self.get_next_char(curr_char)
  if !@@test then
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
    distance = bit_count(@@orig_digest^digest, @@distance)
#    puts "#{digest} -- #{sentence}"
    if distance <= @@distance then
       @@sentence = sentence
       @@distance = distance
       if @@distance < 50
         @entry = AppEngine::Datastore::Entity.new("Entry")
         @entry[:distance], @entry[:sentence] = @@sentence, @@distance
         AppEngine::Datastore.put(@entry)
       end
       puts "Changed #{@@distance} -- #{@@sentence}"
    end
  end    

  def self.process_batch
    if (batch = get_next_batch)[0] == "" then
      return nil
    end
    if batch[1] == "" then
      compute_hamming(batch[0])
    end
    if @@test then
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
    return [@@distance, @@sentence]
  end
    
  def get_result
    return [@@distance, @@sentence]
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
