# frozen_string_literal: true

class CommitStatusDecorator < Decorator
  def to_s
    <<~STR
      #{success? ? green(state) : red(state)} #{cyan(context)} #{description} #{blue(updated_at)}
    STR
  end

  def success?
    state.eql? 'success'
  end
end
