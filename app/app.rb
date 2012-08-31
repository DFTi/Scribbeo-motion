module App
  module_function
  
  def documents_path
    NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, true).first
  end
  
  def file_manager
    NSFileManager.defaultManager
  end

  def documents
    file_manager.contentsOfDirectoryAtPath(documents_path, error:nil)
  end

  def media_source
    App.delegate.media_source
  end

  def debug
    App.delegate.debug
  end

  def debug=(val)
    App.delegate.debug = val
  end

end