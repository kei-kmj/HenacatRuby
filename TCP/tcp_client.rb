# frozen_string_literal: true

require 'socket'
require 'dotenv'
Dotenv.load

# tcpクライエントクラス
class TcpClient
  # 初期化
  def initialize
    @client = TCPSocket.new(ENV.fetch('WEBSITE', nil), 80)
  end

  def run
    send
    recv
    close
  end

  private

  def send
    request = "GET / HTTP/1.1\r\n"
    request += ENV.fetch('HOST', nil)
    request += "Connection: close\r\n\r\n"

    @client.puts(request)
  end

  def recv
    # サーバーからのデータを受信する
    File.open('client_recv.txt', 'w') do |f|
      while (line = @client.gets)
        f.puts(line)
      end
    end
    # @client.puts('0')
  end

  def close
    @client.close
  end
end

# クライアントの起動
client = TcpClient.new
client.run
