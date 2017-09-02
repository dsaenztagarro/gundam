# frozen_string_literal: true

module Gundam
  class Unauthorized < StandardError
    def initialize(resource, options = {})
      @resource = resource
      @options = options
    end

    def user_message
      "Unauthorized access to #{resource_name}"
    end

    private

    attr_reader :resource

    def resource_name
      case resource
      when :github_api_v3 then 'Github REST API V3'
      when :github_api_v4 then 'Github GraphQL API V4'
      end
    end
  end
end
