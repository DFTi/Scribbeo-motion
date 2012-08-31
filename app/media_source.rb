class MediaSource
  attr_reader :contents

  def initialize(opts=nil)
    @contents = []
    @config = opts
  end

  def fetch_contents
    # Should give me back MediaSources and MediaAssets
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
        mode = "#{username}#{password}".empty? ? :python : :caps
        options = {
          mode:mode, path:'/', uri:uri,
          username:username, password:password
        }
        MediaSource.new options
      end
    else
      mode = :local
      MediaSource.new mode:mode, path:'/'
    end
  end

end