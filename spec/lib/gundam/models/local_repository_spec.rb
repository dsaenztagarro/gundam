require 'spec_helper'

describe LocalRepository do
  let(:repository) do
    double('Git::Repository', owner: 'octocat',
                              full_name: 'octocat/Hello-World',
                              current_branch: '1347-new-feature',
                              platform_constant_name: 'Github')
  end
  let(:service) { double }
  let(:factory) { double }
  let(:subject) { described_class.new(repository) }

  describe '#current_pull' do
    before do
      allow(PlatformServiceFactory).to receive(:with_platform).with('Github')
        .and_return(factory)
      allow(factory).to receive(:build).and_return(service)
    end

    it 'returns the pull' do
      pull = double('Pull')

      expect(service).to receive(:pull_requests)
        .with('octocat/Hello-World', status: 'open', head: 'octocat:1347-new-feature')
        .and_return([pull])

      expect(subject.current_pull).to eq(pull)
    end
  end

  describe '#current_issue' do
    context 'when Github remote repository' do
      context 'and REST API v3' do
        let(:client) { double('Octokit::Client') }
        let(:service) { Gundam::Github::API::V3::Gateway.new }

        before do
          allow(client).to receive(:issue).with('octocat/Hello-World', 1347)
            .and_return(github_api_v3_response :get_issue)

          allow(Gundam::Github::API::V3::Gateway).to receive(:new_client)
            .and_return(client)
        end

        it 'returns the issue' do
          issue = subject.current_issue
          expect(issue).to be_a(Gundam::Issue)
          expect(issue.number).to eq(1347)
          expect(issue.title).to eq('Found a bug')
          expect(issue.body).to eq("I'm having a problem with this.")
        end
      end
    end
  end
end
