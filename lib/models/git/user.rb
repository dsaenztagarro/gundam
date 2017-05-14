module Git
  class User
    def initialize(repo)
      @repo = repo
    end

    def email(repo = nil)
      if !local_user_email(repo.dir).empty?
        local_user_email
      elsif !global_user_email.empty?
        global_user_email
      else
        git_author_email
      end
    end

    private

    def local_user_email(dir)
      Dir.chdir(dir) do
        `git config --local user.email`.chomp
      end
    end

    def global_user_email
      @global_user_email ||= `git config --global user.email`.chomp
    end

    def git_author_email
      @git_author_email ||= `echo $GIT_AUTHOR_EMAIL`.chomp
    end
  end
end
