# Grabs the first 20 messages from the firehouse
# and then looks up the handle from their did.
#
# Prints it out if it's not a bsky.social domain.
# (Note this is throttled to 1 lookup / second)
#
# $ ruby domain_sampler.rb 
#
# (Mostly cobbled together from examples found in the skyfall gem repo)

require 'skyfall'
require 'json'
require 'open-uri'

term = ARGV[0]

sky = Skyfall::Stream.new('bsky.network', :subscribe_repos)

dids = []

sky.on_message do |msg|
  sky.disconnect if dids.length == 20

  # we're only interested in repo commit messages
  next if msg.type != :commit

  msg.operations.each do |op|
    # ignore any operations other than "create post"
    next unless op.action == :create && op.type == :bsky_post

    dids << op.repo 
  end
end


# get_user_handle(op.repo) 

#       puts
#       handle[/bsky.social\z/] || puts("- - - #{handle} - - -")
#     else
#       print "."
#     end

def get_user_handle(did)
  url = "https://plc.directory/#{did}"
  json = JSON.parse(URI.open(url).read)
  json['alsoKnownAs'][0].gsub('at://', '')
end


sky.on_connect { puts "Connected" }
sky.on_disconnect { puts "Disconnected" }
sky.on_reconnect { puts "Reconnecting..." }
sky.on_error { |e| puts "ERROR: #{e}" }

# close the connection cleanly on Ctrl+C
trap("SIGINT") { sky.disconnect }

sky.connect

dids.each do |did|
  sleep 1
  handle = get_user_handle(did)
  if handle[/bsky.social\z/] 
    print "." 
  else
    puts "\n!!! #{handle}"
  end
end
