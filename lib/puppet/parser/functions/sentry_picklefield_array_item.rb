# converts a single item to a python-pickled array
# useful for encoding a value for sentry:origins

require 'base64'

module Puppet::Parser::Functions
  newfunction(:sentry_picklefield_array_item, :type => :rvalue) do |args|
    value = args[0]
    # leader and trailer from python's pickling of
    # pickle.dumps(['https://...', ], protocol=2)

    pickle = "\x80\x02]q\x00U" + value.length.chr + value + "q\x01a."

    # gsub added because by default encode64 adds newlines every 60 chars
    Base64.encode64(pickle).gsub(/\n/, '')
  end
end
