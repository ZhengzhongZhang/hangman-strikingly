require 'minitest/autorun'
require_relative 'test_helper'
require 'policy'
require 'dict'

describe Policy do
  before do
    @d = Dict.new
  end

  80.times do |i|
    it "guess" do
      len = [(2..5), (6..8), (9..12), (12..16)][i/20].to_a.sample
      to_guess = @d.get_word(len)

      word = Word.new(to_guess)
      w = word.get_word
      policy = Policy.new(w.size)
      # puts "\nguess #{w}---------------------"
      10.times do
        guess = policy.next
        # puts "guess: #{guess}"
        w = word.guess guess
        # puts "result: #{w}"
        break if word.is_right?
        policy.feedback(w, w.include?(guess))
      end
      assert word.is_right?, "fail on #{to_guess}"
    end
  end
end
