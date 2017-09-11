# frozen_string_literal: true

require 'spec_helper'

describe Gundam::SolarizedTheme do
  let(:subject) { described_class.new }

  describe '#as_title' do
    it 'returns text formatted as a title' do
      expect(subject.as_title('Title')).to eq("\e[0;1m\e[38;5;64mTitle\e[m\e[m")
    end
  end

  describe '#as_user' do
    it 'returns text formatted as a user' do
      expect(subject.as_user('User')).to eq("\e[0;1m\e[38;5;166mUser\e[m\e[m")
    end
  end

  describe '#as_date' do
    it 'returns date formatted' do
      expect(subject.as_date(Time.parse('13/12/1979 07:00:59Z UTC'))).to eq("\e[0;1m\e[38;5;136m13/12/1979 07:00\e[m\e[m")
    end
  end

  describe '#as_id' do
    it 'returns text formatted as an id' do
      expect(subject.as_id('1234567890')).to eq("\e[0;1m\e[38;5;61m1234567890\e[m\e[m")
    end
  end

  describe '#as_uri' do
    it 'returns text formatted as an uri' do
      expect(subject.as_uri('http://www.google.com')).to eq("\e[38;5;64mhttp://www.google.com\e[m")
    end
  end

  describe '#as_success' do
    it 'returns text formatted with success state' do
      expect(subject.as_success('SUCCESS')).to eq("\e[38;5;64mSUCCESS\e[m")
    end
  end

  describe '#as_error' do
    it 'returns text formatted with error state' do
      expect(subject.as_error('ERROR')).to eq("\e[38;5;124mERROR\e[m")
    end
  end

  describe '#as_content' do
    context 'when theme has wrapped content option' do
      let(:subject) { described_class.new(wrapped_content: true) }

      it 'wraps content to default number of columns' do
        text = 'This is a very very long text that it should be ' \
               'wrapped to be displayed properly on a terminal ' \
               'emulator, so the developer can read this quickly.'

        wrapped_text = <<~TEXT
          This is a very very long text that it should be wrapped to be displayed properly
          on a terminal emulator, so the developer can read this quickly.
        TEXT

        expect(subject.as_content(text)).to eq(wrapped_text.strip)
      end
    end

    context 'when theme has not wrapped content option' do
      it 'returns the original text' do
        text = 'This is a very very long text that it should be ' \
               'wrapped to be displayed properly on a terminal ' \
               'emulator, so the developer can read this quickly.'

        expect(subject.as_content(text)).to eq(text)
      end
    end
  end
end
