#!/usr/bin/env ruby

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
if ARGV[0] == 'local'
  puts "Running client in local mode"
  addr = "tcp://localhost:5561"
else
  addr = "tcp://45.79.199.41:5561"
end

# Socket to talk to server
puts "Connecting to broker"
requester = context.socket(ZMQ::REP)
error_check(requester.connect(addr))

while true do
  puts "Waiting for command"
  reply = ''
  error_check(requester.recv_string(reply))
  
  puts "Received command: [#{reply}]"
  puts "Sending reply"
  error_check(requester.send_string("World"))

end