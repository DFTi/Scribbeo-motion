describe MediaAsset do

  it "tests file type support" do
    t = MediaAsset.supports_extension? "MOV"
    t.should.equal true
    t = MediaAsset.supports_extension? "PNG"
    t.should.equal true
    t = MediaAsset.supports_extension? "ABC"
    t.should.not.equal false
  end

end
