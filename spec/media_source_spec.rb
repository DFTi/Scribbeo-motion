describe MediaSource do
  PYTHON_SERVER_ADDRESS, PYTHON_SERVER_PORT = "devbox.local", "8080"
  CAPS_SERVER_ADDRESS, CAPS_SERVER_PORT = "caps.local", "3000"
  CAPS_USERNAME, CAPS_PASSWORD = "tester@caps.local", "asdf"

  shared "in local mode" do
    Persistence["networking"] = false
  end

  shared "in network mode with autodiscover (python)" do
    Persistence["networking"] = true
    Persistence["autodiscover"] = true
  end

  shared "in network mode with manual server address (python)" do
    Persistence["networking"] = true
    Persistence["address"] = PYTHON_SERVER_ADDRESS
    Persistence["port"] = PYTHON_SERVER_PORT
  end

  shared "in network mode with manual server address (caps)" do
    Persistence["networking"] = true
    Persistence["autodiscover"] = false
    Persistence["address"] = CAPS_SERVER_ADDRESS
    Persistence["port"] = CAPS_SERVER_PORT
    Persistence["username"] = CAPS_USERNAME
    Persistence["password"] = CAPS_PASSWORD
  end
  
  #
  # => "in local mode"
  #

  before do
    behaves_like "in local mode"
    @ms = MediaSource.prepare_from_settings
  end

  it "should be in local mode" do
    @ms.config[:mode].should.equal :local
  end

  it "fetches contents" do
    @ms.contents.should.equal []
    @ms.fetch_contents
    @ms.contents.should.not.equal []
  end

  before do
    behaves_like "in network mode with autodiscover (python)"
    @ms = MediaSource.prepare_from_settings
  end

  it "should be in python mode" do
    @ms.config[:mode].should.equal :python
  end

  before do
    behaves_like "in network mode with manual server address (python)"
    @ms = MediaSource.prepare_from_settings
  end

  it "should be in python mode" do
    @ms.config[:mode].should.equal :python
  end

  it "can connect to the designated server" do
    # @ms.config[:]
    # @ms.should trigger :connected
  end

  # describe "networked mode (python, no autodiscover)" do
  #   before do
  #     App::Persistence["networking"] = true
  #     App::Persistence["autodiscover"] = false
  #     @ms = App.setup_media_source
  #   end

  #   it "fetches contents" do
  #     @ms.contents.should.equal []
  #     @ms.fetch_contents
  #     @ms.contents.should.not.equal []
  #   end
  # end

end