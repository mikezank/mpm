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

# Socket to talk to server
puts "Connecting to hello world server…"
requester = context.socket(ZMQ::REQ)
requester.connect("tcp://45.79.199.41:5560")

0.upto(9) do |request_nbr|
  puts "Sending request #{request_nbr}…"
  error_check(requester.send_string("Hello"))

  reply = ''
  error_check(requester.recv_string(reply))
  
  puts "Received reply #{request_nbr}: [#{reply}]"
end