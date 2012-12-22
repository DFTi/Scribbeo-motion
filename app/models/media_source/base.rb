module MediaSource
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

    def clear_notes!
      $current_asset = MediaAsset.new '', ''
      delegate.notes_fetched
    end

    def type
      MPMovieSourceTypeUnknown
    end

    def tableView(tableView, cellForRowAtIndexPath: indexPath)
      @reuseIdentifier ||= "ASSET_CELL_IDENTIFIER"
      cell = tableView.dequeueReusableCellWithIdentifier(@reuseIdentifier) || begin
        UITableViewCell.alloc.initWithStyle(UITableViewCellStyleDefault, reuseIdentifier:@reuseIdentifier)
      end
      cell.textLabel.text = @contents[indexPath.row].name
      cell
    end

    def tableView(tableView, numberOfRowsInSection: section)
      @contents.count
    end
  end
end