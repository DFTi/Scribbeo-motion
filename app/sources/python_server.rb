class PythonServer < MediaSource::Server
  def initialize opts
    @mode = :python
    super(opts)
  end

  def connect
    return @status if connected? || connecting?
    @finder = BonjourFinder.new("_videoTree._tcp.")
    @finder.notify(self) do |ip, port|
      @base_uri = "http://#{ip}:#{port}"
      @uri = "#{@base_uri}/list"
      BW::HTTP.get(@uri) do |res|
        @connected = res.ok?
        connected? ? connected! : connection_failed!
      end
    end
  end

  def contents
    BW::HTTP.get(@uri) do |response|
      if response.ok?
        json = BW::JSON.parse response.body.to_str
        opts = {mode: :python, base_uri: @base_uri}
        json["folders"].each do |item|
          params = opts.merge({
            name: item["name"],
            uri: @base_uri+item["list_url"],
            mode: @mode
          })
          @contents << MediaSource.new(params)
        end
        json["files"].each do |item|
          next unless MediaAsset.supports_extension?(item["ext"].upcase)
          params = opts.merge({
            name: item["name"], ext: item["ext"],
            uri: @base_uri+item["asset_url"],
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