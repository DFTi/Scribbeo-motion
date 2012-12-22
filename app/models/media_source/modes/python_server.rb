class PythonServer < MediaSource::Server
  def initialize opts
    @mode = :python
    @list_url = "#{@base_uri}/list"
    super(opts)
  end

  def connect!(&block)
    return block.call(@status) if connected? || connecting?
    @finder = BonjourFinder.new("_videoTree._tcp.")
    @finder.notify(self) do |ip, port|
      @base_uri = "http://#{ip}:#{port}"
      BW::HTTP.get(@list_url) do |res|
        @connected = res.ok?
        if connected?
          connected!
        else
          connection_failed!
        end
        block.call(@status)
      end
    end
  end

  def fetch_contents!
    @contents = []
    BW::HTTP.get(@list_url) do |response|
      if response.ok?
        json = BW::JSON.parse response.body.to_str
        opts = {mode: :python, base_uri: @base_uri}
        json["folders"].each do |item|
          params = opts.merge({
            name: item["name"],
            uri: @base_uri+item["list_url"],
            mode: @mode
          })
          raise 'the next line is wrong/old'
          @contents << MediaSource.new(params)
        end
        json["files"].each do |item|
          next unless MediaAsset.supports_extension?(item["ext"].upcase)
          @contents << MediaAsset.new(item["name"], @base_uri+item["asset_url"])
        end
        contents_fetched!
      else
        raise "Failed to fetch contents from python server"
      end
    end
    self
  end

end