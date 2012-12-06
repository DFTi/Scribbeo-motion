module MediaSource
  class Base
    attr_reader :contents, :mode, :uri, :base_uri, :status
    attr_accessor :delegate

    def initialize opts
      @ready = false
      @status = :initializing
    end
  end

  class Server < Base
    def initialize opts
      @base_uri = opts[:base_uri]
      @login = opts[:login]
      @connected = false
      super(opts)
    end

    def connection_failed!
      @connected = false
      @status = :connection_failure
      delegate.connection_failed
    end

    def connected!
      @connected = true
      @status = :connected
      delegate.connected
    end

    def connected?
      @connected == true
    end

    def connecting?
      @status == :connecting
    end
  end
end