# frozen_string_literal: true

require 'spec_helper'

describe Gundam::ShowIssueCommand do
  describe '#run' do
    let(:context)         { double }
    let(:issue_finder)    { double }
    let(:issue)           { create_issue }
    let(:issue_decorated) { double(to_stdout: 'Issue stdout') }
    let(:subject)         { described_class.new(context) }

    describe '#run' do
      before do
        allow(Gundam::IssueFinder).to receive(:new).with(context)
                                                   .and_return(issue_finder)
      end

      it 'outputs the issue' do
        expect(issue_finder).to receive(:find).with(with_comments: true)
                                              .and_return(issue)

        expect(Gundam::IssueDecorator).to receive(:new).with(issue)
                                                       .and_return(issue_decorated)

        expect { subject.run }.to output("Issue stdout\n").to_stdout
      end

      context 'when the issue is not found' do
        it 'returns an error' do
          error = Gundam::IssueNotFound.new('reason')

          expect(issue_finder).to receive(:find).and_raise(error)

          expect { subject.run }.to raise_error(error)
        end
      end
    end
  end
end
