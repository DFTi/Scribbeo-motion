class MediaSource
  attr_reader :contents, :config
  attr_accessor :finder
  include EM::Eventable
  include ContentFetcher

  def initialize(opts)
    @contents = []
    @config = opts
    @finder = nil
  end

  def connect
    case @config[:mode]
    when :caps
      raise "caps mode not yet implemented"
    when :python
      BW::HTTP.get(@config[:uri]) do |response|
        trigger(response.ok? ? :connected : :connection_failed)
      end
    when :local
      trigger(:connected)
    end
  end

  def python_discovered(ip, port)
    base_uri = "http://#{ip}:#{port}"
    @config[:base_uri] = base_uri
    @config[:uri] = base_uri+'/list'
    trigger(:ready_to_connect)
  end

  def bind
    on(:ready_to_connect) do
      puts "Ready"
      connect
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

  # def self.prepare_from_settings
  #   if Persistence["networking"]
  #     scheme = Persistence["scheme"]
  #     ip = Persistence["ip"]
  #     port = Persistence["port"]
  #     uri = "#{scheme}://#{ip}:#{port}"
  #     username = Persistence["username"]
  #     password = Persistence["password"]
  #     mode = "#{username}#{password}".empty? ? :python : :caps
  #     if mode == :caps
  #       ms = self.new mode:mode, uri:uri, username:username, password:password
  #     elsif mode == :python
  #       ms = self.new mode:mode, uri:"#{uri}/list", base_uri:uri
  #       if Persistence["autodiscover"]
  #         puts "Autodiscover will use BonjourFinder"
  #         ms.finder = BonjourFinder.new
  #         ms.finder.on(:found_bonjour_server) do
  #           finder = App.media_source.finder
  #           host = NSHost.hostWithName finder.server.hostName
  #           App.media_source.python_discovered(host.address, finder.server.port)
  #           finder.stop
  #         end
  #         ms.finder.start
  #       end
  #     end
  #   else
  #     ms = self.new :mode => :local
  #   end
  #   ms.bind
  #   return ms
  # end

  def self.prepare_from_settings
    if Persistence["networking"]
      if Persistence["autodiscover"]
        new mode: :python
      elsif Persistence["server"]
        if Persistence["login"]
          new mode: :caps
        else
          new mode: :python
        end
      else
        App.alert "Network mode requires target server address & port, \
          Alternatively, use autodiscover or disable networking."
      end
    else
      new mode: :local
    end
  end

  def self.auth?

  end

end








