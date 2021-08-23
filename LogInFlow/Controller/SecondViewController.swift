//
//  SecondViewController.swift
//  LogInFlow
//
//  Created by Macbook on 19/08/2021.
//

import UIKit
import CoreData

class SecondViewController: UIViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate {

    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var fnameLabel: UITextField!
    @IBOutlet weak var lnameLabel: UITextField!
    @IBOutlet weak var emailLabel: UITextField!
    @IBOutlet weak var passwordLabel: UITextField!
    @IBOutlet weak var signUpBttnlabel: UIButton!
    @IBOutlet weak var Loginlabel: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        signUpBttnlabel.applyDesign()
        Loginlabel.applyDesign()
        configuration()
        
    }
    

    
    @IBAction func LoginBtnPressed(_ sender: UIButton) {
        if let Vc = self.storyboard?.instantiateViewController(identifier: "firstViewController") as? ViewController{
            self.navigationController?.pushViewController(Vc, animated: true)
            
        }
    }
    @IBAction func signUpBtnPressed(_ sender: UIButton) {
        keyBoardConfiguration()
        guard let fname = fnameLabel.text, !fname.isEmpty else{
            openAlert(message: "Please enter firstname")
            return
        }
        guard let lname = lnameLabel.text, !lname.isEmpty else{
            openAlert(message: "Please enter lastname")
            return
        }
        guard let email = emailLabel.text, !email.isEmpty else{
            openAlert(message: "Please enter valid email address")
            return
        }
        guard let password = passwordLabel.text, !password.isEmpty else{
            openAlert(message: "Please enter valid password")
            return
        }
        if !isValidPassword(password){
            openAlert(message: "Your password is not valide please enter at least 1 alphabet, 1 number, minimum length of password 8 characters.")
            return
        }
        if profileImageView.image?.pngData() == UIImage(systemName: "person.circle.fill")?.pngData(){
            openAlert(message: "Please select profile picture")
            return
        }
        
        let fileName = UUID().uuidString
        saveProfileImageToDocumentDirectory(fileName: fileName)
        let userModel = UserModel(fname: fname, lname: lname, email: email, password: password, imagePath: fileName)
        DatabaseHelper.shareInstance.saveUser(userModel: userModel)
        openAlert(message: "Successfully Registered!!!", isSuccess: true)
    }
    
}
extension SecondViewController{
    func configuration(){
        gestureConfiguration()
        uiConfiguration()
        
    }
    func uiConfiguration(){
        profileImageView.layer.cornerRadius = profileImageView.frame.height/2
        
    }
    func gestureConfiguration(){
        let gesture = UITapGestureRecognizer(target: self, action: #selector(imageTapped))
        profileImageView.addGestureRecognizer(gesture)
        let viewGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboardwhenTappedOnView))
        
    }
    @objc
    func imageTapped(){
        keyBoardConfiguration()
        openImagePicker()
        
    }
    @objc
    func hideKeyboardwhenTappedOnView(){
        
    }
    
    func keyBoardConfiguration(){
        self.view.endEditing(true)
    }
    func openImagePicker(){
        let picker = UIImagePickerController()
        picker.sourceType = .photoLibrary
        picker.delegate = self
        self.present(picker, animated: true)
    }
    func saveProfileImageToDocumentDirectory(fileName:String){
        let documentURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
        let fileUrl = documentURL?.appendingPathComponent(fileName).appendingPathExtension("png")
        if let data = profileImageView.image?.pngData(),let url = fileUrl{
            do{
                try data.write(to: url)
                print("Successfully saved to database")
            }catch{
                print(error.localizedDescription)
            }
        }
        
    }
    
    
}
extension SecondViewController{
    
    func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }
    
    func isValidPassword(_ password: String) -> Bool {
        let emailRegEx = "^(?=.*[A-Za-z])(?=.*\\d)[A-Za-z\\d]{8,}$"
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: password)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        dismiss(animated: true)
        guard let selectedImage = info[.originalImage] as? UIImage else{return}
        profileImageView.image = selectedImage
    }
    func openAlert(message: String, isSuccess:Bool = false){
        let alertController = UIAlertController(title: "Alert", message: message, preferredStyle: .alert)
        let okay = UIAlertAction(title: "Okay", style: .default) { (_) in
            if isSuccess{
                if let loginViewController = self.storyboard?.instantiateViewController(identifier: "firstViewController") as? ViewController{
                    self.navigationController?.pushViewController(loginViewController, animated: true)
                }
            
            }
        }
        let cancel = UIAlertAction(title: "cancel", style: .cancel, handler: nil)
        alertController.addAction(okay)
        alertController.addAction(cancel)
        self.present(alertController, animated: true)
    }
}
