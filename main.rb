require './lib/game'
require './lib/policy'

game = Game.new

if ARGV.first == 'result'
  puts game.result
  exit
end

if ARGV.first == 'submit'
  puts game.submit
  exit
end

if ARGV.first == 'start'
  game.start
end

word, total, wrong = game.give_word
policy = Policy.new(word.size)
while total <= game.number_of_words
  if word.include?('*') && wrong < game.allowed_fail_times
    guess = policy.next
    word, total, wrong = game.guess guess
    p [word, total, wrong]
    policy.feedback(word, word.include?(guess))
  else
    word, total, wrong = game.give_word
    policy = Policy.new(word.size)
    p [word, total, wrong]
  end
end

