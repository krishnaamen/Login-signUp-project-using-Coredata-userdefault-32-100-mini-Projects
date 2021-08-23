//
//  ThirdViewController.swift
//  LogInFlow
//
//  Created by Macbook on 21/08/2021.
//

import UIKit

class ThirdViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

       
    }

    @IBAction func profileIcon(_ sender: UIButton) {
        if let myVC = self.storyboard?.instantiateViewController(identifier: "FourthViewController") as? FourthViewController{
            self.navigationController?.pushViewController(myVC, animated: true)
        }
    }
    
   

    @IBAction func logoutBtntapped(_ sender: UIButton) {
        UserDefaults.standard.removeObject(forKey: "UserEmail")
        if let loginViewController = self.storyboard?.instantiateViewController(identifier: "firstViewController") as? ViewController{
            let window = (UIApplication.shared.connectedScenes.first!.delegate as! SceneDelegate).window
            let navigationController = UINavigationController(rootViewController: loginViewController)
            navigationController.navigationBar.isHidden = true
            window?.rootViewController = navigationController
    }
    
    }}
