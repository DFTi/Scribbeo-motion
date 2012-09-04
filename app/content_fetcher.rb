module ContentFetcher

  def fetch_contents
    @contents = []
    trigger(:contents_fetched) if case @config[:mode]
    when :caps
      fetch_caps_contents!
    when :python
      fetch_python_contents!
    when :local
      fetch_local_contents!
    end
  end

  def fetch_caps_contents!
    # ...
    raise "Caps content fetching is not implemented yet"
  end

  def fetch_local_contents!
    dp = App.documents_path
    App.documents.each do |name|
      if MediaAsset.supports_extension?(ext=File.extname(name)[1..-1].upcase)
        @contents << MediaAsset.new(name: name, uri: File.join(dp, name), ext: ext)
      end
    end
    true
  end

  def fetch_python_contents!
    BW::HTTP.get(@uri) do |response|
      if response.ok?
        json = BW::JSON.parse response.body.to_str
        opts = {mode: :python, base_uri: @config[:base_uri]}
        json["folders"].each do |item|
          params = opts.merge({
            name: item["name"],
            uri: @config[:base_uri]+item["list_url"]
          })
          @contents << MediaSource.new(params)
        end
        json["files"].each do |item|
          next unless MediaAsset.supports_extension?(item["ext"].upcase)
          params = opts.merge({
            name: item["name"], ext: item["ext"],
            uri: @config[:base_uri]+item["asset_url"]
          })
          @contents << MediaAsset.new(params)
        end
        self.trigger(:contents_fetched)
      else
        raise "Failed to fetch contents from python server"
      end
    end
  end

end