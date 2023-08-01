# frozen_string_literal: true

class ResponseGenerator
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

  def initialize(client, status_code, file_path, host_name, port)
    @client = client
    @status_code = status_code
    @file_path = file_path
    @host_name = host_name
    @port = port
  end

  def generate_response
    response = "HTTP/1.0 #{@status_code}\r\n"
    response += "Date: #{Time.now.gmtime.strftime('%a, %d %b %Y %H:%M:%S GMT')}\r\n"
    response += "Server: Chokotra/0.1\r\n"

    if @status_code.start_with?('3')
      response += "Location: http://#{@host_name}:#{@port}#{@file_path}\r\n"
      response += "\r\n"
    else
      response += "Content-Type: #{content_type}\r\n"
      response += "\r\n"

      content = read_file
      response += content
    end
    @client.puts(response)
  end

  private

  def read_file
    content = ''
    File.open(@file_path, 'r') do |file|
      file.each_line { |line| content += line }
    end
    content
  end

  def content_type
    ext = @file_path.split('.')[-1]
    EXTENSION_TO_MIME[ext] || 'text/html'
  end
end
