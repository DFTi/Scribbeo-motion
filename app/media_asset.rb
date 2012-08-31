class MediaAsset
  STILLS = ['.jpg', '.jpeg', '.png', '.gif']
  MOVIES = ['.mov', '.mp4', '.m4v', '.m3u8']

  def initialize(path)
    @path = path
  end

  def type
    ext = File.extname(@path)
    @type ||= if STILLS.include? ext
      :still
    elsif MOVIES.include? ext
      :movie
    else
      :unknown
    end
  end

end