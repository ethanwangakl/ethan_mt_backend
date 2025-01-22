module MoodEnum
  MOODS = {
    not_good_at_all: 0,
    a_bit_meh: 1,
    pretty_good: 2,
    feeling_great: 3
  }.freeze

  def self.mood_key_from_string(mood_string)
    mood_string.to_sym if MOODS.key?(mood_string.to_sym)
  end

  def self.key_from_value(value)
    MOODS.key(value)
  end
end
