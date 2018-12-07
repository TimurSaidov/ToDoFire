//
//  ViewController.swift
//  ToDoFire
//
//  Created by Timur Saidov on 07/12/2018.
//  Copyright © 2018 Timur Saidov. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var warningLabel: UILabel!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBAction func loginButtonTapped(_ sender: UIButton) {
    }
    
    @IBAction func registerButtonTapped(_ sender: UIButton) {
    }
    
    @IBAction func returnTextFieldPressed(_ sender: UITextField) {
        sender.resignFirstResponder() // resignFirstResponder уведомляет sender: UITextField о том, что его попросили отказаться от статуса первого ответчика во view, т.е. при нажатии return на клавиатуре sender'а клавиатура скрывается.
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // При нажатии на любое место view, клавиатура Text Field'а, Text View убирается.
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
}
