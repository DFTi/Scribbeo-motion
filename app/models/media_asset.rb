class MediaAsset
  ##
  # Included on ViewControllers that display notes in a UITableView
  module Delegate
    def notes_fetched
      @note_table.dataSource = $current_asset
      @note_table.reloadData
      return unless $current_asset.notes.any?
      if $current_asset.notes.last.uncomposited?
        p "Uncomposited note detected. Refetching in #{time = 3} seconds..."
        App.run_after(time) { $current_asset.fetch_notes! }
      end
    end
  end

  attr_accessor :delegate, :notes
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
  end

  def playback_url
    NSURL.URLWithString "#{uri}?auth_token=#{$token}"
  end

  def fetch_notes!
    @notes = []
    url = $source.api('annotations')
    BW::HTTP.get(url, payload: {private_token: $token, id: id}) do |res|
      if res.ok?
        BW::JSON.parse(res.body.to_str).each {|n| notes << Note.new(n)}
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