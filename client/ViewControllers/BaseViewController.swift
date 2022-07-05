

import Foundation
import UIKit
import Alamofire
class BaseViewController: UIViewController {
    var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
    var greyView: UIView!
    var messageLabel = UILabel(frame: .zero)

    func showNoDataMessage(onView: UIView) {
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        messageLabel.center = onView.center
        messageLabel.text = "Data is empty"
        messageLabel.numberOfLines = 0
        messageLabel.textColor = UIColor.gray
        messageLabel.textAlignment = .center;
        messageLabel.font = UIFont(name: "TimesNewRomanPSMT", size: 20.0)
        onView.addSubview(messageLabel)
        onView.bringSubviewToFront(messageLabel)
        messageLabel.centerYAnchor.constraint(equalTo: onView.centerYAnchor, constant: 0).isActive = true
        messageLabel.centerXAnchor.constraint(equalTo: onView.centerXAnchor, constant: 0).isActive = true
    }
    func hideNoDataMessage(){
        messageLabel.removeFromSuperview()
    }

    override func viewDidLoad() {
        statusBarColor()
        super.viewDidLoad()
    }
    
    func activityIndicatorBegin() {
        activityIndicatorEnd()
        activityIndicator = UIActivityIndicatorView(frame: CGRect.init(x: 0, y: 0, width: 50, height: 50))
        activityIndicator.center = view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.style = .large
        view.addSubview(activityIndicator)
        activityIndicator.startAnimating()
        
        greyView = UIView()
        greyView.frame = CGRect(x:0, y:0, width: view.bounds.width, height: view.bounds.height)
        greyView.backgroundColor = UIColor.black
        greyView.alpha = 0.5
        view.addSubview(greyView)
    }
    
    func activityIndicatorEnd() {
        activityIndicator.stopAnimating()
        greyView?.removeFromSuperview()
    }
    
    func validateNetworkConnection() -> Bool {
        guard NetworkReachabilityManager.default?.isReachable ?? false else {
            presentOKAlert(withTitle: "Error", message: "Please check your network connection")
            return false
        }
        return true
    }
    
    func statusBarColor() {
        let statusBar = UIView(frame: UIApplication.shared.keyWindow?.windowScene?.statusBarManager?.statusBarFrame ?? CGRect.zero)
        statusBar.backgroundColor = ThemeManager.Colors.forestGreen.color
        UIApplication.shared.keyWindow?.addSubview(statusBar)
    }
}
