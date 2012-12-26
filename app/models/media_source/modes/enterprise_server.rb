class EnterpriseServer < MediaSource::Server
  API_VERSION = '1'
  attr_reader :reviews

  def initialize opts
    @mode = :enterprise
    @reviews = Reviews.new
    super(opts)
  end

  def api(path='')
    "#{@base_uri}/api/v#{API_VERSION}/#{path}"
  end

  def connect!(&block)
    return @status if connected? || connecting?
    @status = :connecting
    reply = {"message" => "Unknown"}
    payload = {email:@login["username"], password:@login["password"]}
    url = api 'session'
    BW::HTTP.post(url, payload: payload) do |res|
      begin
        if res.body
          reply = BW::JSON.parse(res.body.to_str)
          $token = reply[:private_token]
          if res.ok?
            @reviews.fetch_reviews!
            connected!
          elsif reply['message'] == '401 Unauthorized'
            connection_failed!
          else
            reply['message'] = "BadResponse"
            connection_failed!
          end
        else
          reply['message'] = "NoResponse"
          connection_failed!
        end
      rescue BubbleWrap::JSON::ParserError
        reply = {"message" => "JSON Parse Error"}
        connection_failed!
      ensure
        block.call(@status, reply)
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
      if res.ok?
        BW::JSON.parse(res.body.to_str).each do |asset|
          if MediaAsset.supports_extension?(ext = File.extname(asset["name"]).upcase)
            @contents << MediaAsset.new(asset["name"], asset["location_uri"], 
              asset['id'], asset['fps'], asset['start_timecode'])
          end
        end
        contents_fetched!
      else
        App.alert "Failed to fetch assets due to network instability."
      end
    end
    self
  end

end