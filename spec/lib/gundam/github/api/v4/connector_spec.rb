# frozen_string_literal: true

require 'spec_helper'

describe Gundam::Github::API::V4::Connector do
  before { WebMock.disable_net_connect! }

  describe '#issue' do
    context 'when status of response 200' do
      shared_examples 'a github issue' do
        it 'returns the issue' do
          issue = subject.issue('octocat', 'Hello-World', 1347)
          expect(issue).to be_a(Gundam::Issue)
          expect(issue.body).to eq("I'm having a problem with this.")
          expect(issue.repository).to eq('octocat/Hello-World')
          expect(issue.title).to eq('Found a bug')
        end
      end

      context 'and the response is compressed' do
        before do
          stub_github_api_v4_request_compressed(:issue)
        end

        include_examples 'a github issue'
      end

      context 'and the response is not compressed' do
        before { stub_github_api_v4_request(:issue) }

        include_examples 'a github issue'
      end
    end

    context 'when status of response 401' do
      before do
        stub_github_api_v4_request(:issue, status: 401,
                                           response: '{"message":"Bad credentials","documentation_url":"https://developer.github.com/v3"}')
      end

      it 'raises a controlled error' do
        expect do
          subject.issue('octocat', 'Hello-World', 1347)
        end.to raise_error(Gundam::Error)
      end
    end
  end

  describe '#pulls' do
    context 'with the option expanded' do
      before { stub_github_api_v4_request(:pulls_expanded) }

      it 'returns the pulls' do
        pulls = subject.pulls('octocat', 'Hello-World', '1347-new-feature', expanded: true)

        expect(pulls.size).to eq(1)
        pull = pulls.first
        expect(pull).to be_a(Gundam::Pull)
        expect(pull.body).to eq('Please pull these awesome changes')
        expect(pull.title).to eq('new-feature')
        expect(pull.comments.size).to eq(2)

        comment1 = pull.comments.first
        expect(comment1).to be_a(Gundam::Comment)
        expect(comment1.id).to eq(318_212_279)
        expect(comment1.body).to eq('releasing!')
        expect(comment1.created_at).to eq(Time.parse('2017-09-01T10:35:54Z'))
        expect(comment1.author).to eq('dhh')

        comment2 = pull.comments.last
        expect(comment2).to be_a(Gundam::Comment)
        expect(comment2.id).to eq(318_212_280)
        expect(comment2.body).to eq('Thanks @dhh!')
        expect(comment2.created_at).to eq(Time.parse('2017-09-01T10:55:30Z'))
        expect(comment2.author).to eq('matz')
      end
    end
  end

  describe '#rate_limit' do
    before { stub_github_api_v4_request(:rate_limit) }

    it 'returns the rate limits' do
      rate_limit = subject.rate_limit

      expect(rate_limit).to be_a(Gundam::Github::API::V4::RateLimit)
      expect(rate_limit.limit).to eq(5000)
      expect(rate_limit.cost).to eq(1)
      expect(rate_limit.remaining).to eq(4997)
      expect(rate_limit.reset_at).to eq(Time.utc(2017, 9, 1, 7, 40, 34))
    end
  end
end
