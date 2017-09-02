# frozen_string_literal: true

module Gundam
  class SetupVimWordsCommand < Command
    def_delegators :context, :base_dir, :cli_options # context
    def_delegators :context, :repo_service # context with repository

    def run
      teams   = repo_service.org_teams(organization)
      members = teams.map { |team| repo_service.team_members(team.id) }.flatten
      team_names   = teams.map(&:name).sort
      member_names = members.map(&:login).uniq.sort

      io = StringIO.new
      member_names.each { |member_name| io.puts("@#{member_name}") }
      team_names.each { |team_name| io.puts("@#{organization}/#{team_name}") }

      filename = File.join(base_dir, "#{organization}.txt")
      File.write(filename, io.string)
    end

    private

    def organization
      cli_options[:organization].downcase
    end
  end
end
