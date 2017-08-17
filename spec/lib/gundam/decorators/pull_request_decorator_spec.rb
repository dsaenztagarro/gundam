require 'spec_helper'

describe Gundam::PullRequestDecorator do
  let(:issue) { create_pull_request }

  let(:subject) { described_class.new(issue) }

  describe '#string' do
    it 'returns the issue description' do
      expect(subject.string).to eq(
        <<~END
          \e[31mnew-feature\e[0m
          Please pull these awesome changes
          \e[36moctokit\e[0m \e[34m2011-04-14 16:00:49 UTC\e[0m 318212279
          Me too
        END
      )
    end
  end

  describe '#string_on_create' do
    it 'returns the expected string' do
      expect(subject.string_on_create).to eq(
        "\e[32mhttps://github.com/octocat/Hello-World/pull/1347\e[0m")
    end
  end
end
