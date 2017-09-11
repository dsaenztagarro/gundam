require 'spec_helper'

describe Gundam::SolarizedTheme do
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

        expect(subject.as_content(text)).to eq(wrapped_text.strip!)
      end
    end
  end
end
