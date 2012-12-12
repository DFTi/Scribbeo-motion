class EnterpriseServer < MediaSource::Server
  def initialize opts
    @mode = :enterprise
    super(opts)
  end

  def connect!
    return @status if connected? || connecting?
    @status = :connecting
    payload = {email:@login["username"], password:@login["password"]}
    url = api 'session'
    BW::HTTP.post(url, payload: payload) do |res|
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
      App.alert "Invalid URL: #{url}!"
    else
      App.alert MediaSource::Alert::CONNECTION_FAILURE
    end
  ensure
    return self
  end

  def fetch_contents!
    @contents = []
    BW::HTTP.get(api('all_accessible'), payload: {private_token: $token}) do |res|
      reply = BW::JSON.parse(res.body.to_str)
      reply.each do |asset|
        if MediaAsset.supports_extension?(ext = File.extname(asset["name"]).upcase)
          @contents << MediaAsset.new asset["name"], asset["location_uri"], asset['id']
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