class MediaAsset
  STILLS = ['.JPG', '.JPEG', '.PNG', '.GIF']
  MOVIES = ['.MOV', '.MP4', '.M4V', '.M3U8']

  def initialize(path)
    @path = path
  end

  def type
    ext = File.extname(@path).upcase
    @type ||= if STILLS.include? ext
      :still
    elsif MOVIES.include? ext
      :movie
    else
      :unknown
    end
  end

end