describe "Application 'Scribbeo'" do
  before do
    @app = UIApplication.sharedApplication
  end

  # Ignore UI for now
  # it "has one window" do
  #   @app.windows.size.should == 1
  # end

  it "has a root media source" do
    @app.delegate.media_source.should.equal App.media_source
  end

  it "has fixtures for local mode" do
    App.documents.first.should == "chapter_markers.mov"
  end

end
