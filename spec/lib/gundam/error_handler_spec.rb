# frozen_string_literal: true

require 'spec_helper'

describe Gundam::ErrorHandler do
  describe '.handle' do
    context 'when is a controlled error' do
      let(:error) { Gundam::Error.new('Message') }

      it 'returns the error message' do
        expected_stdout = <<~STDOUT
          <error>ERROR:
          Message
          </error>
        STDOUT

        expect do
          described_class.handle(error)
        end.to output(expected_stdout).to_stdout
      end
    end

    context 'when is not a controlled error' do
      let(:error) { StandardError.new('Message') }

      it 'returns the error message' do
        expected_stdout = <<~STDOUT
          <error>ERROR:
          Message

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
