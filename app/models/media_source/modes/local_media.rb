class LocalMedia < MediaSource::Base
  def initialize
    @mode = :local
    super
  end

  def connect!(&block)
    clear_notes!
    connected!
    block.call(:connected)
  end

  def clear_notes!
    $current_asset = MediaAsset.new '', ''
    delegate.notes_fetched
  end

  def fetch_contents!
    @contents = []
    dp = App.documents_path
    App.documents.each do |name|
      if MediaAsset.supports_extension?(ext=File.extname(name)[1..-1].upcase)
        @contents << MediaAsset.new(name, File.join(dp, name))
      end
    end
    contents_fetched!
    self
  end

  def type
    MPMovieSourceTypeFile
  end
end