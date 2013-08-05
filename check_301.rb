#! /usr/bin/ruby

require 'rubygems'
require 'csv'
require 'uri'
require 'httpclient'

input_file = ARGV[0]

sites = nil
httpc = HTTPClient.new

puts "trying to read files"
begin
	sites = CSV.parse(File.read(input_file))
rescue
	puts "There was a problem importing the csv file. Contact support."
	exit
end

puts "checking #{sites.length} sites. This might take a while."

output_file = "output/301_check_#{Time.now.strftime("%Y-%m-%d_%I%M")}.csv"

CSV.open(output_file, 'w') do |row|
	sites.each do |site|
		start_url = site[0].match(/http/) ? site[0] : 'http://' + site[0]
		response = httpc.get(start_url)
		response_code = response.code
		start_uri = URI.parse(start_url)
		end_url = response.header['Location'][0] ? start_uri.scheme + '://' + start_uri.host + response.header['Location'][0] : ''
		puts [start_url, response_code, end_url]
		row << [start_url, response_code, end_url]
	end
end