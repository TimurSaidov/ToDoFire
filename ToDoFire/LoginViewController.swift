//
//  ViewController.swift
//  ToDoFire
//
//  Created by Timur Saidov on 07/12/2018.
//  Copyright © 2018 Timur Saidov. All rights reserved.
//

import UIKit
import Firebase

class LoginViewController: UIViewController {

    @IBOutlet weak var warningLabel: UILabel!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBAction func loginButtonTapped(_ sender: UIButton) {
        guard let email = emailTextField.text, let password = passwordTextField.text, email != "", password != "" else {
            displayWarningLabel(withText: "Information is incorrect!")
            return
        }
        
        Auth.auth().signIn(withEmail: email, password: password) { [weak self] (user, error) in
            if error != nil {
                self?.displayWarningLabel(withText: error!.localizedDescription)
                return
            }
            
            if user != nil {
                self?.performSegue(withIdentifier: "tasksSegue", sender: nil)
                return
            }
            
            self?.displayWarningLabel(withText: "No such user!")
        }
    }
    
    func displayWarningLabel(withText text: String) {
        warningLabel.text = text
        
        UIView.animate(withDuration: 5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: [.curveEaseInOut], animations: { [weak self] in
            self?.warningLabel.isHidden = false
        }) { [weak self] complete in
            self?.warningLabel.isHidden = true
        }
    }
    
    @IBAction func registerButtonTapped(_ sender: UIButton) {
        guard let email = emailTextField.text, let password = passwordTextField.text, email != "", password != "" else {
            displayWarningLabel(withText: "Information is incorrect!")
            return
        }
        
        Auth.auth().createUser(withEmail: email, password: password) { [weak self] (user, error) in
            if error == nil {
                if user != nil {
                    self?.performSegue(withIdentifier: "tasksSegue", sender: nil)
                } else {
                    self?.displayWarningLabel(withText: "User is not created!")
                }
            } else {
                self?.displayWarningLabel(withText: error!.localizedDescription)
            }
        }
    }
    
    @IBAction func returnTextFieldPressed(_ sender: UITextField) {
        sender.resignFirstResponder() // resignFirstResponder уведомляет sender: UITextField о том, что его попросили отказаться от статуса первого ответчика во view, т.е. при нажатии return на клавиатуре sender'а клавиатура скрывается.
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        warningLabel.isHidden = true
        
        Auth.auth().addStateDidChangeListener { [weak self] (auth, user) in
            if user != nil {
                self?.performSegue(withIdentifier: "tasksSegue", sender: nil)
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        emailTextField.text = ""
        passwordTextField.text = ""
    }
    
    // При нажатии на любое место view, клавиатура Text Field'а, Text View убирается.
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
}
