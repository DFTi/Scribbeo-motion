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

  def python_discovered(hostname, port)
    puts "service discovered, triggering connection now!"
    base_uri = "http://#{hostname}:#{port}"
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
        self.new mode:mode, uri:uri, username:username, password:password
        self.trigger(:ready_to_connect)
      elsif mode == :python
        media_source = self.new mode:mode, uri:"#{uri}/list", base_uri:uri
        if Persistence["autodiscover"]
          puts "Autodiscover will use BonjourFinder"
          finder = BonjourFinder.new(media_source)
          media_source.finder = finder
        end
        return media_source
      end
    else
      self.new :mode => :local
      self.trigger(:ready_to_connect)
    end
  end

end