# frozen_string_literal: true

require_relative 'App/controller'

class Router
  def initialize(client, path, method, body)
    @client = client
    @path = path
    @method = method
    @body = body
  end

  def send_response
    if @method == 'GET'
      Controller.new(@client, @path, @method, @body).index
    elsif @method == 'POST'
      Controller.new(@client, @path, @method, @body).create
    end
  end
end
