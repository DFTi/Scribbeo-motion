class MediaAsset
  attr_reader :info, :annotations

  STILLS = ['JPG', 'JPEG', 'PNG', 'GIF']
  MOVIES = ['MOV', 'MP4', 'M4V', 'M3U8']

  def initialize(opts)
    @info = opts
  end

  def type
    ext = @info[:ext].upcase if @info[:ext]
    if STILLS.include? ext
      @info[:type] ||= :still
    elsif MOVIES.include? ext
      @info[:type] ||= :movie
    else
      @info[:type] ||= :unknown
    end
    @info[:type]
  end

  def fetch_caps_annotations!
    @uri = "#{$base_uri}/api/v1/annotations"
    BW::HTTP.get(@uri, payload: {private_token: $token, id: info[:id]}) do |res|
      reply = BW::JSON.parse(res.body.to_str)
      reply.each do |note|
        @annotations << Annotation.new(note)
      end
    end
  end

  def fetch_annotations!
    case info[:mode]
    when :caps
      fetch_caps_annotations!
    when :python
      # fetch_python_contents!
      raise 'Unimplemented note fetching'
    when :local
      # fetch_local_contents!
      raise 'Unimplemented note fetching'
    end
  end

  def fetch_annotations
    @annotations = []
    fetch_annotations!
  end

  def create_note!(note)
    case info[:mode]
    when :caps
      caps_create_note(note)
    when :python
      # fetch_python_contents!
      raise 'Unimplemented note fetching'
    when :local
      # fetch_local_contents!
      raise 'Unimplemented note fetching'
    end
  end

  def create_note(note)
    @annotations = []
    create_note!(note)
  end

  def caps_create_note(annotation)
    @uri = "#{$base_uri}/api/v1/annotations/new"
    BW::HTTP.post(@uri, payload: {private_token: $token, annotation: annotation.to_hash}) do |res|
      reply = BW::JSON.parse(res.body.to_str)
      fetch_annotations
    end
  end

  def name
    @info["name"]
  end

  def uri
    @info["uri"]
  end

  def self.supports_extension?(ext)
    STILLS.include?(ext) || MOVIES.include?(ext)
  end

end