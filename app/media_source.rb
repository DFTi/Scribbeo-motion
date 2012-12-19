module MediaSource
  module Alert
    CONNECTION_FAILURE = 'Failed to connect. Check settings or network connectivity.'
    INVALID_SETTINGS = "Network mode requires target server address & port, \
                        Alternatively, use autodiscover or disable networking."
  end

  class Base
    attr_reader :contents, :mode, :uri, :base_uri, :status
    attr_accessor :delegate

    def initialize
      @contents = []
      @connected = false
      @status = :disconnected
      NSLog "Initializing Source: #{self.class}"
    end

    def connected!
      @connected = true
      @status = :connected
      delegate.connected
    end
    
    def connection_failed!
      @connected = false
      @status = :connection_failure
      delegate.connection_failed
    end

    def connected?
      @connected == true
    end

    def connecting?
      @status == :connecting
    end

    def contents_fetched!
      delegate.contents_fetched
    end

    def type
      MPMovieSourceTypeUnknown
    end
  end

  class Server < Base
    API_VERSION = '1'

    def initialize opts
      @base_uri = opts[:base_uri]
      @login = opts[:login]
      super
    end

    def api(path='')
      "#{@base_uri}/api/v#{API_VERSION}/#{path}"
    end

    def type
      MPMovieSourceTypeStreaming
    end
  end
end