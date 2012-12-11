class EnterpriseServer < MediaSource::Server
  def initialize opts
    @mode = :enterprise
    super(opts)
  end

  def connect!
    return @status if connected? || connecting?
    @status = :connecting
    payload = {email:@login["username"], password:@login["password"]}
    @url = "#{@base_uri}/api/v1"
    BW::HTTP.post("#{@url}/session", payload: payload) do |res|
      begin
        if res.body
          reply = BW::JSON.parse(res.body.to_str)
          $token = reply[:private_token]
          res.ok? ? connected! : connection_failed!
        else
          connection_failed!
        end
      rescue BubbleWrap::JSON::ParserError
        connection_failed!
      end
    end
  rescue => ex
    if ex.class.to_s == 'InvalidURLError'
      App.alert "Invalid URL: #{@url}!"
    else
      App.alert "Failed to connect."
    end
  ensure
    return self
  end

  def fetch_contents!
    @contents = []
    @uri = "#{@base_uri}/api/v1/all_accessible"
    BW::HTTP.get(@uri, payload: {private_token: $token}) do |res|
      reply = BW::JSON.parse(res.body.to_str)
      reply.each do |asset|
        if MediaAsset.supports_extension?(ext = File.extname(asset["name"]).upcase)
          # temp = "http://devimages.apple.com/iphone/samples/bipbop/bipbopall.m3u8"
          @contents << MediaAsset.new(name: asset["name"], uri: asset["location_uri"], ext: ext, mode: @mode, id: asset["id"])
        end
      end
      contents_fetched!
    end
    self
  end

  # Act as tableview dataSource

  def tableView(tableView, cellForRowAtIndexPath: indexPath)
    @reuseIdentifier ||= "CELL_IDENTIFIER"
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