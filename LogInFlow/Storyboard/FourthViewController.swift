//
//  FourthViewController.swift
//  LogInFlow
//
//  Created by Macbook on 21/08/2021.
//

import UIKit

class FourthViewController: UIViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    @IBOutlet weak var profileImageView: UIImageView!
    
    @IBOutlet weak var passwordLabel: UITextField!
    @IBOutlet weak var emailLabel: UITextField!
    @IBOutlet weak var fnameLabel: UITextField!
    @IBOutlet weak var lnameLabel: UITextField!
    var user: User?
    override func viewDidLoad() {
        super.viewDidLoad()

        configuration()
    }
    func configuration(){
        handleUserInteraction(isInterraction: false)
        let editBarButton = UIBarButtonItem(title: "Edit", style: .plain, target: self, action: #selector(userInteractionconfiguration(_:)))
        navigationItem.rightBarButtonItem = editBarButton
        getUserDetails()
        uiConfiguration()
        let imageViewTapGesture = UITapGestureRecognizer(target: self, action: #selector(imageViewTapped))
        profileImageView.isUserInteractionEnabled = true
        profileImageView.addGestureRecognizer(imageViewTapGesture)
    }
    @objc
    func userInteractionconfiguration(_ sender:UIBarButtonItem){
        if sender.title == "Edit"{
            sender.title = "Done"
            handleUserInteraction(isInterraction: true)
        }else{
            sender.title = "Edit"
            handleUserInteraction(isInterraction: false)
        }
        
    }
    @objc
    func imageViewTapped(){
        openImagePicker()
    }

   
    @IBAction func saveBtnPressed(_ sender: UIButton) {
        guard let fname = fnameLabel.text else{return}
        guard let lname = lnameLabel.text else {return}
        guard let email = emailLabel.text else {return}
        guard let password = passwordLabel.text else{return}
        if let user = user{
            let userModel = UserModel(fname: fname, lname: lname, email: email, password: password, imagePath: user.imagePath ?? "")
            saveProfileImageToDocumentDirectory(fileName: user.imagePath ?? "")
            //print("THe image path is \(user.imagePath)")
            DatabaseHelper.shareInstance.updateUser(userModel: userModel, user: user)
            alertMessage()
            
            
        }
    }
    
    @IBAction func LogInBtnPressed(_ sender: UIButton) {
    }
    
   func getUserDetails(){
    let users = DatabaseHelper.shareInstance.getAllUsers()
    if let email = UserDefaults.standard.value(forKey: "UserEmail") as? String{
        let user = users.filter({
            $0.email == email
        }).first
        self.user = user
        fnameLabel.text = user?.fname
        lnameLabel.text = user?.lname
        emailLabel.text = user?.email
        passwordLabel.text = user?.password
        let documentURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
        let fileURL = documentURL?.appendingPathComponent(user?.imagePath ?? "").appendingPathExtension("png")
//            print("fileurl", fileURL)
//            print("path", fileURL?.path)
        profileImageView.image = UIImage(contentsOfFile: fileURL?.path ?? "")}
        
    }
    func handleUserInteraction(isInterraction: Bool){
        fnameLabel.isUserInteractionEnabled = isInterraction
        lnameLabel.isUserInteractionEnabled = isInterraction
        emailLabel.isUserInteractionEnabled = isInterraction
        passwordLabel.isUserInteractionEnabled = isInterraction
        
    }
    func uiConfiguration(){
        profileImageView.layer.cornerRadius = profileImageView.frame.height/2
    }
    func openImagePicker(){
        let picker = UIImagePickerController()
        picker.sourceType = .photoLibrary
        picker.delegate = self
        self.present(picker,animated: true)
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
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        dismiss(animated: true)
        guard let selectedImage = info[.originalImage] as? UIImage else{return}
        profileImageView.image = selectedImage
    }
    
    func alertMessage(){
        let alertController = UIAlertController(title: "Alert", message: "Your document is successfully updated in database.", preferredStyle: .alert)
        let okay = UIAlertAction(title: "Okay", style: .default) { (_) in
            
                if let loginViewController = self.storyboard?.instantiateViewController(identifier: "ThirdViewController") as? ThirdViewController{
                    self.navigationController?.pushViewController(loginViewController, animated: true)
                }
            
            
        }
        let cancel = UIAlertAction(title: "cancel", style: .cancel, handler: nil)
        alertController.addAction(okay)
        alertController.addAction(cancel)
        self.present(alertController, animated: true)
    }
    
}

