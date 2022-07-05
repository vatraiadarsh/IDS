

import UIKit
import Alamofire
class LoginViewController: BaseViewController {

    @IBOutlet weak var logoBGView: UIView!
    @IBOutlet weak var signInButton: UIButton!
    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var passwordTF: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setupUI()
    }

    private func setupUI() {
        logoBGView.backgroundColor = ThemeManager.Colors.forestGreen.color
        signInButton.backgroundColor = ThemeManager.Colors.forestGreen.color

        signInButton.layer.cornerRadius = 15.0
        signInButton.layer.masksToBounds = true

        emailTF.delegate = self
        emailTF.returnKeyType = .next

        passwordTF.delegate = self
        passwordTF.returnKeyType = .done

        emailTF.text = UserDefaultsHelper.getData(type: String.self, forKey: .email)
        passwordTF.text = UserDefaultsHelper.getData(type: String.self, forKey: .password)
    }

    @IBAction func forgotPasswordButtonAction(_ sender: Any) {
        guard validateNetworkConnection() else { return }
        guard let email = emailTF.text, email.isValidEmail  else {
            presentOKAlert(withTitle: "Error", message: "Please enter a valid email.")
            return
        }
        activityIndicatorBegin()
        requestForgotPasswordOTP()
    }

    @IBAction func signInButtonAction(_ sender: Any) {
        guard validateNetworkConnection() else { return }
        guard let email = emailTF.text, email.isValidEmail  else {
            presentOKAlert(withTitle: "Error", message: "Please enter a valid email.")
            return
        }
        guard let password = passwordTF.text, password.count >= 5 else {
            let error = "Invalid password"
            presentOKAlert(withTitle: "Error", message: error)
            return
        }
        activityIndicatorBegin()
        doLogin()
    }

    private func doLogin() {
        let parameters = [
            "email" : emailTF.text ?? "",
            "password" : passwordTF.text ?? ""
        ]
        AF.request(URL.init(string: Constants.API.signin)!, method: .post, parameters: parameters, encoding: JSONEncoding.default).responseJSON { [weak self](response) in
            print("[response Abhi]: ", response.result)
            switch response.result {
            case .success(_):
                if let json = response.value as? [String: String] {
                    if let statusCode = response.response?.statusCode, statusCode == 200
                    {
                        print(json)
                        print("Login success, status code = ", statusCode)
                        self?.activityIndicatorEnd()
                        UserDefaultsHelper.setData(value: json["email"] ?? "", key: .email)
                        UserDefaultsHelper.setData(value: self?.passwordTF.text ?? "", key: .password)
                        UserDefaultsHelper.setData(value: json["id"] ?? "", key: .id)
                        UserDefaultsHelper.setData(value: json["username"] ?? "", key: .username)
                        UserDefaultsHelper.setData(value: true, key: .isLoggedIn)

                        if let delegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate {
                            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
                            let newViewController = storyBoard.instantiateViewController(withIdentifier: "MainVCID") as! MainViewController

                            delegate.window?.rootViewController = newViewController
                            delegate.window?.makeKeyAndVisible()
                        }

                    } else {
                        self?.presentOKAlert(withTitle: "Signin error", message: json["message"] ?? "unknown error")
                        self?.activityIndicatorEnd()
                    }
                }
            case .failure(let error):
                self?.presentOKAlert(withTitle: "Signin error", message: error.localizedDescription)
                self?.activityIndicatorEnd()

            }
        }
    }
    private func requestForgotPasswordOTP() {
        let parameters = [
            "email" : emailTF.text ?? "",
        ]
        AF.request(URL.init(string: Constants.API.forgotPassword)!, method: .post, parameters: parameters, encoding: JSONEncoding.default).responseJSON { [weak self](response) in
            print("[response Abhi]: ", response.result)
            switch response.result {
            case .success(_):
                if let json = response.value as? [String: String] {
                    if let statusCode = response.response?.statusCode, statusCode == 200
                    {
                        print(json)
                        print("forgot password success, status code = ", statusCode)
                        self?.activityIndicatorEnd()
                        self?.showOTPPasswordAlert(message: json["message"] ?? "")
                    } else {
                        self?.presentOKAlert(withTitle: "Signin error", message: json["message"] ?? "unknown error")
                        self?.activityIndicatorEnd()
                    }
                }
            case .failure(let error):
                self?.presentOKAlert(withTitle: "Signin error", message: error.localizedDescription)
                self?.activityIndicatorEnd()

            }
        }
    }

    func showOTPPasswordAlert(message: String) {
        let alertController = UIAlertController(title: "Enter OTP", message: message, preferredStyle: .alert)
        alertController.addTextField { (textField : UITextField!) -> Void in
            textField.placeholder = "Enter OTP"
        }
        alertController.addTextField { (textField : UITextField!) -> Void in
            textField.placeholder = "Enter new password"
        }
        let submitAction = UIAlertAction(title: "Submit", style: .default, handler: { alert -> Void in
            let otp = (alertController.textFields![0] as UITextField).text ?? ""
            let password = (alertController.textFields![1] as UITextField).text ?? ""

            self.validateOTP(otp, password: password)
        })
        let cancelAction = UIAlertAction(title: "Cancel", style: .destructive, handler: {
            (action : UIAlertAction!) -> Void in })

        alertController.addAction(submitAction)
        alertController.addAction(cancelAction)

        self.present(alertController, animated: true, completion: nil)
    }

    func validateOTP(_ otp: String, password: String) {
        guard validateNetworkConnection() else { return }
        guard password.isValidPassword else {
            let error = "Password should have " + passwordTF.text!.getMissingPasswordValidationError().joined(separator: ", ")
            presentOKAlert(withTitle: "Error", message: error) {
                self.showOTPPasswordAlert(message: "Enter OTP and new password.")
            }
            return
        }
        activityIndicatorBegin()
        let parameters = [
            "email" : emailTF.text ?? "",
            "otp" : otp ,
            "password" : password
        ]
        AF.request(URL.init(string: Constants.API.validateOTP)!, method: .post, parameters: parameters, encoding: JSONEncoding.default).responseJSON { [weak self](response) in
            print("[response Abhi]: ", response.result)
            switch response.result {
            case .success(_):
                if let json = response.value as? [String: String] {
                    if let statusCode = response.response?.statusCode, statusCode == 200
                    {
                        print(json)
                        print("forgot password validation success, status code = ", statusCode)
                        self?.activityIndicatorEnd()
                        UserDefaultsHelper.setData(value: password, key: .password)
                        self?.presentOKAlert(withTitle: "Success", message: json["message"] ?? "")
                    } else {
                        self?.presentOKAlert(withTitle: "Signin error", message: json["message"] ?? "unknown error")
                        self?.activityIndicatorEnd()
                    }
                }
            case .failure(let error):
                self?.presentOKAlert(withTitle: "Signin error", message: error.localizedDescription)
                self?.activityIndicatorEnd()
            }
        }
    }
}



extension LoginViewController: UITextFieldDelegate {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        if textField == emailTF { passwordTF.becomeFirstResponder() }
        textField.resignFirstResponder()
        return true
    }
}
