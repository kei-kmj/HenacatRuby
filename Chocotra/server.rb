# frozen_string_literal: true

require_relative 'server_thread'
require 'socket'

class Server
  def initialize
    @server = TCPServer.open(8001)
  end

  def run
    loop do
      Thread.start(@server.accept) do |client|
        ServerThread.new(client).process_request
      end
    end
  end
end

# サーバーの起動
server = Server.new
server.run
