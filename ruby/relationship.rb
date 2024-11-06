# Determines the relationship between two bsky accounts.
# 
# Example usage:
#   
#   ruby relationship.rb skillstopractice.com bsky.app

abort("Need to specify two profile names") if ARGV[0].nil? || ARGV[1].nil?

require 'minisky'

bsky = Minisky.new('public.api.bsky.app', nil)

profile1 = bsky.get_request('app.bsky.actor.getProfile', { actor: ARGV[0] })
profile2 = bsky.get_request('app.bsky.actor.getProfile', { actor: ARGV[1] })

results = bsky.get_request('app.bsky.graph.getRelationships', 
                           { actor: profile1["did"], others: [profile2["did"]] })

case ["following", "followedBy"] & results["relationships"].first.keys 
when ["following"]
  puts "#{ARGV[0]} follows #{ARGV[1]}"
when ["followedBy"]
  puts "#{ARGV[1]} is followed by #{ARGV[0]}"
when ["following", "followedBy"]
  puts "#{ARGV[0]} and #{ARGV[1]} are mutuals"
else
  puts "#{ARGV[0]} and #{ARGV[1]} do not follow each other"
end
