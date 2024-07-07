# frozen_string_literal: true

require_relative 'words'

# Game class to do nearly everything ;)
class Game
  def initialize
    @lifes = 8
    @game_won = false
  end

  def receive_random_word
    @word = Words.new.return_random_word
    @word_array = Array.new(@word.length, '_')
    # p @word
    p @word_array
  end

  def ask_for_letter
    p 'Do you dare to give me a letter?'
    gets.chomp
  end

  def check_if_letter_in_random_word(letter)
    if @word.include?(letter)
      @word.split('').each_with_index do |character, index|
        @word_array[index] = letter if character == letter
      end
      process_letter_in_random_word
    else
      process_letter_not_in_random_word
    end
  end

  def process_letter_in_random_word
    p 'This was a correct guess. Congrats!'
    show_current_status
    return unless @word_array == @word.split('')

    @game_won = true
    p 'You have won this game. I am impressed'
  end

  def process_letter_not_in_random_word
    @lifes -= 1
    p "That was an incorrect guess. You have #{@lifes} lifes left.."
    show_current_status
  end

  def show_current_status
    p 'Current status of guessed characters:'
    p @word_array
  end

  def play_round
    check_if_letter_in_random_word(ask_for_letter)
  end

  def show_lose_message
    p "This was your last life. It's over now.."
    p "The word to be guessed was #{@word}"
  end

  def play
    receive_random_word
    play_round while @lifes.positive? && !@game_won
    show_lose_message if @lifes.zero?
  end
end