# frozen_string_literal: true

require 'spec_helper'

describe Gundam::CommandRunner do
  let(:context) { double('Context') }

  let(:command_class) { double('CommandClass') }
  let(:command) { double('Command') }

  let(:context_provider) { double('ContextProvider') }

  describe '#run' do
    before { subject.context_provider = context_provider }

    it 'runs the command' do
      expect(context_provider).to receive(:cli_options=).with({}).ordered
      expect(context_provider).to receive(:command_options=).with({}).ordered
      expect(context_provider).to receive(:load_context).and_return(context).ordered

      expect(command_class).to receive(:new).with(context).and_return(command)
      expect(command).to receive(:run)

      subject.run(command: command_class)
    end
  end
end
