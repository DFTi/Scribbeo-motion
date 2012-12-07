module ViewController
  class Base < UIViewController
    def shouldAutorotateToInterfaceOrientation(o)
      true
    end

    def supportedInterfaceOrientations
      UIInterfaceOrientationMaskAll
    end

    def shouldAutorotate
      true
    end
  end

  class Landscape < Base
    def preferredInterfaceOrientationForPresentation
      UIInterfaceOrientationLandscapeLeft
    end

    def shouldAutorotateToInterfaceOrientation(o)
      (o == UIInterfaceOrientationLandscapeRight) || (o == UIInterfaceOrientationLandscapeLeft)
    end

    def supportedInterfaceOrientations
      UIInterfaceOrientationMaskLandscapeRight | UIInterfaceOrientationMaskLandscapeLeft
    end

    def shouldAutorotate
      true
    end
  end
end