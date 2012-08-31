describe MediaSource do

  describe "local mode" do
    before do
      App::Persistence["networking"] = false
      App::Persistence["autodiscover"] = false
      @ms = MediaSource.new_from_settings
    end

    it "should be in local mode" do
      @ms.config[:mode].should.equal :local
    end

    it "fetches contents" do
      @ms.contents.should.equal []
      @ms.fetch_contents
      @ms.contents.should.not.equal []
    end
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