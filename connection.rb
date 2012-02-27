require 'rubygems'
require 'socket'
require 'json'

$MAX_MSG_LENGTH = 2 << 15

class Connection 
    def initialize host, port
        @host = host
        @port = port
    end
    def connect 
        @socket = TCPSocket.new @host, @port
    end
    def send_msg msgtype, params
        @socket.puts JSON({msgtype => params})
    end

    def recv_msg
        @socket.recv $MAX_MSG_LENGTH
    end

    def send_recv_msg msgtype, params={}
        send_msg msgtype, params
        JSON.parse recv_msg
    end
end
