require 'httparty'

class BufferApp
  include HTTParty
  base_uri 'https://api.bufferapp.com/1'

  Error = Class.new(StandardError)

  class WrappedError < Error
    attr_reader :original

    def initialize(message, original = $!)
      super(message)
      @original = original
    end
  end

  APIError = Class.new(WrappedError)
  Unauthorized = Class.new(APIError)
  BadRequest = Class.new(APIError)
  NotFound = Class.new(APIError)
  BufferLimitReached = Class.new(APIError)

  Update = Struct.new(:id, :text, :due_at)

  def initialize(options)
    @access_token = options.fetch(:access_token) {
      raise ArgumentError, "access_token is required"
    }

    @profile_id = options.fetch(:profile_id) {
      raise ArgumentError, "profile_id is required"
    }
  end

  def create_update(text)
    response = post '/updates/create.json', "text" => text
    parse_update response['updates'][0]
  end

  def find_update(id)
    response = get "/updates/#{id}.json"
    parse_update response
  end

  def delete_update(id)
    post "/updates/#{id}/destroy.json"
  end

  def get(path, query = {})
    parse_response BufferApp.get(path, :query => authentication_hash.merge(query))
  end

  def post(path, body = {})
    parse_response BufferApp.post(path, :body => authentication_hash.merge(body))
  end

  private

  def parse_response(response)
    ResponseParser.parse response
  end

  def parse_update(response)
    Update.new response['id'], response['text'], Time.at(response['due_at'])
  end

  def authentication_hash
    {
      "access_token"  => @access_token,
      "profile_ids[]" => @profile_id
    }
  end
end

require 'buffer_app/version'
require 'buffer_app/response_parser'
