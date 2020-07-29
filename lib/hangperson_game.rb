class HangpersonGame

  # add the necessary class methods, attributes, etc. here
  # to make the tests in spec/hangperson_game_spec.rb pass.

  # Get a word from remote "random word" service
  attr_accessor :word
  attr_accessor :guesses
  attr_accessor :wrong_guesses
  attr_accessor :count
  # def initialize()
  # end

  def initialize(word)
    @word = word
    @guesses =  ''
    @wrong_guesses = ''
  end

  def guess(letter)
    dummy = @word.clone
    #check input is invalid
    if letter.nil?
      raise ArgumentError, "Invalid Guess"
    end
    if letter =~ /[^a-zA-z]/ || letter.empty?
      raise ArgumentError, "Invalid Guess"
    end
    letter = letter.downcase
    #flag to check if a match happened
    flag = false
    letter.each_char do |b|
      #check that guesses/ wrong_guesses contain b
      @guesses.each_char do |a|
        if b  == a
          return false
        end
      end
      @wrong_guesses.each_char do |a|
        if b  == a
          return false
        end
      end
      dummy.each_char do |a|
        if b == a && !@guesses.include?(a)
          @guesses << b
          flag =  true
          dummy.tr!(a, '*')
        end
      end
      if !flag
        @wrong_guesses << b
      end
    end
    return ( flag || false )
  end

  def word_with_guesses
    output = ''
    @word.each_char do |a|
      flag = false
      @guesses.each_char do |b|
        if b == a
          output += b
          flag = true
        end
      end
      if !flag
        output +='-'
      end
    end
    return output
  end

def check_win_or_lose
  if self.word_with_guesses == @word
    return :win
  elsif @wrong_guesses.length >=7
    return :lose
  else
    return :play
  end
end
  # You can test it by running $ bundle exec irb -I. -r app.rb
  # And then in the irb: irb(main):001:0> HangpersonGame.get_random_word
  #  => "cooking"   <-- some random word
  def self.get_random_word
    require 'uri'
    require 'net/http'
    uri = URI('http://watchout4snakes.com/wo4snakes/Random/RandomWord')
    Net::HTTP.new('watchout4snakes.com').start { |http|
      return http.post(uri, "").body
    }
  end

end
