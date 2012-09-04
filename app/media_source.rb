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

  def fetch_contents
    @contents = []
    case @config[:mode]
    when :caps
      fetch_caps_contents
    when :python
      fetch_python_contents
    when :local
      fetch_local_contents
    end
    true
  end

  def connect
    case @config[:mode]
    when :caps
      raise "caps mode not yet implemented"
    when :python
      BW::HTTP.get(@config[:uri]) do |response|
        self.trigger(response.ok? ? :connected : :connection_failed)
      end
    when :local
      self.trigger(:connected)
    end
  end

  def python_discovered(ip, port)
    base_uri = "http://#{ip}:#{port}"
    @config[:base_uri] = base_uri
    @config[:uri] = base_uri+'/list'
    self.trigger(:ready_to_connect)
  end

  def self.new_from_settings
    if Persistence["networking"]
      scheme = Persistence["scheme"]
      ip = Persistence["ip"]
      port = Persistence["port"]
      uri = "#{scheme}://#{ip}:#{port}"
      username = Persistence["username"]
      password = Persistence["password"]
      mode = "#{username}#{password}".empty? ? :python : :caps
      if mode == :caps
        ms = self.new mode:mode, uri:uri, username:username, password:password
        ms.trigger(:ready_to_connect)
      elsif mode == :python
        ms = self.new mode:mode, uri:"#{uri}/list", base_uri:uri
        if Persistence["autodiscover"]
          puts "Autodiscover will use BonjourFinder"
          ms.finder = BonjourFinder.new
          ms.finder.on(:found_bonjour_server) do
            finder = App.media_source.finder
            host = NSHost.hostWithName finder.server.hostName
            App.media_source.python_discovered(host.address, finder.server.port)
            finder.stop
          end
          ms.finder.start
        end
      end
    else
      ms = self.new :mode => :local
      ms.trigger(:ready_to_connect)
    end
    return ms
  end

end