class Dict
  attr_reader :words, :words_map

  def initialize
    @words = File.read(__dir__ + '/../words.txt').upcase.strip.split
    @words_map = @words.group_by(&:size)
  end

  def get_word(size = nil)
    return @words.sample if size.nil?
    @words_map[size].sample
  end
end
