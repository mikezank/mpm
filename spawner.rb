#!/usr/bin/env ruby

Process.spawn('./r.worker.rb')
Process.spawn('./r.worker.rb')
Process.spawn('./rproxbroker.rb')