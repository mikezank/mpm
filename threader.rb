#!/usr/bin/env ruby

# author: Oleg Sidorov <4pcbr> i4pcbr@gmail.com
# this code is licenced under the MIT/X11 licence.

require 'rubygems'
require 'ffi-rzmq'



thread1 = Thread.new{

context = ZMQ::Context.new
socket = context.socket(ZMQ::REP)
socket.connect('tcp://localhost:5560')

loop do
  socket.recv_string(message = '')
  puts "Received request: #{message}"
  socket.send_string('World')
end

}

thread2 = Thread.new{
  
  context = ZMQ::Context.new
  frontend = context.socket(ZMQ::ROUTER)
  backend = context.socket(ZMQ::DEALER)

  frontend.bind('tcp://*:5559')
  backend.bind('tcp://*:5560')

  poller = ZMQ::Device.new(frontend, backend)
}

thread1.join