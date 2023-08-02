# frozen_string_literal: true

require 'dotenv/load'

HOST_NAME = ENV['HOST_NAME']
PORT_NUMBER = ENV['PORT_NUMBER']

class ResponseGenerator
  DOCUMENT_ROOT = ENV.fetch('DOCUMENT_ROOT', nil)
  EXTENSION_TO_MIME =
    {
      'html' => 'text/html',
      'txt' => 'text/plain',
      'png' => 'image/png',
      'jpg' => 'image/jpg',
      'jpeg' => 'image/jpeg',
      'gif' => 'image/gif',
      'css' => 'text/css',
      'js' => 'text/javascript'
    }.freeze

  # 初期化
  def initialize(client, path)
    @client = client
    @path = path
  end

  def send_response
    @path += 'index.html' if @path.end_with?('/')

    if Dir.exist?("#{DOCUMENT_ROOT}#{@path}/")
      @path += '/index.html'
      generate_response('301 Moved Permanently', "#{DOCUMENT_ROOT}#{@path}")
    elsif File.exist?("#{DOCUMENT_ROOT}#{@path}")
      generate_response('200 OK', "#{DOCUMENT_ROOT}#{@path}")
    else
      generate_response('404 Not Found', "#{DOCUMENT_ROOT}/404.html")
    end
  end

  private

  def generate_response(status_code, file_path)
    response = "HTTP/1.0 #{status_code}\r\n"
    response += "Date: #{Time.now.gmtime.strftime('%a, %d %b %Y %H:%M:%S GMT')}\r\n"
    response += "Server: Modoki/0.1\r\n"

    if status_code == '301 Moved Permanently'
      response += "Location: http://#{HOST_NAME}:#{PORT_NUMBER}#{@path}\r\n"
      response += "\r\n"
    else

      response += "Content-Type: #{content_type}\r\n"
      response += "\r\n"

      content = read_file(file_path)
      response += content
    end
    @client.puts(response)
  end

  def read_file(file_path)
    content = ''
    File.open(file_path, 'r') do |file|
      file.each_line { |line| content += line }
    end
    content
  end

  def content_type
    ext = @path.split('.')[-1]
    EXTENSION_TO_MIME[ext] || 'text/html'
  end
end
