module ViewerHelper
  def new_source_from_settings
    if Persistence["networking"]
      if Persistence["autodiscover"]
        PythonServer.new autodiscover: true
      elsif server = Persistence["server"]
        uri = "http://#{server['address']}:#{server['port']}"
        if login = Persistence["login"]
          EnterpriseServer.new base_uri:uri, login: login
        else
          PythonServer.new base_uri:uri, autodiscover: false
        end
      else
        App.alert "Network mode requires target server address & port, \
        Alternatively, use autodiscover or disable networking."
        return false
      end
    else
      LocalMedia.new
    end
  end
end