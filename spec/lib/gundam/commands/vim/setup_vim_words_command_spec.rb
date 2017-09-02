# frozen_string_literal: true

require 'spec_helper'

describe Gundam::SetupVimWordsCommand do
  let(:base_dir) { Gundam.base_dir }
  let(:repo_service) { double('RepoService') }
  let(:context) do
    double('Context', base_dir: base_dir,
                      cli_options: { organization: 'WATSON' },
                      # context with repository
                      repo_service: repo_service)
  end
  let(:org_teams) do
    [Gundam::Team.new(id: 1, name: 'operations'),
     Gundam::Team.new(id: 2, name: 'devs')]
  end
  let(:team_members_1) do
    [Gundam::TeamMember.new(id: 1, login: 'zuma'),
     Gundam::TeamMember.new(id: 2, login: 'mike')]
  end
  let(:team_members_2) { [Gundam::TeamMember.new(id: 3, login: 'john')] }

  let(:subject) { described_class.new(context) }

  describe '#run' do
    it 'creates a sorted file with login of all team members' do
      allow(repo_service).to receive(:org_teams).with('watson')
                                                .and_return(org_teams)
      allow(repo_service).to receive(:team_members).with(1)
                                                   .and_return(team_members_1)
      allow(repo_service).to receive(:team_members).with(2)
                                                   .and_return(team_members_2)

      subject.run

      filename = File.join(base_dir, 'watson.txt')

      expected_filecontent = <<~END
        @john
        @mike
        @zuma
        @watson/devs
        @watson/operations
      END

      expect(File.exist?(filename)).to eq(true)
      expect(File.read(filename)).to eq(expected_filecontent)
    end
  end
end
