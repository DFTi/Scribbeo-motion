class MediaAsset
  attr_accessor :delegate, :notes, :comments, :ready_to_play
  attr_reader :name, :uri, :id, :fps, :start_timecode

  STILLS = ['.JPG', '.JPEG', '.PNG', '.GIF']
  MOVIES = ['.MOV', '.MP4', '.M4V', '.M3U8']

  def initialize(name, uri, id=nil, fps=29.97, start_timecode='00:00:00:00')
    @name = name
    @uri = uri
    @id = id
    @fps = fps
    @start_timecode = start_timecode
    @notes = []
    @ready_to_play = false
    @comments = Comments.new
  end

  def url
    NSURL.URLWithString "#{uri}?auth_token=#{$token}"
  end

  def fetch_notes!
    url = $source.api('annotations')
    BW::HTTP.get(url, payload: {private_token: $token, id: id}) do |res|
      if res.ok?
        @notes = []
        BW::JSON.parse(res.body.to_str).each do |n|
          note = Note.new(n)
          notes << note
          comments << Comment.new({ text: note.note, image_url: note.image_url })
        end
        delegate.notes_fetched
      else
        App.alert 'Could not retrieve notes.'
      end
    end
    self
  end

  def create_note!(note, &block)
    payload = {private_token: $token, annotation: note.to_hash}
    url = $source.api 'annotations/new'
    BW::HTTP.post(url, payload: payload) do |res|
      user_feedback = if res.ok?
        {:success => true, :message => "Note saved on server."}
      else
        {:success => false, :message => res.error_message}
      end
      block.call(user_feedback)
    end
    self
  end

  def self.supports_extension?(ext)
    ext.upcase!
    STILLS.include?(ext) || MOVIES.include?(ext)
  end

  # Act as tableview dataSource
  def tableView(tableView, cellForRowAtIndexPath: indexPath)
    @reuseIdentifier ||= "NOTE_CELL_IDENTIFIER"
    cell = tableView.dequeueReusableCellWithIdentifier(@reuseIdentifier) || begin
      NoteCell.alloc.initWithStyle(UITableViewCellStyleDefault, reuseIdentifier:@reuseIdentifier)
    end
    cell.note = notes[indexPath.row]
    cell
  end

  def tableView(tableView, numberOfRowsInSection: section)
    notes.count
  end
end