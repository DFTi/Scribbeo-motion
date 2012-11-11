describe MediaSource do
  PYTHON_SERVER_ADDRESS, PYTHON_SERVER_PORT = "devbox.local", "8080"
  CAPS_SERVER_ADDRESS, CAPS_SERVER_PORT = "capsbox.local", "3000"
  CAPS_USERNAME, CAPS_PASSWORD = "tester@caps.local", "qweqwe"

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
      @ms.mode.should.equal :local
    end
  end

  ###

  describe "python mode (autodiscovery)" do
    behaves_like "networking on, autodiscover on"

    it "should be in python mode" do
      @ms.mode.should.equal :python
    end
  end

  ###

  describe "python mode (no autodiscovery)" do
    behaves_like "networking on, autodiscover off, server given, login not given"

    it "should be in python mode" do
      @ms.mode.should.equal :python
    end
  end

  ###

  describe "caps mode" do
    behaves_like "networking on, autodiscover off, server given, login given"

    it "should be in caps mode" do
      @ms.mode.should.equal :caps
      wait 2 do
        @ms.connected?.should.equal true
      end
    end

    it "should fetch contents" do
      @ms.fetch_contents
      wait 2 do
        @ms.contents.size.should.equal 1
      end
    end

    # really test MediaAsset
    # but this establishes
    # nice pretense for this

    it "should fetch annotations" do
      @ms.contents[0].fetch_annotations
      wait 2 do
        @last_size = @ms.contents[0].annotations.length
        @last_size.should > 0
      end
    end

    it "should be able to create annotation" do
      note = {"seconds"=>"2", "note"=>"2!", "timecode"=>"00:00:00:02", "media_asset_id"=>@ms.contents[0].info[:id]}
      @ms.contents[0].create_note(note)
      wait 1 do
        @ms.contents[0].annotations.length.should.equal (@last_size + 1)
      end
    end

  end

end