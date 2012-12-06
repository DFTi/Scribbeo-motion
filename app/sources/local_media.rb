class LocalMedia < MediaSource::Base
  def initialize opts
    @mode = :local
    super(opts)
  end

  def connect
    connected!
  end

  def contents
    @contents = []
    dp = App.documents_path
    App.documents.each do |name|
      if MediaAsset.supports_extension?(ext=File.extname(name)[1..-1].upcase)
        @contents << MediaAsset.new(name: name, uri: File.join(dp, name), ext: ext, mode: @mode)
      end
    end
    return @contents
  end
end