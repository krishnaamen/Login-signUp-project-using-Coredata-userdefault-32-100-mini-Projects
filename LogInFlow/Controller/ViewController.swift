//
//  ViewController.swift
//  LogInFlow
//
//  Created by Macbook on 19/08/2021.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var profileImage: UIImageView!
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var signInButton: UIButton!
    @IBOutlet weak var signUpBtn: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        signUpBtn.applyDesign()
        signInButton.applyDesign()
    }


    @IBAction func logInButtonClicked(_ sender: UIButton) {
        guard let email = emailTextField.text else{return}
        guard let password = passwordTextField.text else{return}
        let users = DatabaseHelper.shareInstance.getAllUsers()
        let filterData = users.filter({
            $0.email == email && $0.password == password
        })
        if filterData.count>0{
            if let user = filterData.first{
                UserDefaults.standard.setValue(user.email, forKey: "UserEmail")
                if let vc = self.storyboard?.instantiateViewController(identifier: "ThirdViewController") as? ThirdViewController{
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            }
        }
        
    }
    
    @IBAction func signUpButtonPressed(_ sender: UIButton) {
        if let vc = self.storyboard?.instantiateViewController(identifier: "SecondViewController") as? SecondViewController{
            self.navigationController?.pushViewController(vc, animated: true)
        } }
}

extension UIButton {
    func applyDesign(){
        self.layer.cornerRadius = self.frame.height/2
        
    }
}
