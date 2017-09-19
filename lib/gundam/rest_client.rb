# frozen_string_literal: true

require 'net/http'
require 'json'

module Gundam
  # Rest API Client
  class RestClient
    def initialize(endpoint:, headers:)
      @endpoint = endpoint
      @headers  = headers
    end

    def get(path)
      uri = url_for(path)
      request = Net::HTTP::Get.new(uri, headers)

      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = true if uri.scheme.eql? 'https'
      response = http.request(request)
      process_response(response)
    end

    def post(path, data)
      response = Net::HTTP.post(url_for(path), data.to_json, headers)
      process_response(response)
    end

    def patch(path, data)
      uri = url_for(path)
      request = Net::HTTP::Patch.new(uri, headers)
      request.body = data.to_json

      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = true if uri.scheme.eql? 'https'
      response = http.request(request)
      process_response(response)
    end

    private

    attr_reader :endpoint, :headers

    def url_for(path)
      URI("#{endpoint}#{path}")
    end

    def process_response(response)
      case response
      when Net::HTTPSuccess      then parse_response_body(response)
      when Net::HTTPUnauthorized then raise_unauthorized(response)
      when Net::HTTPClientError
        raise_http_error(response)
      end
    end

    # @param response [Net::HTTPSuccess]
    def parse_response_body(response)
      JSON.parse(unzipped_body(response))
    end

    # @param response [Net::HTTPSuccess]
    def unzipped_body(response)
      if response.header['Content-Encoding'].eql?('gzip')
        Zlib::GzipReader.new(StringIO.new(response.body)).read
      else
        response.body
      end
    end

    # @param response [Net::HTTPUnauthorized]
    def raise_unauthorized(response)
      raise Gundam::Unauthorized.new(:github_api_v4, details: response.body)
    end

    def raise_http_error(response)
      raise Gundam::HTTPError.new(response)
    end
  end
end
