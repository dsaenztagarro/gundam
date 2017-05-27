module GithubHelper
  API_FIXTURES_PATH = '../../fixtures/github/api'

  def github_api_v3_response(resource)
    fixture_path = File.expand_path(
      "#{API_FIXTURES_PATH}/v3/responses/#{resource}.json", __FILE__)
    raw_response = File.read(fixture_path)
    response = squish(raw_response)
    raw_json = JSON.parse(response)
    symbolize(raw_json)
  end

  def stub_github_api_v4_request(resource)
    query    = github_api_v4_query(resource)
    response = github_api_v4_response(resource)
    stub_request(:post, "https://api.github.com/graphql").with(
        body: { query: query }.to_json,
        headers: {
          'Authorization' => "bearer #{Gundam.github_access_token}",
          'Content-Type'  => 'application/json',
          'User-Agent'    => 'Gundam GraphQL Connector'
        }
      ).to_return(status: 200, body: response, headers: {})
  end

  private

  # @return [String] a GraphQL query
  def github_api_v4_query(query)
    fixture_path = File.expand_path(
      "#{API_FIXTURES_PATH}/v4/queries/#{query}.graphql", __FILE__)
    query = File.read fixture_path
    squish(query)
  end

  # @return [String] a json response
  def github_api_v4_response(query)
    fixture_path = File.expand_path(
      "#{API_FIXTURES_PATH}/v4/responses/#{query}.json", __FILE__)
    response = File.read fixture_path
    squish(response)
  end

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

  def squish(response)
    response.tr("\n", ' ').squeeze(' ')
  end
end

RSpec.configure do |config|
  config.include GithubHelper
end
