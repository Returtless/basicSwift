import UIKit

/*
 1. Придумать класс, методы которого могут создавать непоправимые ошибки. Реализовать их с помощью try/catch.
 2. Придумать класс, методы которого могут завершаться неудачей. Реализовать их с использованием Error.
 */
extension String {
    
    var isEmail: Bool {
        do {
            let regex = try NSRegularExpression(pattern: "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}", options: .caseInsensitive)
            return regex.firstMatch(in: self, options: NSRegularExpression.MatchingOptions(rawValue: 0), range: NSMakeRange(0, self.count)) != nil
        } catch {
            return false
        }
    }
    
    var hasSpecialCharacters : Bool {
        do {
            let regex = try NSRegularExpression(pattern: ".*[^A-Za-z].*", options: .caseInsensitive)
            if let _ = regex.firstMatch(in: self, options: NSRegularExpression.MatchingOptions.reportCompletion, range: NSMakeRange(0, self.count)) {
                return true
            }
        } catch {
            debugPrint(error.localizedDescription)
            return false
        }
        return false
    }
}
enum SignUpError: Error {            // ошибки при регистрации
    case invalidName
    case invalidSurname
    case invalidPassword
    case invalidAge
    case invalidEmail
    case emailIsNotMatch
    case privacyIsNotAgreed
    case invalidCaptcha
}

enum SignInError: Error {            // ошибки при входе
    case fieldsIsEmpty
    case invalidPassword
    case invalidEmail
    case userIsNotFound
    case incorrectEmailOrPassword
}

struct User {
    let name : String
    let surname : String
    let password : String
    let age : Int
    let email : String
}

struct Users {
    var elements : [User] = []
    
    func contains(_ email : String) -> Bool {
        return elements.contains(where: {$0.email == email})
    }
    
    func login(_ email : String, _ password : String) -> Bool {
        return elements.contains(where: {$0.email == email && $0.password == password})
    }
}

class LoginWindow {
    var users = Users()
    
    func signUp(name : String, surname : String, age : Int, password : String, email : String, repeatedEmail : String, privacy : Bool, captcha : String) throws -> User{
        
        guard !name.hasSpecialCharacters else {
            throw SignUpError.invalidName
        }
        
        guard !surname.hasSpecialCharacters else {
            throw SignUpError.invalidSurname
        }
        
        guard age>10 && age<120 else {
            throw SignUpError.invalidAge
        }
        
        guard password.count > 8 else {
            throw SignUpError.invalidPassword
        }
        
        guard email.isEmail else {
            throw SignUpError.invalidEmail
        }
        
        guard repeatedEmail == email else {
            throw SignUpError.emailIsNotMatch
        }
        
        guard privacy else {
            throw SignUpError.privacyIsNotAgreed
        }
        
        guard captcha == "I am human" else {
            throw SignUpError.invalidCaptcha
        }
        let user = User(name: name, surname: surname, password : password, age: age, email: email)
        users.elements.append(user)
        return user
    }
    
    func signIn(email : String, password : String) throws -> User? {
        guard email.isEmail else {
            throw SignInError.invalidEmail
        }
        guard !email.isEmpty && !password.isEmpty else {
            throw SignInError.fieldsIsEmpty
        }
        guard password.count > 8 else {
            throw SignInError.invalidPassword
        }
        guard users.contains(email) else {
            throw SignInError.userIsNotFound
        }
        guard users.login(email, password) else {
            throw SignInError.incorrectEmailOrPassword
        }
        return users.elements.first(where: {$0.email == email && $0.password == password})
    }
}

let loginWnd = LoginWindow()
do {
    try loginWnd.signUp(name: "Vasya", surname: "Vasiliev", age: 25, password : "123456789", email: "vasya@yandex.ru", repeatedEmail: "vasya@yandex.ru", privacy: true, captcha: "I am human")
    print("Регистрация успешно завершена")
} catch SignUpError.invalidName {
    print("Имя содержит недопустимые символы")
} catch SignUpError.invalidSurname {
    print("Фамилия содержит недопустимые символы")
} catch SignUpError.invalidAge {
    print("Некорректный возраст")
} catch SignUpError.invalidPassword {
    print("Пароль должен быть длинее 8 символов")
} catch SignUpError.invalidEmail {
    print("Введен некорректный адрес электронной почты")
} catch SignUpError.emailIsNotMatch {
    print("Email не совпадает с введенным ранее")
} catch SignUpError.privacyIsNotAgreed {
    print("Пользовательское соглашение не принято")
} catch SignUpError.invalidCaptcha {
    print("Вы - робот :)")
} catch {
    print(error.localizedDescription)
}

do {
    try loginWnd.signIn(email: "vasya@yandex.ru", password : "1234567890")
    print("Вход произведен успешно")
} catch SignInError.fieldsIsEmpty {
    print("Не заполнены поля")
} catch SignInError.invalidEmail {
    print("Введен некорректный адрес электронной почты")
} catch SignInError.userIsNotFound {
    print("Пользователь не существует")
} catch SignInError.invalidPassword {
    print("Пароль должен быть длинее 8 символов")
} catch SignInError.incorrectEmailOrPassword {
    print("Введены некорретные данные")
}
