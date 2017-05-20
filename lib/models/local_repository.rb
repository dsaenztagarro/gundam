class LocalRepository
  def self.at(dir)
    Dir.chdir(dir) do
      return unless Dir.exist? '.git'
      `git rev-parse --git-dir`
      return unless $?.exitstatus == 0
      Git::Repository.new(dir)
    end
  end
end
