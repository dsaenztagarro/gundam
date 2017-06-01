class CommitStatus
  attr_reader \
    :context,
    :created_at,
    :description,
    :state,
    :target_url,
    :updated_at

  def initialize(
    context:,
    created_at:,
    description:,
    state:,
    target_url:,
    updated_at:
    )
    @context     = context
    @created_at  = created_at
    @description = description
    @state       = state
    @target_url  = target_url
    @updated_at  = updated_at
  end
end
