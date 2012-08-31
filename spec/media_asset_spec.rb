describe MediaAsset do

  it "determines asset type based on extension" do
    movie = MediaAsset.new "file.mov"
    still = MediaAsset.new "file.png"
    movie.type.should.equal :movie
    still.type.should.equal :still
  end

end
