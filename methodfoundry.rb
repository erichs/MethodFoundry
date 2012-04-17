#!/usr/bin/env ruby
# DESCRIPTION: Tries (hard) to do something with unrecognized shell input.
#
#              Examines all OpenStruct Matches, emitting a replacement
#              command string when a Bash input match is found.  If
#              multiple matches are found, the user is prompted to select
#              one.
#
# CREDITS:     Based on ideas from
#              Bodaniel Jeanes http://github.com/bjeanes/dot-files
#              and Geoffrey Grosenbach http://peepcode.com
#
# AUTHOR:      Erich Smith

require 'ostruct'
require '~/conf/matchheads.rb'  # all match objects are defined here

def main(bashcmd)
  matchbook = []  # find all command matches
  ObjectSpace.each_object(OpenStruct) do |m|
    matchbook.push m if m.match.( bashcmd )
  end

  unless matchbook.empty?
    selection = select_from matchbook  # matchmaker, make me a match!
    abort if selection == 'x'
    match = matchbook[selection.to_i]
    puts match.strike.( bashcmd )
  end
end

def select_from(matchbook)
  return 0 if matchbook.count == 1
  $stderr.puts "found matches:"
  matchbook.each_with_index { |m, i| $stderr.puts "#{i}. #{m.description}" }
  $stderr.puts "x. cancel"
  $stderr.print "Select: "
  STDIN.gets.chomp
end

main(ARGV.join ' ')
