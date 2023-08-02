# frozen_string_literal: true

require 'json'
require 'dotenv/load'
require_relative '../response_generator'

class Controller
  HOST_NAME = ENV.fetch('HOST_NAME')
  PORT = ENV.fetch('PORT')
  TODOS_ROOT = ENV.fetch('TODOS_ROOT', nil)

  def initialize(client, path, method, body = nil)
    @client = client
    @path = path
    @method = method
    @body = body
  end

  def generate_response(status_code, path)
    response_generator = ResponseGenerator.new(@client, status_code, path, HOST_NAME, PORT)
    response_generator.generate_response
  end

  def index
    @path += 'index.html' if @path.end_with?('/')

    if Dir.exist?("#{TODOS_ROOT}#{@path}/")
      @path += '/index.html'
      generate_response('301 Moved Permanently', "#{TODOS_ROOT}#{@path}")
    elsif File.exist?("#{TODOS_ROOT}#{@path}")
      generate_response('200 OK', "#{TODOS_ROOT}#{@path}")
    else
      generate_response('404 Not Found', "#{TODOS_ROOT}/404.html")
    end
  end

  def create
    new_todo = JSON.parse(@body)
    todos_file_path = "#{TODOS_ROOT}/todos.json"

    todos =
      if File.exist?(todos_file_path)
        JSON.parse(File.read(todos_file_path))
      else
        []
      end

    todos.push(new_todo)
    File.write(todos_file_path, JSON.pretty_generate(todos))

    generate_response('200 OK', "#{TODOS_ROOT}/index.html")
  end
end
