module MediaSource
  class InvalidSettingsError < StandardError; end
  class SubclassMissingError < StandardError; end
  
  module Alert
    CONNECTION_FAILURE = 'Failed to connect. Check settings or network connectivity.'
    INVALID_SETTINGS = "Network mode requires target server address & port, \
                        Alternatively, use autodiscover or disable networking."
  end

  module Factory
    ##
    # Build a new media source object from persistent user settings
    def self.build
      if Persistence["networking"]
        server = Persistence['server'].nil? ? Hash.new : Persistence['server']
        port_entered = !server['port'].nil? && !server['port'].empty?
        address_entered = !server['address'].nil? && !server['address'].empty?
        server_entered = ((port_entered && address_entered) ? true : false)
        if Persistence["autodiscover"]
          PythonServer.new autodiscover: true
        elsif server_entered
          uri = "http://#{server['address']}:#{server['port']}"
          if login = Persistence["login"]
            EnterpriseServer.new base_uri:uri, login: login
          else
            PythonServer.new base_uri:uri, autodiscover: false
          end
        else
          raise InvalidSettingsError
        end
      else
        LocalMedia.new
      end
    end
  end
end