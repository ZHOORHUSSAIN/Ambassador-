//
//  RegisterViewController.swift
//  Ambassador
//
//  Created by زهور حسين on 22/05/1443 AH.
//

import UIKit
import Firebase
class RegisterViewController: UIViewController {
    let imagePickerController = UIImagePickerController()
    let activityIndicator = UIActivityIndicatorView()
    
    @IBOutlet weak var userimageview: UIImageView!{
        didSet {
            userimageview.layer.borderColor = UIColor.systemBrown.cgColor
            userimageview.layer.borderWidth = 3.0
            userimageview.layer.cornerRadius = userimageview.bounds.height / 2
            userimageview.layer.masksToBounds = true
            let tabGesture = UITapGestureRecognizer(target: self, action: #selector(selectImage))
            userimageview.addGestureRecognizer(tabGesture)
            userimageview.isUserInteractionEnabled = true
            
        }
        
    }
    
    @IBOutlet weak var nameTextfild: UITextField!
    
    
    @IBOutlet weak var emailTextfild: UITextField!
    
    @IBOutlet weak var passwordTextfild: UITextField!
    
    
    @IBOutlet weak var passwordConfirmationtextfild: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePickerController.delegate = self
        // Do any additional setup after loading the view.
    }
    
    @IBAction func handleRegister(_ sender: Any) {
        if let image = userimageview.image,
           let imageData = image.jpegData(compressionQuality: 0.75),
           let name = nameTextfild.text,
           let email = emailTextfild.text,
           let password = passwordTextfild.text,
           let confirmPassword = passwordConfirmationtextfild.text,
           password == confirmPassword {
           // print("here!!!!!!!")

            Activity.showIndicator(parentView: self.view, childView: activityIndicator)
            Auth.auth().createUser(withEmail: email, password: password){
                authResult, error in
                if let error = error {
                    print("Registration Auth Error",error.localizedDescription)
                }
                if let authResult = authResult {
                    let storageRef = Storage.storage().reference(withPath: "users/\(authResult.user.uid)")
                    let uploadMeta = StorageMetadata.init()
                    uploadMeta.contentType = "image/jpeg"
                    storageRef.putData(imageData, metadata: uploadMeta) { StorageMeta,
                        error in
                        if let error = error {
                            print("Registration Storage Error",error.localizedDescription)
                        }
                        storageRef.downloadURL {url, erroe in
                            if let error = error {
                                print ("Registration Storage Download Url Error",error.localizedDescription)
                            }
                            if let url = url {
                                print("URL",url.absoluteString)
                                let db = Firestore.firestore()
                                let userData: [String:Any] = [
                                    "id":authResult.user.uid,
                                    "name":name,
                                    "email":email,
                                    "usertype":false ,
                                    "imageUrl":url.absoluteString
                                ]
                                db.collection("users").document(authResult.user.uid)
                                    .setData(userData) {error in
                                        if let error = error {
                                            print("Registration Database error",error.localizedDescription)
                                        }else {
                                            if let vc = UIStoryboard(name: "Main", bundle: nil)
                                                .instantiateViewController(withIdentifier: "HomeNavigationController") as? UINavigationController{
                                                vc.modalPresentationStyle = .fullScreen
                                                Activity.removeIndicator(parentView: self.view, childView: self.activityIndicator)
                                                self.present(vc, animated: true, completion: nil)
                                            }
                                        }
                                    }
                            }
                        }
                    }
                }
            }
        }
    }
}


extension RegisterViewController: UIImagePickerControllerDelegate,UINavigationControllerDelegate{
    @objc func selectImage() {
        showAlert()
        
    }
    func showAlert() {
        let alert = UIAlertController(title: "choose Profile Picture", message: "where do you want to pick your image from?", preferredStyle: .actionSheet)
        let cameraAction = UIAlertAction(title: "Camera", style: .default) {Action in
            self.getImage(from: .camera)
        }
        
        let galaryAction = UIAlertAction(title: "photo Album", style: .default) {Action in
            self.getImage(from: .photoLibrary)
        }
        let dismissAction = UIAlertAction(title: "Cancle", style: .destructive) {Action in
            self.dismiss(animated: true, completion: nil)
        }
        alert.addAction(cameraAction)
        alert.addAction(galaryAction)
        alert.addAction(dismissAction)
        self.present(alert, animated: true, completion: nil)
    }
    func getImage( from sourceType: UIImagePickerController.SourceType){
        if UIImagePickerController.isSourceTypeAvailable(sourceType){
            imagePickerController.sourceType = sourceType
            self.present(imagePickerController, animated: true, completion: nil)
        }
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController,didFinishPickinMediawithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        guard let chosenImag = info[UIImagePickerController.InfoKey.originalImage]
                as? UIImage else { return}
        userimageview.image = chosenImag
        dismiss(animated: true, completion: nil)
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}
