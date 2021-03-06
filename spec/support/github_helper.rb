module GithubHelper
  API_FIXTURES_PATH = '../../fixtures/github/api'

  def github_api_v3_response(resource)
    fixture_path = File.expand_path(
      "#{API_FIXTURES_PATH}/v3/responses/#{resource}.json", __FILE__
    )
    raw_response = File.read(fixture_path)
    response = squish(raw_response)
    raw_json = JSON.parse(response)
    symbolize(raw_json)
  end

  # @param resource [String] The stubbed query
  # @param [Hash] options the options for http response
  # @option options [Integer] :status The http status
  # @option options [Integer] :response The body of the response
  # @option options [Hash] :headers The headers of the response
  def stub_github_api_v4_request(resource, options = {})
    query    = github_api_v4_query(resource)

    # response attributes
    status   = options.fetch(:status, 200)
    response = options.fetch(:response, github_api_v4_response(resource))
    headers  = options.fetch(:headers, {})

    stub_request(:post, 'https://api.github.com/graphql').with(
      body: { query: query }.to_json,
      headers: {
        'Authorization'   => "bearer #{Gundam.github_access_token}",
        'Content-Type'    => 'application/json',
        'Accept-Encoding' => 'gzip',
        'User-Agent'      => 'Gundam GitHub GraphQL Connector'
      }
    ).to_return(status: status, body: response, headers: headers).times(1)
  end

  def stub_github_api_v4_request_compressed(resource)
    options = {
      response: gzip(github_api_v4_response(resource)),
      headers: {
        'Content-Encoding' => 'gzip'
      }
    }
    stub_github_api_v4_request(resource, options)
  end

  def gzip(string)
    wio = StringIO.new('w')
    w_gz = Zlib::GzipWriter.new(wio)
    w_gz.write(string)
    w_gz.close
    compressed = wio.string
  end

  private

  # @return [String] a GraphQL query
  def github_api_v4_query(query)
    fixture_path = File.expand_path(
      "#{API_FIXTURES_PATH}/v4/queries/#{query}.graphql", __FILE__
    )
    query = File.read fixture_path
    squish(query)
  end

  # @return [String] a json response
  def github_api_v4_response(query)
    fixture_path = File.expand_path(
      "#{API_FIXTURES_PATH}/v4/responses/#{query}.json", __FILE__
    )
    response = File.read fixture_path
    squish(response)
  end

  # Standalone method
  def symbolize(obj)
    if obj.is_a? Hash
      return obj.reduce({}) do |memo, (k, v)|
        memo.tap { |m| m[k.to_sym] = symbolize(v) }
      end
    end

    if obj.is_a? Array
      return obj.each_with_object([]) do |v, memo|
        memo << symbolize(v)
      end
    end

    obj
  end

  def squish(response)
    response.tr("\n", ' ').squeeze(' ')
  end
end

RSpec.configure do |config|
  config.include GithubHelper
end
