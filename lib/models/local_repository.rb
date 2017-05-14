class LocalRepository
  def self.current
    target_dir = Dir.pwd

    return unless Dir.exists? '.git' ||
                  (`git rev-parse --git-dir` && $?.exitstatus == 0)
    Git::Repository.new(target_dir)
  end
end
