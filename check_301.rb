#! /usr/bin/ruby

require 'rubygems'
require 'FasterCSV'
require 'uri'
require 'httpclient'

input_file = ARGV[0]

sites = nil
httpc = HTTPClient.new

puts "trying to read files"
begin
	sites = FasterCSV.parse(File.read(input_file))
rescue
	puts "There was a problem importing the FasterCSV file. Contact support."
	exit
end

puts "checking #{sites.length} sites. This might take a while."

output_file = "output/301_check_#{Time.now.strftime("%Y-%m-%d_%I%M")}.csv"

def get_uri(start_url)
	start_uri = URI.parse(start_url.split('#')[0])
	response = HTTPClient.new.get(start_uri)
	return [ response.code , (response.header['Location'][0] ? start_uri.scheme + '://' + start_uri.host + response.header['Location'][0] : start_uri) ]
end

FasterCSV.open(output_file, 'w', :headers => false) do |row|
	sites.each do |site|
		responses = []
		
		# sanitize url
		start_url =  site[0].match(/http/) ? site[0] : 'http://' + site[0]

		# push response into responses
		tmp_response = get_uri(start_url)
		responses.push(tmp_response)

		hops = 0
		while tmp_response[0] == 301 && hops < 100
			tmp_response = get_uri(tmp_response[1])
			responses.push(tmp_response)
			hops += 1
		end

		puts [start_url, responses].flatten!
		puts

		# a light weight report
		row << [start_url, [responses.first[0], responses.last[1]] ].flatten!

		# a more robust support
		# row << [start_url, responses].flatten!
	end
end