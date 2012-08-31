class MediaSource
  attr_reader :contents, :config
  include EM::Eventable
  include ContentFetcher

  def initialize(opts)
    @contents = []
    @config = opts
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

  def self.new_from_settings
    if Persistence["networking"]
      if Persistence["autodiscover"]
        mode = :python
        raise "Autodiscovery not yet implemented"
      else
        scheme = Persistence["scheme"]
        ip = Persistence["ip"]
        port = Persistence["port"]
        uri = "#{scheme}://#{ip}:#{port}"
        username = Persistence["username"]
        password = Persistence["password"]
        mode = "#{username}#{password}".empty? ? :python : :caps
        if mode == :caps
          self.new mode:mode, uri:uri, username:username, password:password
        elsif mode == :python
          self.new mode:mode, uri:"#{uri}/list", base_uri:uri
        end
      end
    else
      self.new :mode => :local
    end
  end

end