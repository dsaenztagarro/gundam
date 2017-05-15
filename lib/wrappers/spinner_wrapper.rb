require 'tty-spinner'

class SpinnerWrapper
  def initialize
    @spinner = TTY::Spinner.new("[:spinner] :title")
  end

  def spin(task_name)
    @spinner.reset
    @spinner.update(title: task_name)
    @spinner.auto_spin
    result = yield if block_given?
    @spinner.success('(success)')
    result
  rescue Exception => error
    @spinner.error('(error)')
    raise error
  end
end
