class PlayerView < UIView

  def self.layerClass
    AVPlayerLayer
  end

  OPTIONS = {
    AVURLAssetPreferPreciseDurationAndTimingKey => NSNumber.numberWithBool(true)
  }

  def load(asset, &block)
    url_asset = AVURLAsset.URLAssetWithURL(asset.url, options:OPTIONS)
    player_item = AVPlayerItem.playerItemWithAsset(url_asset)
    if player
      player.replaceCurrentItemWithPlayerItem(player_item)
    else
      layer.setPlayer AVPlayer.playerWithPlayerItem(player_item)
      player.allowsExternalPlayback = true
    end
    block.call(player_item)
  end

  def paused?
    player.rate == 0.0
  end

  def touchesBegan(touches, withEvent:event)
    (paused? ? play : pause) if exists?
  end

  def player
    self.layer.player
  end

  def observe_time(block)
    stop_observing_time
    @observer = player.addPeriodicTimeObserverForInterval(
      CMTimeMakeWithSeconds(1.0/framerate, timescale),
      queue:nil, usingBlock:block)
  end

  def stop_observing_time
    if @observer
      player.removeTimeObserver(@observer) 
      @observer = false
    end
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

  def framerate
    video_track.nominalFrameRate
  end

  def seek_to seconds
    time = CMTimeMakeWithSeconds(seconds, timescale)
    player.seekToTime(time, toleranceBefore:KCMTimeZero, toleranceAfter:KCMTimeZero)
  end

  def exists?
    !player.nil?
  end

  def play
    $viewer.stop_presenting_note
    player.play if seconds <= duration
  end

  def pause
    player.pause
  end

  def seconds
    CMTimeGetSeconds(player.currentTime)
  end

  def duration
    CMTimeGetSeconds(video_track.timeRange.duration)
  end

  def rate=(rate)
    player.setRate(rate)
  end

  def add_overlay overlay
    overlay.frame = bounds
    addSubview overlay
  end
end