describe App do

  it "wraps local file listing" do
    file_listing = lambda do |wrapped_file_listing|
      docpath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, true).first
      docs = NSFileManager.defaultManager.contentsOfDirectoryAtPath(docpath, error:nil)
      docs == wrapped_file_listing
    end
    App.documents.should.be.a file_listing
  end

end
