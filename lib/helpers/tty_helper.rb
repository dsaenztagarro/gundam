require 'tty-spinner'

module TTYHelper
  def spin(task_name)
    spinner = TTY::Spinner.new("[:spinner] #{task_name}")
    spinner.auto_spin
    result = yield if block_given?
    spinner.success('(success)')
    result
  rescue Exception => error
    spinner.error('(error)')
    raise error
  end
end
