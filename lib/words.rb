# frozen_string_literal: true

# Words class to load all words and return random
class Words
  def initialize
    @contents = File.read('google-10000-english-no-swears.txt').split
  end

  def return_random_word
    # @contents.sample
    reduced_words = @contents.filter_map do |word|
      word if word.length >= 5 && word.length <= 12
    end
    reduced_words.sample
  end
end

words = Words.new
p words.return_random_word
