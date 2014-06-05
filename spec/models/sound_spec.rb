require 'spec_helper'

describe Sound do

  describe '#name' do
    it "returns the `name` attribute's value" do
      sound = Sound.new(name: 'Test Mike')
      expect(sound.name).to eq('Test Mike')
    end

    context 'when the `name` attribute is blank' do
      it "returns the sound file's name" do
        sound_file = File.open File.join(fixture_path, 'sounds', 'sample.wav')
        sound = Sound.new sound: sound_file
        expect(sound.name).to eq('sample.wav')
      end
    end
  end

end
