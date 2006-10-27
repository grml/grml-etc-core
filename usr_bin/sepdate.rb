#!/usr/bin/env ruby
require 'date'
print Time.now.strftime("%a Sep #{Date.today-Date.new(1993,8,31)} %H:%M:%S %Z 1993\n")
