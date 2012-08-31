module App
  module_function
  
  def documents_path
    NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, true).first
  end
  
  def file_manager
    NSFileManager.defaultManager
  end

  def documents
    file_manager.contentsOfDirectoryAtPath(documents_path, error:nil)
  end

  def setup_media_source
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

  def media_source
    App.delegate.media_source
  end

end