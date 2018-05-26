# frozen_string_literal: true

require 'spec_helper'

describe Gundam::TextHelper do
  let(:dummy_class) do
    Class.new do
      include Gundam::TextHelper
    end
  end

  let(:subject) { dummy_class.new }

  describe '#reformat_wrapped' do
    it 'keeps existing break lines' do
      text = <<~OUT
        There several points to be addressed:
          - [ ] Review comments from PR
          - [ ] Add release note
      OUT

      expect(subject.reformat_wrapped(text)).to eq(text)
    end
  end
end
