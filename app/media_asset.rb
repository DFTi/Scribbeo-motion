class MediaAsset
  attr_reader :info

  STILLS = ['JPG', 'JPEG', 'PNG', 'GIF']
  MOVIES = ['MOV', 'MP4', 'M4V', 'M3U8']

  def initialize(opts)
    @info = opts
  end

  def type
    ext = @info[:ext].upcase if @info[:ext]
    @info[:type] ||= if STILLS.include? ext
      :still
    elsif MOVIES.include? ext
      :movie
    else
      :unknown
    end
  end

  def self.supports_extension?(ext)
    STILLS.include?(ext) || MOVIES.include?(ext)
  end

end