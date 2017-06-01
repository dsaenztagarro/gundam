require_relative 'decorator'

class CommitStatusDecorator < Decorator
  def to_s
    <<~END
    #{success? ? green(state) : red(state)} #{cyan(context)} #{description} #{blue(updated_at)}
    END
  end

  def success?
    state.eql? 'success'
  end
end
