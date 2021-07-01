import UIKit

class StreamingBaseViewController: UIViewController {
    
    let theme: TibTheme = TibTheme()
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .darkContent
    }
}
