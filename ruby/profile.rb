# Fetches profile data as raw JSON.
# 
# Example usage:
#   
#   ruby profile.rb skillstopractice.com > profile.json

abort("Need to specify profile name") if ARGV[0].nil?

require 'minisky'

bsky = Minisky.new('api.bsky.app', nil)

profile = bsky.get_request('app.bsky.actor.getProfile', 
                           { actor: ARGV[0] })

puts profile.to_json