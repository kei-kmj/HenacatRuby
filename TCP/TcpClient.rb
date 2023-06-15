require 'socket'

# tcpクライエントクラス
class TcpClient
  # 初期化
  def initialize
    @client = TCPSocket.open("localhost", 8001)
  end

  def run
    send("client_send.txt")
    recv
    close
  end

  private

  def send(_data)
    # client_send.txtの内容をサーバーに送信する
    File.open("client_send.txt", "r") do |f|
      while line = f.gets
        @client.puts(line)
      end
    end
    # サーバーに0を送信する
    @client.puts("0")
  end

  def recv
    # サーバーからのデータを受信する
    File.open("client_recv.txt", "w") do |f|
      while line = @client.gets
        f.write(line)
      end
    end
  end

  def close
    # サーバーに0を送信する
    @client.close
  end
end

# クライアントの起動
client = TcpClient.new
client.run