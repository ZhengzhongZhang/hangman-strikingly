require 'rest-client'
require 'json'

class Game
  attr_reader :allowed_fail_times, :number_of_words

  def initialize
    if File.exist? 'status.json'
      @sessionId, @number_of_words, @allowed_fail_times = File.open("status.json") { |f| JSON.load(f) }
    end
    @url = 'https://strikingly-hangman.herokuapp.com/game/on'
    @player_id = 'zzz95@outlook.com'
  end

  def start
    response = post(playerId: @player_id, action: 'startGame')
    @sessionId = response.dig('sessionId')
    @number_of_words = response.dig('data', 'numberOfWordsToGuess')
    @allowed_fail_times = response.dig('data', 'numberOfGuessAllowedForEachWord')
    File.open("status.json", "wb") { |f| JSON.dump([@sessionId, @number_of_words, @allowed_fail_times],f) }
  end

  def give_word
    response = post(sessionId: @sessionId, action: 'nextWord')
    extract_response(response)
  end

  def guess c
    response = post(sessionId: @sessionId, action: 'guessWord', guess: c.upcase)
    extract_response(response)
  end

  def result
    response = post(sessionId: @sessionId, action: 'getResult')
    response['data']
  end

  def submit
    response = post(sessionId: @sessionId, action: 'submitResult')
    response['data']
  end

  private
  def post(param)
    puts param
    response = RestClient.post(@url, param.to_json, content_type: :json,
                               accept: :json)
    JSON.parse(response)
  end

  def extract_response(response)
    word = response.dig('data', 'word')
    total_words = response.dig('data', 'totalWordCount')
    wrong_times = response.dig('data', 'wrongGuessCountOfCurrentWord')
    [word, total_words, wrong_times]
  end
end
