require 'connection'
require 'constants'

$host = 'localhost'
$port = 7116

include Constants

class Client
    def initialize host, port
        @connection = Connection.new host, port #basically a thin socket wrapper
        @callbacks = {}
    end
    def handle type, &callback #inspired by sinatra
        @callbacks[type] = callback
    end


    def send_recv_msg msgtype, data

        # All requests and responses are JSON with the format
        # {msgtype: {data}}
        # The msgtype of the response will always be the msgtype of the request

        msg = @connection.send_recv_msg  msgtype, data # sends a message to the server and returns the response as a Hash
        res_msgtype = msg.keys.first
        @callbacks[res_msgtype.to_sym].call msg[res_msgtype]
    end
    def start
        @connection.connect
    end
end
=begin

client = Client.new $host, $port

client.handle :auth do |data|
    p "Got auth result"

    case data['return'].to_i
    when AuthResult::NO_CONNECTION
        p "No connection, check your settings lol :|"
    when AuthResult::AUTH_FAILED_UNKNOWN_USER
        p "Unknown user :/"
    when AuthResult::AUTH_FAILED_BAD_PASSWORD
        p "wrong pw, noob"
    when AuthResult::AUTH_SUCCESS_NEW
        p "new connection, success"
    when AuthResult::AUTH_SUCCESS_RECONNECT
        p "reconnect, success"
    else
        raise "I didn't expect this return value for auth"
    end

    data['return'].to_i >= AuthResult::AUTH_SUCCESS_NEW
end

client.start

client.send_recv_msg :auth, :username => 'stenno', :password => 'stenno'

=end
