describe MediaSource do
  PYTHON_SERVER_ADDRESS, PYTHON_SERVER_PORT = "devbox.local", "8080"
  CAPS_SERVER_ADDRESS, CAPS_SERVER_PORT = "caps.local", "3000"
  CAPS_USERNAME, CAPS_PASSWORD = "tester@caps.local", "asdf"

  shared "networking off" do
    Persistence["networking"] = false
    @ms = MediaSource.prepare_from_settings
  end

  shared "networking on, autodiscover on" do
    Persistence["networking"] = true
    Persistence["autodiscover"] = true
    @ms = MediaSource.prepare_from_settings
  end

  shared "networking on, autodiscover off, server not given, auth not given" do
    Persistence["networking"] = true
    Persistence["autodiscover"] = false
    Persistence["server"] = nil
    Persistence["login"] = nil
    @ms = MediaSource.prepare_from_settings
  end

  shared "networking on, autodiscover off, server given, login not given" do
    Persistence["networking"] = true
    Persistence["autodiscover"] = false
    Persistence["server"] = {address: PYTHON_SERVER_ADDRESS, port: PYTHON_SERVER_PORT}
    Persistence["login"] = nil
    @ms = MediaSource.prepare_from_settings
  end

  shared "networking on, autodiscover off, server given, login given" do
    Persistence["networking"] = true
    Persistence["autodiscover"] = false
    Persistence["server"] = {address: CAPS_SERVER_ADDRESS, port: CAPS_SERVER_PORT}
    Persistence["login"] = {username: CAPS_USERNAME, password: CAPS_PASSWORD}
    @ms = MediaSource.prepare_from_settings
  end
  
  shared "content fetching" do
    @ms.contents.should.equal []
    @ms.fetch_contents
    @ms.contents.should.not.equal []
  end

  ###

  describe "with invalid settings" do
    behaves_like "networking on, autodiscover off, server not given, auth not given"
    
    it "returns and presents an alert" do
      @ms.class.should.equal UIAlertView
    end
  end

  ###

  describe "in local mode" do
    behaves_like "networking off"
    
    it "should be in local mode" do
      @ms.config[:mode].should.equal :local
    end

    it "fetches contents from local storage" do
      behaves_like "content fetching"
    end
  end

  ###

  describe "python mode (autodiscovery)" do
    behaves_like "networking on, autodiscover on"

    it "should be in python mode" do
      @ms.config[:mode].should.equal :python
    end
  end

  ###

  describe "python mode (no autodiscovery)" do
    behaves_like "networking on, autodiscover off, server given, login not given"

    it "should be in python mode" do
      @ms.config[:mode].should.equal :python
    end
  end

  ###

  describe "caps mode" do
    behaves_like "networking on, autodiscover off, server given, login given"

    it "should be in caps mode" do
      @ms.config[:mode].should.equal :caps
    end
  end

end