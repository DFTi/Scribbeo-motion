class PlayerView < UIView
  def self.layerClass
    AVPlayerLayer
  end

  OPTIONS = {
    AVURLAssetPreferPreciseDurationAndTimingKey => NSNumber.numberWithBool(true)
  }

  def load asset
    url_asset = AVURLAsset.URLAssetWithURL(asset.url, options:OPTIONS)
    player_item = AVPlayerItem.playerItemWithAsset(url_asset)
    if $media_player
      $media_player.replaceCurrentItemWithPlayerItem(player_item)
    else
      $media_player = AVPlayer.playerWithPlayerItem(player_item)
      layer.setPlayer $media_player
    end
  end

  def player
    self.layer.player
  end

  def setVideoFillMode fillMode
    self.layer.videoGravity = fillMode
  end

  def video_track
    player.currentItem.asset.tracksWithMediaType(AVMediaTypeVideo).lastObject
  end

  def timescale
    video_track.naturalTimeScale
  end

  def seek_to seconds
    time = CMTimeMakeWithSeconds(seconds, timescale)
    player.seekToTime(time, toleranceBefore:KCMTimeZero, toleranceAfter:KCMTimeZero)
  end

  def exists?
    !$media_player.nil?
  end

  def pause
    $media_player.pause
  end

  def show_control_overlay
    # $media_player.controlStyle = MPMovieControlStyleDefault
  end

  def hide_control_overlay
    # $media_player.controlStyle = MPMovieControlStyleNone
  end

  def seconds
    CMTimeGetSeconds(player.currentTime)
  end

  def add_overlay overlay
    overlay.frame = bounds
    addSubview overlay
  end
end