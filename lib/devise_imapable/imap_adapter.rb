require 'net/imap'

module Devise

  module ImapAdapter

    def self.valid_credentials?(username, password)
      imap = Net::IMAP.new(::Devise.imap_server)
      imap.authenticate("cram-md5", username, password)
      true
    rescue Net::IMAP::ResponseError => e
      false
    ensure
      imap.disconnect
    end

  end

end