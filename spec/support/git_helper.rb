# frozen_string_literal: true

module GitHelper
  def change_to_git_repo
    repo_dir = create_git_repo
    yield(repo_dir) if block_given?
  ensure
    FileUtils.remove_entry repo_dir
  end

  def change_to_git_repo_with_topic_branch
    repo_dir = create_git_repo
    create_topic_branch(repo_dir)
    yield(repo_dir) if block_given?
  ensure
    FileUtils.remove_entry repo_dir
  end

  private

  def create_git_repo
    Dir.mktmpdir.tap do |base_dir|
      Dir.chdir(base_dir) do
        `git init`
        `git remote add origin git@github.com:github/octocat.git`
        `touch A.txt`
        `git add --all`
        `git commit -m "Initial commit"`
      end
    end
  end

  def create_topic_branch(repo_dir)
    Dir.chdir(repo_dir) do
      `git checkout -b 1-topic-branch`
      `echo 'hello world' > A.txt`
      `git commit -m "topic: message"`
    end
  end
end

RSpec.configure do |config|
  config.include GitHelper
end
