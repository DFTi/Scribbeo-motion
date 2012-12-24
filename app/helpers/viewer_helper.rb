module ViewerHelper
  class DrawPresentation < UIImageView ; end

  def connected
    $source.fetch_contents!
  end

  def connection_failed
    # Nothing needed right now.
  end

  def contents_fetched
    @asset_table.dataSource = $source
    @asset_table.reloadData
  end
  
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