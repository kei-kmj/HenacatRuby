# frozen_string_literal: true

require 'socket'

# tcpサーバークラス
class TcpServer
  # 初期化
  def initialize
    @server = TCPServer.open(8001)
    @client = nil
  end

  def run
    accept
    recv
    send('server_send.txt')
    close
  end

  private

  def accept
    puts 'waiting for connection...'
    # クライアントからの接続を待つ
    @client = @server.accept
  end

  # クライアントからのデータを受信する
  def recv
    puts ' connected '
    # 受け取った内容をsever_recv.txtに書き込む
    File.open(' server_recv.txt ', ' w ') do |f|
      while line = @client.gets
        break if line.chomp == '0'

        f.write(line)
      end
    end
  end

  # クライアントにデータを送信する
  def send(_data)
    # server_send.txtの内容をクライアントにデータを送信する
    File.open(' server_send.txt ', ' r ') do |f|
      while line = f.gets
        @client.puts(line)
      end
    end
  end

  def close
    # クライアントから0を受け取ったら、クライアントとの接続を切断する
    @client.close
  end
end

# サーバーの起動
server = TcpServer.new
server.run
