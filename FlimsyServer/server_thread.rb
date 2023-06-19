# frozen_string_literal: true

class ServerThread
  DOCUMENT_ROOT = '/mnt/c/mywebsite'
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

  def initialize(client)
    @client = client
    @path = nil
  end

  def process_request
    recv
    send
    close
  end

  private

  def recv
    request = @client.gets
    @path = request.split[1] if request.start_with?('GET')
    request = @client.gets until request.chomp.empty?
  end

  def send
    @client.puts("HTTP/1.0 200 OK\r\n")
    @client.puts("Date: #{Time.now.gmtime.strftime('%a, %d %b %Y %H:%M:%S GMT')}\r\n")
    @client.puts("Server: Modoki/0.1\r\n")
    @client.puts("Content-Type: #{content_type}\r\n")
    @client.puts("\r\n")

    File.open("#{DOCUMENT_ROOT}#{@path}", 'r') do |f|
      f.each_line { |line| @client.puts(line) }
    end
  end

  def content_type
    ext = @path.split('.')[-1]
    EXTENSION_TO_MIME[ext] || 'text/plain'
  end

  def close
    @client.close
  end
end
