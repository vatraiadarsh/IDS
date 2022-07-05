

import Foundation

extension String {
    var isValidEmail: Bool {
        NSPredicate(format: "SELF MATCHES %@", "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}").evaluate(with: self)
    }

    var isValidUserName: Bool {
        (self.count > 3) && (self.count < 8)
    }

    var isValidPassword: Bool {
        // least one uppercase,
        // least one digit
        // least one lowercase
        // least one symbol
        //  min 8 characters total
        let password = self.trimmingCharacters(in: CharacterSet.whitespaces)
        let passwordRegx = "^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[#?!@$%^&<>*~:`-]).{5,}$"
        let passwordCheck = NSPredicate(format: "SELF MATCHES %@",passwordRegx)
        return passwordCheck.evaluate(with: password)
    }

    func getMissingPasswordValidationError() -> [String] {
        var errors: [String] = []
        if(!NSPredicate(format:"SELF MATCHES %@", ".*[A-Z]+.*").evaluate(with: self)){
            errors.append(" one uppercase")
        }

        if(!NSPredicate(format:"SELF MATCHES %@", ".*[0-9]+.*").evaluate(with: self)){
            errors.append(" one digit")
        }

        if(!NSPredicate(format:"SELF MATCHES %@", ".*[!&^%$#@()/]+.*").evaluate(with: self)){
            errors.append(" one symbol")
        }

        if(!NSPredicate(format:"SELF MATCHES %@", ".*[a-z]+.*").evaluate(with: self)){
            errors.append(" one lowercase")
        }

        if(self.count < 5){
            errors.append(" min 5 characters total")
        }
        return errors
    }
}
