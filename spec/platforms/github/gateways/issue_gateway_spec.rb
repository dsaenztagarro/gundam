require 'spec_helper'

describe Platforms::Github::IssueGateway do
  let(:resource) { github_api_v3_resource :get_issue }
  let(:subject)  { described_class.new(resource) }

  describe '#to_h' do
    it 'returns true' do
      expect(subject.to_h).to eq({
        title: "Found a bug"
      })
    end
  end
end
