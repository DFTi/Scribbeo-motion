module Dismissable
  private
  def dismiss
    if pvc = presentingViewController
      pvc.dismissViewControllerAnimated(true, completion:nil)
    end
  end
end