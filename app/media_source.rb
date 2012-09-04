class MediaSource
  attr_reader :contents, :config
  include EM::Eventable
  include ContentFetcher
  include BonjourExtension

  def initialize(opts)
    @contents = []
    @media_source = true
    @mode = opts[:mode]
    if bonjour_finder = opts[:autodiscover]
      bonjour_finder.notify do |ip, port|
        @config["server"] = {address: ip, port: port}
      end
    else
      @uri = opts[:uri]
    end
  end

  # def connect
  #   case @mode
  #   when :caps
  #     # @uri = "http://#{config[:server]["address"]}:#{config[:server]["port"]}"
  #     raise "caps mode not yet implemented"
  #   when :python
  #     @uri = "http://#{config[:server]["address"]}:#{config[:server]["port"]}"
  #     BW::HTTP.get(@uri) do |response|
  #       trigger(response.ok? ? :connected : :connection_failed)
  #     end
  #   when :local
  #     trigger(:connected)
  #   end
  # end

  def bind
    on(:ready) do
      puts "Ready"
      # connect
    end
    
    on(:connected) do
      puts "Connection ready! Fetching contents!"
      fetch_contents
    end

    on(:connection_failed) do
      puts "Connection failed..."
    end

    on(:contents_fetched) do
      puts "Contents ready! Use App.media_source.contents to retrieve"
      puts "Recalling .fetch_contents will retrigger this block"
      # At this point we can trust that
      # media_source.contents will give us the right
      # contents, so we can present a view or update
      # and existing view with these contents
    end
  end

  def self.prepare_from_settings
    if Persistence["networking"]
      if Persistence["autodiscover"]
        new mode: :python, autodiscover: BonjourFinder.new("_videoTree._tcp.")
      elsif server = Persistence["server"]
        if login = Persistence["login"]
          new mode: :caps, server: server, login: login
        else
          new mode: :python, server: server
        end
      else
        App.alert "Network mode requires target server address & port, \
          Alternatively, use autodiscover or disable networking."
        # UI_TASK Redirect to settings.
      end
    else
      new mode: :local
    end
  end

end








