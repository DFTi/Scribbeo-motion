module MediaSource
  module Alert
    CONNECTION_FAILURE = 'Failed to connect. Check settings or network connectivity.'
    INVALID_SETTINGS = "Network mode requires target server address & port, \
                        Alternatively, use autodiscover or disable networking."
  end

  module Delegate
    def connected
      $source.fetch_contents!
    end

    def connection_failed
      App.alert MediaSource::Alert::CONNECTION_FAILURE
    end

    def contents_fetched
      @asset_table.dataSource = $source
      @asset_table.reloadData
    end

    def notes_fetched
      Crittercism.leaveBreadcrumb("delegate is setting @note_table datasource")
      @note_table.dataSource = $current_asset
      Crittercism.leaveBreadcrumb("now calling reloadData!")
      @note_table.reloadData
      return unless $current_asset.notes.any?
      Crittercism.leaveBreadcrumb("checking for uncomposited notes...")
      if $current_asset.notes.last.uncomposited?
        p "Uncomposited note detected. Refetching in #{time = 3} seconds..."
        App.run_after(time) { $current_asset.fetch_notes! }
      end
    end
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