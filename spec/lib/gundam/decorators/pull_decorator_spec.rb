# frozen_string_literal: true

require 'spec_helper'

describe Gundam::PullDecorator do
  let(:pull)    { create_pull_expanded }
  let(:subject) { described_class.new(pull) }

  describe '#to_stdout' do
    it 'returns the pull description' do
      expect(subject.to_stdout).to eq(
        <<~OUTPUT
          <title>new-feature</title>
          <content>Please pull these awesome changes</content>
          <user>octokit</user> <date>14/04/2011 16:00</date> <id>318212279</id>
          <content>Me too</content>
          <success>success</success> continuous-integration/jenkins Build has completed successfully <date>20/07/2012 01:19</date>
          <success>success</success> security/brakeman Testing has completed successfully <date>20/07/2012 01:19</date>
        OUTPUT
      )
    end
  end

  describe '#string_on_create' do
    it 'returns the expected string' do
      expect(subject.string_on_create).to eq(
        '<uri>https://github.com/octocat/Hello-World/pull/1347</uri>'
      )
    end
  end
end
