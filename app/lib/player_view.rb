class PlayerView < UIView


  def load(asset)
    url = asset.playback_url
    if $media_player
      $media_player.contentURL = url
    else
      $media_player = MoviePlayer::Controller.alloc.initWithContentURL(url)     
      $media_player.shouldAutoplay = false
      $media_player.view.frame = self.bounds
      self.addSubview $media_player.view
    end
    $media_player.prepareToPlay
  end
end