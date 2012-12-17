class LocalMedia < MediaSource::Base
  def initialize
    @mode = :local
    super
  end

  def connect!
    connected!
  end

  def fetch_contents!
    @contents = []
    dp = App.documents_path
    App.documents.each do |name|
      if MediaAsset.supports_extension?(ext=File.extname(name)[1..-1].upcase)
        @contents << MediaAsset.new(name, File.join(dp, name))
      end
      contents_fetched!
    end
    self
  end

  def type
    MPMovieSourceTypeFile
  end
end