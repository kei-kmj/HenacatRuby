# frozen_string_literal: true

require_relative 'router'
require_relative 'App/controller'
require 'cgi'

class ServerThread
  def initialize(client)
    @client = client
    @path = nil
    @body = nil
  end

  def process_request
    recv
    response_generator = Router.new(@client, @path, @method, @body)
    response_generator.send_response
    close
  end

  private

  def recv
    request_line = @client.gets
    @method, @path, _http_version = request_line.split
    @path = CGI.unescape(@path)

    return unless @method == 'POST'

    headers = {}
    while (line = @client.gets.chomp) && !line.empty?
      key, value = line.split(': ', 2)
      headers[key] = value
    end
    length = headers['Content-Length'].to_i
    @body = @client.read(length)
  end

  def close
    @client.close
  end
end
