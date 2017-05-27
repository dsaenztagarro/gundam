module GithubHelper
  API_FIXTURES_PATH = '../../fixtures/github/api'

  def stub_graphql_request(resource)
    query    = graphql_api_v4_query(resource)
    response = graphql_api_v4_response(resource)

    stub_request(:post, "https://api.github.com/graphql").
      with(body: { query: query }.to_json,
           headers: {'Accept'=>'*/*', 'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'Authorization'=>'bearer 87abd86b2108c599d9241618794662061b93dc9a', 'Content-Type'=>'application/json', 'User-Agent'=>'Ruby'}).
      to_return(status: 200, body: response, headers: {})
  end

  private

  def rest_api_v3_response(resource)
    fixture_path = File.expand_path(
      "#{API_FIXTURES_PATH}/v3/responses/#{resource}.json", __FILE__)
    raw_json = JSON.parse(File.read fixture_path)
    symbolize(raw_json)
  end

  def graphql_api_v4_query(query)
    fixture_path = File.expand_path(
      "#{API_FIXTURES_PATH}/v4/queries/#{query}.graphql", __FILE__)
    query = File.read fixture_path
    query.gsub("\n", ' ').squeeze(' ')
  end

  def graphql_api_v4_response(query)
    fixture_path = File.expand_path(
      "#{API_FIXTURES_PATH}/v4/responses/#{query}.json", __FILE__)
    response = File.read fixture_path
    response.gsub("\n", ' ').squeeze(' ')
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
end

RSpec.configure do |config|
  config.include GithubHelper
end
