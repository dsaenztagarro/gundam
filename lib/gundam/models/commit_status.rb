module Gundam
  class CommitStatus
    attr_reader \
      :context,
      :created_at,
      :description,
      :state,
      :target_url,
      :updated_at

    def initialize(options = {})
      @context     = options[:context]
      @created_at  = options[:created_at]
      @description = options[:description]
      @state       = options[:state]
      @target_url  = options[:target_url]
      @updated_at  = options[:updated_at]
    end
  end
end
