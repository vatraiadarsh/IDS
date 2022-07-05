import Foundation
import UIKit
extension UIViewController {

    func showToast(message : String) {

        view.displayToast(message)
    }

}

extension UIView {

    func displayToast(_ message : String) {

        let window = UIApplication.shared.connectedScenes.flatMap { ($0 as? UIWindowScene)?.windows ?? [] }.first { $0.isKeyWindow }

        if let toast = window?.subviews.first(where: { $0 is UILabel && $0.tag == -1001 }) {
            toast.removeFromSuperview()
        }

        let toastView = UILabel()
        toastView.backgroundColor = UIColor.black.withAlphaComponent(0.95)
        toastView.textColor = UIColor.white
        toastView.textAlignment = .center
        toastView.font = UIFont(name: "TimesNewRomanPSMT", size: 17.0)
        toastView.layer.cornerRadius = 25
        toastView.text = message
        toastView.numberOfLines = 0
        toastView.alpha = 0
        toastView.translatesAutoresizingMaskIntoConstraints = false
        toastView.tag = -1001
        toastView.layer.masksToBounds = true

        window?.addSubview(toastView)

        let horizontalCenterContraint: NSLayoutConstraint = NSLayoutConstraint(item: toastView, attribute: .centerX, relatedBy: .equal, toItem: window, attribute: .centerX, multiplier: 1, constant: 0)

        let widthContraint: NSLayoutConstraint = NSLayoutConstraint(item: toastView, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .width, multiplier: 1, constant: (self.frame.size.width-25) )

        let verticalContraint: [NSLayoutConstraint] = NSLayoutConstraint.constraints(withVisualFormat: "V:|-(>=200)-[toastView(==50)]-100-|", options: [.alignAllCenterX, .alignAllCenterY], metrics: nil, views: ["toastView": toastView])

        NSLayoutConstraint.activate([horizontalCenterContraint, widthContraint])
        NSLayoutConstraint.activate(verticalContraint)

        UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseIn, animations: {
            toastView.alpha = 1
        }, completion: nil)

        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(2), execute: {
            UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseIn, animations: {
                toastView.alpha = 0
            }, completion: { finished in
                toastView.removeFromSuperview()
            })
        })
    }
}
