module ViewerHelper
  INVALID_SETTINGS_MESSAGE = "Network mode requires target server address & port, \
                              Alternatively, use autodiscover or disable networking."

  def new_source_from_settings
    if Persistence["networking"]
      server = Persistence['server'].nil? ? Hash.new : Persistence['server']
      server_entered = !server['port'].blank? && !server['address'].blank?
      if Persistence["autodiscover"]
        PythonServer.new autodiscover: true
      elsif server_entered
        uri = "http://#{server['address']}:#{server['port']}"
        if login = Persistence["login"]
          EnterpriseServer.new base_uri:uri, login: login
        else
          PythonServer.new base_uri:uri, autodiscover: false
        end
      else
        App.alert INVALID_SETTINGS_MESSAGE
      end
    else
      LocalMedia.new
    end
  end
end