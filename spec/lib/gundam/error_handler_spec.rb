# frozen_string_literal: true

require 'spec_helper'

describe Gundam::ErrorHandler do
  describe '.handle' do
    context 'when original error' do
      let(:error) { StandardError.new('This is an error') }
      it 'returns the error message' do
        expected_stdout = <<~STDOUT
          <error>ERROR:
          This is an error

          BACKTRACE:
          </error>
        STDOUT

        expect do
          described_class.handle(error)
        end.to output(expected_stdout).to_stdout
      end
    end
  end
end
