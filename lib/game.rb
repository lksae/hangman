# frozen_string_literal: true

require_relative 'words'

require 'json'
require 'date'

# Game class to do nearly everything ;)
class Game
  def initialize
    @lifes = 8
    @game_won = false
  end

  def save_game(name)
    save_name_existing = false
    save_name_counter = 0
    saved_game = { 'name' => name, 'lifes' => @lifes, 'word' => @word, 'word_array' => @word_array }.to_json
    File.write('lib/saved_games.txt', saved_game, mode: 'a')
    # file = File.open('lib/saved_games.txt')
    # while line = file.gets do
     # puts line
      #puts JSON.parse(line)
    # end
    #file.puts saved_game
    # file.close
    # saved_game
    #file_data = 
    save_game_array = File.read('lib/saved_games.txt').split
    # puts save_game_array
    save_game_array.each do |game_iteration|
      p game_iteration
    end
    #File.foreach('lib/saved_games.txt') do |line|
    # p file_data
  end

  def receive_random_word
    @word = Words.new.return_random_word
    @word_array = Array.new(@word.length, '_')
    # p @word
    p @word_array.join(' ')
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
    p @word_array.join(' ')
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
    # play_round
    # play_round while @lifes.positive? && !@game_won
    # show_lose_message if @lifes.zero?
  end
end
