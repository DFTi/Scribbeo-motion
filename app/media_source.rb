class MediaSource
  attr_reader :contents
  include EM::Eventable

  def initialize(opts=nil)
    @contents = []
    @config = opts
  end

  def fetch_contents
    @contents = []
    case @config[:mode]
    when :caps
      raise "caps mode not yet implemented"
    when :python
      raise "python mode not yet implemented"
    when :local
      docs_path = App.documents_path
      App.documents.each do |name|
        asset = MediaAsset.new File.join(docs_path, name)
        @contents << asset unless asset.type == :unknown
      end
    end
    self.trigger(:contents_ready)
  end

  def self.new_from_settings
    if Persistence["networking"]
      if Persistence["autodiscover"]
        mode = :python
        # Run the bonjour server ip and port discovery function
        # @autodiscover = App.notification_center.observe ... do ... end
        # Create media source in the callback
      else
        scheme = Persistence["scheme"]
        ip = Persistence["ip"]
        port = Persistence["port"]
        uri = "#{scheme}://#{ip}:#{port}"
        username = Persistence["username"]
        password = Persistence["password"]
        self.new {
          mode:("#{username}#{password}".empty? ? :python : :caps),
          path:'/', uri:uri, username:username, password:password
        }
      end
    else
      self.new :mode => :local, path:'/'
    end
  end

end