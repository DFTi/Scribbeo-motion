class MediaAsset
  attr_accessor :delegate
  attr_reader :name, :uri, :id, :notes

  STILLS = ['.JPG', '.JPEG', '.PNG', '.GIF']
  MOVIES = ['.MOV', '.MP4', '.M4V', '.M3U8']

  def initialize(name, uri, id=nil)
    @name = name
    @uri = uri
    @id = id
    @notes = []
  end

  def fetch_notes!
    @notes = []
    url = $source.api 'annotations'
    BW::HTTP.get(url, payload: {private_token: $token, id: id}) do |res|
      BW::JSON.parse(res.body.to_str).each {|n| @notes << Annotation.new(n)}
    end
    delegate.notes_fetched
  end

  def create_note!(note)
    payload = {private_token: $token, annotation: note.to_hash}
    url = $source.api 'annotations/new'
    BW::HTTP.post(url, payload: payload) do |res|
      reply = BW::JSON.parse(res.body.to_str)
      fetch_notes!
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
      UITableViewCell.alloc.initWithStyle(UITableViewCellStyleDefault, reuseIdentifier:@reuseIdentifier)
    end
    cell.textLabel.text = 'NOTE HERE' #@notes[indexPath.row].name
    cell
  end

  def tableView(tableView, numberOfRowsInSection: section)
    @notes.count
  end

end