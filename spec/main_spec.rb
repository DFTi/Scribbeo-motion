describe "Application 'Scribbeo'" do
  before do
    @app = UIApplication.sharedApplication
  end

  # Ignore UI for now
  # it "has one window" do
  #   @app.windows.size.should == 1
  # end

  it "sets up a media source" do
    App.delegate.media_source.should != nil
  end

  it "has fixtures for local mode" do
    App.documents.first.should == "chapter_markers.mov"
  end

end
