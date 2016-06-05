#!/usr/bin/env ruby

# author: Bill Desmarais bill@witsaid.com
# this code is licenced under the MIT/X11 licence.

require 'rubygems'
require 'ffi-rzmq'

def broker(rep_port, req_port)
  # 
  # creates broker (run in a fork)
  # where req_port is the port that will issue REQs (connected to ROUTER)
  #   and rep_port is the port that will issue REPs (connected to DEALER)
  #
  context = ZMQ::Context.new
  frontend = context.socket(ZMQ::ROUTER)
  backend = context.socket(ZMQ::DEALER)

  frontend.bind('tcp://*:' + rep_port.to_s)
  backend.bind('tcp://*:' + req_port.to_s)

  poller = ZMQ::Device.new(frontend, backend)
end

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
puts "Starting broker"
#Process.spawn("ruby gbroker.rb 5560 5561")
pid = fork {broker(5560, 5561)}
#sleep 5
puts "Starting Hello World server..."
# socket to listen for clients
socket = context.socket(ZMQ::REQ)
error_check(socket.connect("tcp://localhost:5560"))
#puts "Hit return to continue"
#q = gets
#puts "Done sleeping"

10.times do
  puts "Sending string"
  error_check(socket.send_string("Hello"))
  puts "Waiting for response"
  request = ''
  error_check(socket.recv_string(request))

  puts "Received request. Data: #{request.inspect}"

  # Do some 'work'
  sleep 1
end

Process.kill(9, pid)
Process.wait(pid)

