#!/usr/bin/env ruby

# author: Bill Desmarais bill@witsaid.com
# this code is licenced under the MIT/X11 licence.

require 'rubygems'
require 'ffi-rzmq'

def error_check(rc)
    if ZMQ::Util.resultcode_ok?(rc)
      false
    else
      STDERR.puts "Operation failed, errno [#{ZMQ::Util.errno}] description [#{ZMQ::Util.error_string}]"
      caller(1).each { |callstack| STDERR.puts(callstack) }
      true
    end
end

context = ZMQ::Context.new(1)

#puts "Starting Hello World server…"

puts "Starting Hello World server..."
# socket to listen for clients
socket = context.socket(ZMQ::REP)
error_check(socket.bind("tcp://*:5560"))
count = 0

while true do
  # Wait for next request from client
  request = ''
  error_check(socket.recv_string(request))

  puts "Received request. Data: #{request.inspect}"

  # Do some 'work'
  sleep 1

  # Send reply back to client
  count += 1
  error_check(socket.send_string("world #{count}"))

end
