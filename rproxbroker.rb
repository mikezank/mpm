#!/usr/bin/env ruby

# author: Oleg Sidorov <4pcbr> i4pcbr@gmail.com
# this code is licenced under the MIT/X11 licence.

require 'rubygems'
require 'ffi-rzmq'

context = ZMQ::Context.new
frontend = context.socket(ZMQ::ROUTER)
backend = context.socket(ZMQ::DEALER)

frontend.bind('tcp://*:5559')
backend.bind('tcp://*:5560')

poller = ZMQ::Device.new(frontend, backend)
