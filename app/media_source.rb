class MediaSource
  attr_reader :contents, :mode, :uri, :base_uri

  def initialize(opts)
    @uri = opts[:uri]
    $base_uri = opts[:base_uri]
    @autodiscover = opts[:autodiscover]
    @mode = opts[:mode]
    @ready = false
    @login = opts[:login]
    connect! if opts[:root]
  end

  def connected?
    @connected ? true : false
  end

  ##
  # Requests content and fills `@contents` with MediaSources and MediaAssets
  # When complete, the event :contents_fetched is triggered
  def fetch_contents
    if connected?
      @contents = []
      fetch_contents!
    else
      App.alert "Cannot fetch contents: not connected"
    end
  end

  ##
  # Uses settings to produce a new MediaSource
  def self.prepare_from_settings
    if Persistence["networking"]
      if Persistence["autodiscover"]
        new mode: :python, autodiscover: true, root: true
      elsif server = Persistence["server"]
        uri = "http://#{server['address']}:#{server['port']}"
        if login = Persistence["login"]
          new mode: :caps, base_uri:uri, login: login, root: true
        else
          new mode: :python, base_uri:uri, root: true
        end
      else
        App.alert "Network mode requires target server address & port, \
        Alternatively, use autodiscover or disable networking."
        # UI_TASK Redirect to settings.
      end
    else
      new mode: :local, root: true
    end
  end

  private

  def connected!
    NSLog "Connected!"
  end

  def connection_failed!
    NSLog "Connection Failed"
  end

  def contents_fetched!
    NSLog "Contents fetched"
  end

  ##
  # Connects to the target source and sets @connected ivar
  #
  # Calls #connected! or #connection_failed!
  def connect!
    @connected = false
    case @mode
    when :local
      @connected = true
      connected!
    when :caps
      caps_connect!
    when :python
      if $base_uri
        python_connect!
      elsif @autodiscover
        @finder = BonjourFinder.new("_videoTree._tcp.")
        @finder.notify(self) do |ip, port|
          $base_uri = "http://#{ip}:#{port}"
          python_connect!
        end
      else
        connection_failed!
      end
    end
  end

  ##
  # #connect!'s underlying method for python mode
  def python_connect!
    @uri = "#{$base_uri}/list"
    BW::HTTP.get(@uri) do |res|
      @connected = res.ok?
      connected? ? connected! : connection_failed!
    end
  end

  ##
  # #connect!'s underlying method for caps mode
  def caps_connect!
    @uri = "#{$base_uri}/api/v1/session"
    payload = {
      email:@login["username"],
      password:@login["password"]
    }
    BW::HTTP.post(@uri, payload: payload) do |res|
      reply = BW::JSON.parse(res.body.to_str)
      $token = reply[:private_token]
      @connected = res.ok?
      connected? ? connected! : connection_failed!
    end
  end

  def fetch_contents!
    case @mode
    when :caps
      fetch_caps_contents!
    when :python
      fetch_python_contents!
    when :local
      fetch_local_contents!
    end
  end

  def fetch_caps_contents!
    @uri = "#{$base_uri}/api/v1/all_accessible"
    BW::HTTP.get(@uri, payload: {private_token: $token}) do |res|
      reply = BW::JSON.parse(res.body.to_str)
      reply.each do |asset|
        if MediaAsset.supports_extension?(ext=File.extname(asset["name"])[1..-1].upcase)
          @contents << MediaAsset.new(name: asset["name"], uri: asset["location_uri"], ext: ext, mode: @mode, id: asset["id"])
        end
      end
    end
  end

  def fetch_local_contents!
    dp = App.documents_path
    App.documents.each do |name|
      if MediaAsset.supports_extension?(ext=File.extname(name)[1..-1].upcase)
        @contents << MediaAsset.new(name: name, uri: File.join(dp, name), ext: ext, mode: @mode)
      end
    end
    contents_fetched!
  end

  def fetch_python_contents!
    BW::HTTP.get(@uri) do |response|
      if response.ok?
        json = BW::JSON.parse response.body.to_str
        opts = {mode: :python, base_uri: $base_uri}
        json["folders"].each do |item|
          params = opts.merge({
            name: item["name"],
            uri: $base_uri+item["list_url"],
            mode: @mode
          })
          @contents << MediaSource.new(params)
        end
        json["files"].each do |item|
          next unless MediaAsset.supports_extension?(item["ext"].upcase)
          params = opts.merge({
            name: item["name"], ext: item["ext"],
            uri: $base_uri+item["asset_url"],
            mode: @mode
          })
          @contents << MediaAsset.new(params)
        end
        contents_fetched!
      else
        raise "Failed to fetch contents from python server"
      end
    end
  end

end








