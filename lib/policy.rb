require_relative 'dict'

class Policy
  class << self
    def dict
      @dict ||= Dict.new
    end
  end


  def initialize(size)
    @words = self.class.dict.words_map[size]
    @tried = []
    @rejected = []
  end

  def next
    c = most_possible
    @tried << most_possible
    c
  end

  def most_possible
    h = Hash.new(0)
    @words.each do |w|
      w.chars.uniq.each do |c|
        h[c] += 1
      end
    end
    h = h.select{|k,v| !@tried.include?(k)}
    h.max_by{|k,v| v}[0]
  end

  def push(word, success)
    unless success
      @rejected << @tried.last
    end

    origin_size = @words.size
    @words = @words.select do |w|
      match = true
      w.chars.each_with_index do |c, i|
        match = false if @rejected.include?(c) || word[i] != '*' && word[i] != c
      end
      match
    end
    puts "排除了 #{origin_size - @words.size} 个词, 剩余 #{@words.size} 个词"
    puts "符合条件的 #{@words[0..5]}"
  end
end
