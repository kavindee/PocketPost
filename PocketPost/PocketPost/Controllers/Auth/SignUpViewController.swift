//
//  SignUpViewController.swift
//  PocketPost
//
//  Created by kavin on BE 2567-04-20.
//

import UIKit

class SignUpViewController: UITabBarController {

    //Header View
    private let headerView = SignUpHeaderView()
    
    //Name field
    private let nameField: UITextField = {
        let field = UITextField()
        field.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 50))
        field.autocorrectionType = .no
        field.leftViewMode = .always
        field.placeholder = "Enter Name"
        field.backgroundColor = .secondarySystemBackground
        field.layer.cornerRadius = 8
        field.layer.masksToBounds = true
        return field
    }()
    
    //Email field
    private let emailField: UITextField = {
        let field = UITextField()
        field.keyboardType = .emailAddress
        field.autocapitalizationType = .none
        field.autocorrectionType = .no
        field.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 50))
        field.leftViewMode = .always
        field.placeholder = "Enter Email"
        field.backgroundColor = .secondarySystemBackground
        field.layer.cornerRadius = 8
        field.layer.masksToBounds = true
        return field
    }()

    //Password Field
    private let passwordField: UITextField = {
        let field = UITextField()
        field.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 50))
        field.leftViewMode = .always
        field.autocapitalizationType = .none
        field.autocorrectionType = .no
        field.placeholder = "Enter Password"
        field.backgroundColor = .secondarySystemBackground
        field.layer.cornerRadius = 8
        field.isSecureTextEntry = true
        field.layer.masksToBounds = true
        return field
    }()
    
    //Sign In Button
    private let signUpbutton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .systemGreen
        button.setTitle("Create Account", for: .normal)
        button.setTitleColor(.white, for: .normal)
        return button
    }()
    
    //Create Account
    private let AlreadyButton: UIButton = {
        let button = UIButton()
        button.setTitle("Already have an Account ?", for: .normal)
        button.setTitleColor(.link, for: .normal)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Sign In"
        view.backgroundColor = .systemBackground
        view.addSubview(headerView)
        view.addSubview(nameField)
        view.addSubview(emailField)
        view.addSubview(passwordField)
        view.addSubview(signUpbutton)
        view.addSubview(AlreadyButton)
        
        signUpbutton.addTarget(self, action: #selector(didTapSignUp), for: .touchUpInside)
        AlreadyButton.addTarget(self, action: #selector(didTapAlready), for: .touchUpInside)
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        headerView.frame = CGRect(x: 0, y: view.safeAreaInsets.top, width: view.width, height: view.height/4)
        
        nameField.frame = CGRect(x: 20, y: headerView.bottom, width: view.width-40, height: 50)
        emailField.frame = CGRect(x: 20, y: nameField.bottom+10, width: view.width-40, height: 50)
        passwordField.frame = CGRect(x: 20, y: emailField.bottom+10, width: view.width-40, height: 50)
        signUpbutton.frame = CGRect(x: 20, y: passwordField.bottom+10, width: view.width-40, height: 50)
        AlreadyButton.frame = CGRect(x: 20, y: signUpbutton.bottom+10, width: view.width-40, height: 50)
    }
    
    @objc func didTapSignUp() {
        guard let email = emailField.text, !email.isEmpty,
              let password = passwordField.text, !password.isEmpty,
              let name = nameField.text, !name.isEmpty else {
            return
        }
        //Create user
        AuthManager.shared.signUp(email: email, password: password) { [weak self]success in
            if success {
                //Update database
                let newUser = User(name: name, email: email, profilePictureRef: nil)
                DatabaseManager.shared.insert(user: newUser) { inserted in
                    guard inserted else {
                        return
                    }
                    UserDefaults.standard.set(email, forKey: "email")
                    UserDefaults.standard.set(name, forKey: "name")
                    DispatchQueue.main.async {
                        let vc = TabBarViewController()
                        vc.modalPresentationStyle = .fullScreen
                        self?.present(vc, animated: true)
                    }
                }
            }else {
                print("Failed to Create An Account!")
            }
        }
        
    }
    
    @objc func didTapAlready() {
        let vc = SignInViewController()
        
        navigationController?.pushViewController(vc, animated: true)
    }


}
