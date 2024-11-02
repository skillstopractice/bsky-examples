# Looks up the DID for a given profile name.
# 
# Example usage:
#   
#   ruby find_did.rb skillstopractice.com 

abort("Need to specify profile name") if ARGV[0].nil?

require 'minisky'

bsky = Minisky.new('public.api.bsky.app', nil)

profile = bsky.get_request('app.bsky.actor.getProfile', 
                           { actor: ARGV[0] })

puts profile["did"]