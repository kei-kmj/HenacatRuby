# frozen_string_literal: true

require_relative 'response_generator'
require 'pathname'
require 'cgi'

class ServerThread
  def initialize(client)
    @client = client
    @path = nil
  end

  def process_request
    recv
    ResponseGenerator.new(@client, @path).send_response
    close
  end

  private

  def recv
    request = @client.gets
    @path = request.split[1] if request.start_with?('GET')
    request = @client.gets until request.chomp.empty?
    @path = CGI.unescape(@path)
  end

  def close
    @client.close
  end
end
