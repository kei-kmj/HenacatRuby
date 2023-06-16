# frozen_string_literal: true

require 'socket'

class Modoki
  # ドキュメントルートの設定
  DOCUMENT_ROOT = '/mnt/c/mywebsite'

  # 初期化
  def initialize
    @server = TCPServer.open(8001)
    @client = nil
    @path = nil
  end

  def run
    accept
    recv
    send
    close
  end

  private

  def accept
    # クライアントからの接続を待つ
    @client = @server.accept
  end

  def recv
    # クライアントからのHTTPリクエストを受信する
    # 空行が来るまで受信する
    request = @client.gets
    @path = request.split[1] if request.start_with?('GET')
    request = @client.gets until request.chomp.empty?
  end

  def send
    # クライアントにHTTPレスポンスを送信する
    # ファイルが存在する場合は、ファイルの内容を送信する
    # ヘッダーを送信する
    @client.puts("HTTP/1.0 200 OK\r\n")
    @client.puts("Date: #{Time.now.gmtime.strftime('%a, %d %b %Y %H:%M:%S GMT')}\r\n")
    @client.puts("Server: Modoki/0.1\r\n")
    @client.puts("Content-Type: text/html\r\n")
    @client.puts("\r\n")

    # ボディを送信する
    File.open("#{DOCUMENT_ROOT}#{@path}", 'r') do |f|
      f.each_line { |line| @client.puts(line) }
    end
  end

  def close
    # クライアントとの接続を切断する
    @client.close
  end
end

# サーバーの起動
server = Modoki.new
server.run
