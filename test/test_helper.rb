class Word
  def initialize(word)
    @answer = word.upcase
    @word = '*' * word.size
  end

  def get_word
    @word
  end

  def guess c
    c = c.upcase
    @answer.chars.each_with_index {|e,i| @word[i] = c if @answer[i] == c}
    @word
  end

  def is_right?
    !@word.include? '*'
  end
end
