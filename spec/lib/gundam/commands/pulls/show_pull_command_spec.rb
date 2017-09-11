# frozen_string_literal: true

require 'spec_helper'

describe Gundam::ShowPullCommand do
  describe '#run' do
    let(:context)        { double }
    let(:pull_finder)    { double }
    let(:pull)           { create_pull }
    let(:pull_decorated) { double(to_stdout: 'Pull stdout') }
    let(:subject)        { described_class.new(context) }

    describe '#run' do
      before do
        allow(Gundam::PullFinder).to receive(:new).with(context).and_return(pull_finder)
      end

      it 'outputs the pull' do
        expect(pull_finder).to receive(:find).and_return(pull)

        expect(Gundam::PullDecorator).to receive(:new).with(pull).and_return(pull_decorated)

        expect { subject.run }.to output("Pull stdout\n").to_stdout
      end
    end
  end
end
