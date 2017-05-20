class SpinnerWrapperDummy
  def spin(task_name)
    yield if block_given?
  end
end
