module ContentFetcher

  def fetch_local_contents
    docs_path = App.documents_path
    App.documents.each do |name|
      if MediaAsset.supports? name
        @contents << MediaAsset.new(name, File.join(docs_path, name))
      end
    end
  end

  def fetch_python_contents
    BW::HTTP.get(@config[:uri]) do |response|
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
      else
        raise "Failed to fetch contents from python server"
      end
    end
  end

  def fetch_caps_contents
    # ...
  end

end