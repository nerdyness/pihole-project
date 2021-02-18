#!/usr/local/bin/ruby -w

require "httparty"
require "json"
require 'fileutils'
require 'aws-sdk-s3'

API_TOKEN = "#{ENV['API_TOKEN']}".freeze
DESTINATION = "/data".freeze

def s3_put_object(file, obj, bucket_name='pihole-raw-uploads')
  return false unless File.exist?(file)
  s3 = Aws::S3::Resource.new
  target_obj = s3.bucket(bucket_name).object(obj)
  target_obj.upload_file(file)
  puts "Successfully uploaded #{file}!"
end

def sync_data(path="/data")
  return false unless Dir.exist?(path)
  Dir.chdir(path)  # Change directory to path.
  all_files = Dir.glob("**/*.json")
  all_files.each { |file| s3_put_object("#{path}/#{file}", file) }
end

# Fetch queries from API and place them in dictionary
begin
  raw_response = HTTParty.get("http://pihole/admin/api.php?getAllQueries&auth=#{API_TOKEN}")
  response = JSON.parse(raw_response.to_s)
rescue => e
  attempts ||= 1
  sleep(attempts * 3) # Give the container some time to start
  retry unless (attempts += 1) > 3
  puts e.message
  exit 1
end

if response.empty?
  puts "Nothhing received from Pihole API"
  exit 1
end

sorted = {}
response["data"].each do |entry|
  timestamp = Time.strptime(entry.first, '%s')
  day = "#{timestamp.year}-#{timestamp.strftime("%m")}-#{timestamp.day}"
  sorted[day] ||= []
  sorted[day] << entry
end

# Write dictionary to files
sorted.each do |day, records|
  timestamp = Time.strptime(records.first.first, '%s')
  file = "/#{DESTINATION}/#{timestamp.year}/#{timestamp.strftime("%m")}/#{timestamp.day}/#{day}_#{timestamp.strftime('%H')}:#{timestamp.strftime('%M')}:#{timestamp.strftime('%S')}.json"
  FileUtils.mkdir_p(File.dirname(file))
  File.write(file, JSON.generate(:data => records))
end

# Sync data from files to S3 for further processing
sync_data

