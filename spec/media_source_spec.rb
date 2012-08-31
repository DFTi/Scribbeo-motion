describe MediaSource do

  describe "local mode" do
    before do
      App::Persistence["networking"] = false
      App::Persistence["autodiscover"] = false
      @ms = App.setup_media_source
    end

    it "fetches contents" do
      @ms.contents.should.equal []
      @ms.fetch_contents
      @ms.contents.should.not.equal []
    end
  end

end
