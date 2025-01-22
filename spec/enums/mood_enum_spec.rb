require 'rails_helper'

RSpec.describe MoodEnum do
  describe '.mood_key_from_string' do
    context 'when a valid mood string is passed' do
      it 'returns the corresponding symbol' do
        expect(MoodEnum.mood_key_from_string('not_good_at_all')).to eq(:not_good_at_all)
        expect(MoodEnum.mood_key_from_string('a_bit_meh')).to eq(:a_bit_meh)
        expect(MoodEnum.mood_key_from_string('pretty_good')).to eq(:pretty_good)
        expect(MoodEnum.mood_key_from_string('feeling_great')).to eq(:feeling_great)
      end
    end

    context 'when an invalid mood string is passed' do
      it 'returns nil' do
        expect(MoodEnum.mood_key_from_string('unknown_mood')).to be_nil
        expect(MoodEnum.mood_key_from_string('')).to be_nil
      end
    end
  end
end
