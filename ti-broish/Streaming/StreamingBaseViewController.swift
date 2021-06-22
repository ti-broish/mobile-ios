import UIKit

class StreamingBaseViewController: UIViewController {
    
    let theme: TibTheme = TibTheme()
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .darkContent
    }
    
    func dismissToRoot(animated: Bool, completion: (() -> Void)?) {
        var presentingController = presentingViewController
        while presentingController?.presentingViewController != nil {
            presentingController = presentingController?.presentingViewController
        }
        
        if presentingController != nil {
            presentingController?.dismiss(animated: animated, completion: completion)
        } else {
            dismiss(animated: animated, completion: completion)
        }
    }
}
