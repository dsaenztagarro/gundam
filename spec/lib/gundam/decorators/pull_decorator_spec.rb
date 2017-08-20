require 'spec_helper'

describe Gundam::PullDecorator do
  let(:pull)    { create_pull_expanded }
  let(:subject) { described_class.new(pull) }

  describe '#string' do
    it 'returns the pull description' do
      expect(subject.string).to eq(
        <<~END
          \e[31mnew-feature\e[0m
          Please pull these awesome changes
          \e[36moctokit\e[0m \e[34m2011-04-14 16:00:49 UTC\e[0m 318212279
          Me too
          \e[32msuccess\e[0m \e[36mcontinuous-integration/jenkins\e[0m Build has completed successfully \e[34m2012-07-20T01:19:13Z\e[0m
          \e[32msuccess\e[0m \e[36msecurity/brakeman\e[0m Testing has completed successfully \e[34m2012-07-20T01:19:13Z\e[0m
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
