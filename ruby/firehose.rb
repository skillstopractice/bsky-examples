# Connects to the bsky.network relay and then matches
# a search term against the posts flowing through the firehose
#
# Example:
# $ ruby firehose.rb love
#
# (Mostly based on a similar example found in the skyfall gem repo)

require 'skyfall'

abort("Need to supply a search term") unless ARGV[0]

term = ARGV[0]

sky = Skyfall::Stream.new('bsky.network', :subscribe_repos)

sky.on_message do |msg|
  # we're only interested in repo commit messages
  next if msg.type != :commit

  msg.operations.each do |op|
    print "."

    # ignore any operations other than "create post"
    next unless op.action == :create && op.type == :bsky_post

    if op.raw_record['text'] =~ /\b#{term}\b/i
      puts
      puts "#{op.repo} • #{msg.time.getlocal}"
      puts op.raw_record['text'] 
      puts
    end
  end
end

sky.on_connect { puts "Connected" }
sky.on_disconnect { puts "Disconnected" }
sky.on_reconnect { puts "Reconnecting..." }
sky.on_error { |e| puts "ERROR: #{e}" }

# close the connection cleanly on Ctrl+C
trap("SIGINT") { sky.disconnect }

sky.connect
