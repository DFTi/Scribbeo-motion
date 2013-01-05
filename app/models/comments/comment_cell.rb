class AssetBrowserCell < UITableViewCell
  attr_reader :asset
  Tags(name:40, date_modified:41, created_by:42, date_created:43)

  def asset=(a)
    if a.is_container?
      # treat it as such
      # it is likely a media source, folder, group, catalog, etc
    else
      # treat it as a leaf
      # it is likely a media asset, clip, etc
    end
  end
end