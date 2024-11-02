# Fetches full profile data as raw JSON.
#
# Authenticated.. so you need to provide a user/app pass in bluesky.yml
# (See minisky gem READE for details)
# 
# Example usage:
#   
#   ruby full_profile.rb skillstopractice.com > profile.json

abort("Need to specify profile name") if ARGV[0].nil?

require 'minisky'

bsky = Minisky.new('bsky.social', "bluesky.yml")

profile = bsky.get_request('app.bsky.actor.getProfile', 
                           { actor: ARGV[0] })

puts profile.to_json