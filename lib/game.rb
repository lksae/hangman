# frozen_string_literal: true

require_relative 'words'

require 'json'
require 'date'

# Game class to do nearly everything ;)
class Game
  def initialize
    @lifes = 8
    @game_over = false
  end

  def check_for_existing_save_games(name)
    file_counter = 1
    save_name_counter = 0
    file = File.open('lib/saved_games.txt').read
    file.each_line do |line|
      save_name_counter += 1 if JSON.parse(line)['name'] == name
      file_counter += 1
    end
    [save_name_counter, file_counter]
  end

  def save_game(name)
    counter = check_for_existing_save_games(name)
    saved_game = { 'ID' => counter[1],'name' => name, 'save_name_counter' => counter[0], 'lifes' => @lifes, 'word' => @word,
                   'word_array' => @word_array, 'time' => Time.now.strftime('%d/%m/%Y %H:%M') }.to_json
    File.write('lib/saved_games.txt', "#{saved_game} \n", mode: 'a')
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

    @game_over = true
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
    ask_to_save_game
    return if @save_game_answer == 'yes'

    check_if_letter_in_random_word(ask_for_letter)
  end

  def show_lose_message
    p "This was your last life. It's over now.."
    p "The word to be guessed was #{@word}"
  end

  def ask_to_save_game
    puts 'Do you want to save and end the game? yes or no'
    @save_game_answer = gets.chomp
    return unless @save_game_answer == 'yes'

    puts 'How do you want to call the saved game?'
    name = gets.chomp
    save_game(name)
    @game_over = true
  end

  def ask_to_load_game
    puts 'Do you want to load an existing game? yes or no'
    @load_game_answer = gets.chomp
    display_saved_games if @load_game_answer == 'yes'
  end

  def display_saved_games
    file = File.open('lib/saved_games.txt').read
    puts 'Please enter the ID of the file you want to load.'
    file.each_line do |line|
      puts "ID: #{JSON.parse(line)['ID']} Name: #{JSON.parse(line)['name']} Lifes: #{JSON.parse(line)['lifes']} Date: #{JSON.parse(line)['time']}" # rubocop:disable Layout/LineLength
    end
    answer = gets.chomp
    load_selected_game(answer)
  end

  def load_selected_game(id)
    file = File.open('lib/saved_games.txt').read
    file.each_line do |line|
      next unless id == JSON.parse(line)['ID'].to_s

      @lifes = JSON.parse(line)['lifes']
      @word = JSON.parse(line)['word']
      @word_array = JSON.parse(line)['word_array']
    end
  end

  def play
    ask_to_load_game # prevent loading when no save games exist
    receive_random_word if @load_game_answer != 'yes'
    # play_round
    play_round while @lifes.positive? && !@game_over
    show_lose_message if @lifes.zero?
  end
end
