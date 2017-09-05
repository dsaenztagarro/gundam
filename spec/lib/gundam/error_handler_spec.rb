# frozen_string_literal: true

require 'spec_helper'

describe Gundam::ErrorHandler do
  describe '.handle' do
    context 'when original error' do
      let(:error) { StandardError.new('message-error') }
      it 'returns the error message' do
        expect do
          described_class.handle(error)
        end.to output("\e[31mmessage-error\e[0m\n").to_stdout
      end
    end
  end
end
