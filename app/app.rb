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
  
  ##
  # Change to the view controller specified by the identifier
  def switch_to(identifier)
    App.delegate.switch_to_vc App.delegate.load_vc identifier
  end
end