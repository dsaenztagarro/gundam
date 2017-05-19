module GithubHelper
  def github_api_v3_resource(resource)
    fixture_path = File.expand_path("../../fixtures/github_api_v3/#{resource}.json", __FILE__)
    raw_json = JSON.parse(File.read fixture_path)
    symbolize(raw_json)
  end

  private

  # Standalone method
  def symbolize(obj)
    return obj.reduce({}) do |memo, (k, v)|
      memo.tap { |m| m[k.to_sym] = symbolize(v) }
    end if obj.is_a? Hash

    return obj.reduce([]) do |memo, v|
      memo << symbolize(v); memo
    end if obj.is_a? Array

    obj
  end
end

RSpec.configure do |config|
  config.include GithubHelper
end
