

import UIKit
import Alamofire
class SignUpViewController: BaseViewController {

    @IBOutlet weak var logoBGView: UIView!
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var userNameTF: UITextField!
    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var passwordTF: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setupUI()
    }

    private func setupUI() {

        logoBGView.backgroundColor = ThemeManager.Colors.forestGreen.color
        signUpButton.backgroundColor = ThemeManager.Colors.forestGreen.color

        signUpButton.layer.cornerRadius = 15.0
        signUpButton.layer.masksToBounds = true

        userNameTF.delegate = self
        userNameTF.returnKeyType = .next

        emailTF.delegate = self
        emailTF.returnKeyType = .next

        passwordTF.delegate = self
        passwordTF.returnKeyType = .done
    }
    
    @IBAction func signupButtonAction(_ sender: Any) {
        validateInputs()
    }

    private func validateInputs() {
        guard validateNetworkConnection() else { return }
        guard let userName = userNameTF.text, userName.isValidUserName else {
            presentOKAlert(withTitle: "Error", message: "Please enter a valid username. Character count should be between 3 and 8")
            return
        }
        guard let email = emailTF.text, email.isValidEmail else {
            presentOKAlert(withTitle: "Error", message: "Please enter a valid email.")
            return
        }
        guard let password = passwordTF.text, password.isValidPassword else {
            let error = "Password should have " + passwordTF.text!.getMissingPasswordValidationError().joined(separator: ", ")
            presentOKAlert(withTitle: "Error", message: error)
            return
        }
        signUpButton.isEnabled = false
        activityIndicatorBegin()
        doSignup()
    }

    private func doSignup() {
        let parameters = [
            "username" : userNameTF.text ?? "",
            "email" : emailTF.text ?? "",
            "password" : passwordTF.text ?? ""
        ]
        AF.request(URL.init(string: Constants.API.signup)!, method: .post, parameters: parameters, encoding: JSONEncoding.default).responseJSON { [weak self](response) in
            print("[response Abhi]: ", response.result)
            switch response.result {
            case .success(_):
                if let json = response.value as? [String: String] {
                    if let statusCode = response.response?.statusCode, statusCode == 200
                    {
                        print(json)
                        print("[json Abhi]: ", json)
                        self?.doLogin()
                    } else {
                        self?.presentOKAlert(withTitle: "Signup error", message: json["message"] ?? "unknown error")
                        self?.signUpButton.isEnabled = true
                        self?.activityIndicatorEnd()
                    }
                }
            case .failure(let error):
                self?.presentOKAlert(withTitle: "Error", message: error.localizedDescription)
                self?.activityIndicatorEnd()
                self?.signUpButton.isEnabled = true
            }
        }
    }

    private func doLogin() {
        let parameters = [
            "username" : userNameTF.text ?? "",
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
                        self?.signUpButton.isEnabled = true
                        self?.activityIndicatorEnd()
                    }
                }
            case .failure(let error):
                self?.presentOKAlert(withTitle: "Signin error", message: error.localizedDescription)
            }
        }
    }

}


extension SignUpViewController: UITextFieldDelegate {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        if textField == userNameTF { emailTF.becomeFirstResponder() }
        if textField == emailTF { passwordTF.becomeFirstResponder() }
        textField.resignFirstResponder()
        return true
    }
}
