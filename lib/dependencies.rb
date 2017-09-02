require 'English' # needed by $CHILD_STATUS
require 'erb'
require 'forwardable'
require 'stringio'
require 'byebug'

require_relative 'gundam/helpers/colorize_helper'
require_relative 'gundam/helpers/text_helper'
require_relative 'gundam/errors'
require_relative 'gundam/error_handler'
require_relative 'gundam/configurable'
require_relative 'gundam/command_context'
require_relative 'gundam/command_runner'
require_relative 'gundam/context_provider'
require_relative 'gundam/document'
require_relative 'gundam/context/with_repository'
require_relative 'gundam/commands/command'
require_relative 'gundam/commands/plugin'
require_relative 'gundam/commands/shared/decorator_helper'
require_relative 'gundam/commands/shared/file_helper'
require_relative 'gundam/commands/shared/issue_template'
require_relative 'gundam/commands/comments/create'
require_relative 'gundam/commands/comments/update'
require_relative 'gundam/commands/issues/create_issue_command'
require_relative 'gundam/commands/issues/show_issue_command'
require_relative 'gundam/commands/issues/update_issue_command'
require_relative 'gundam/commands/pulls/create_pull_command'
require_relative 'gundam/commands/pulls/create_pull_plugin'
require_relative 'gundam/commands/pulls/show_pull_command'
require_relative 'gundam/commands/pulls/update_pull_command'
require_relative 'gundam/commands/vim/setup_vim_words_command'
require_relative 'gundam/commands/shared/issue_template'
require_relative 'gundam/decorators/helpers/issue_helper'
require_relative 'gundam/decorators/decorator'
require_relative 'gundam/decorators/issue_decorator'
require_relative 'gundam/decorators/pull_decorator'
require_relative 'gundam/decorators/commit_status_decorator'
require_relative 'gundam/decorators/comment_decorator'
require_relative 'gundam/errors/base_dir_not_found'
require_relative 'gundam/errors/issue_not_found'
require_relative 'gundam/errors/local_repo_not_found'
require_relative 'gundam/errors/pull_request_for_branch_not_found'
require_relative 'gundam/errors/pull_not_found'
require_relative 'gundam/errors/unauthorized'
require_relative 'gundam/factories/repo_service_factory'
require_relative 'gundam/models/combined_status_ref'
require_relative 'gundam/models/commit_status'
require_relative 'gundam/models/issue'
require_relative 'gundam/models/comment'
require_relative 'gundam/models/label'
require_relative 'gundam/models/local_repository'
require_relative 'gundam/models/pull'
require_relative 'gundam/models/remote_repository'
require_relative 'gundam/models/team'
require_relative 'gundam/models/team_member'
require_relative 'gundam/services/issue_finder'
require_relative 'gundam/services/pull_finder'
require_relative 'gundam/factories/repo_service_factory'
require_relative 'gundam/git/repository'
