//
//  LoginViewController.swift
//  Ambassador
//
//  Created by زهور حسين on 22/05/1443 AH.
//

import UIKit
import Firebase
class LoginViewController: UIViewController {
var activityIndicator = UIActivityIndicatorView()
    
    
    @IBOutlet weak var emailTextfildlogin: UITextField!{
        didSet {
            emailTextfildlogin.layer.cornerRadius = 15
            emailTextfildlogin.layer.shadowRadius = 10
            emailTextfildlogin.layer.shadowOpacity = 0.3
        }
    }
    
    
    @IBOutlet weak var psswordTextfildlogin: UITextField!
    
    
    @IBOutlet weak var lableEmaillogin: UILabel!{
        didSet {
            lableEmaillogin.text = "Email".localized
        }
    }
    
    
    @IBOutlet weak var lablepasswordlogin: UILabel!{
        didSet {
            lablepasswordlogin.text = "Password".localized
        }
    }
    
    @IBOutlet weak var loginButton: UIButton!{
        didSet {
            loginButton.setTitle("Login".localized, for: .normal)
        }
    }
    
    @IBOutlet weak var ORLoginlable: UILabel!{
        didSet {
            ORLoginlable.text = "OR".localized
        }
    }
    
    
    
    @IBOutlet weak var Registerlogin: UIButton!{
        didSet {
            Registerlogin.setTitle("Register".localized, for: .normal)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "backButton".localized, style: .plain, target: nil, action: nil)
        // Do any additional setup after loading the view.
    }
    
    @IBAction func eyePassword(_ sender: AnyObject) {
        
        psswordTextfildlogin.isSecureTextEntry.toggle()
                       if  psswordTextfildlogin.isSecureTextEntry {
                           if let image = UIImage(systemName: "eye.fill") {
                               sender.setImage(image, for: .normal)
                           }
                       } else {
                           if let image = UIImage(systemName: "eye.slash.fill") {
                               sender.setImage(image, for: .normal)
                           }
                       }
                   }

    
    
    @IBAction func handleLogin(_ sender: Any) {
        
        if let email = emailTextfildlogin.text,
           let password = psswordTextfildlogin.text {
            Activity.showIndicator(parentView: self.view, childView: activityIndicator)
            Auth.auth().signIn(withEmail: email, password: password) {
        authResult, error in
                if let _ = authResult {
                    if let currentUser = Auth.auth().currentUser {
                    let db = Firestore.firestore()
                db.collection("users").document(currentUser.uid).getDocument { userSnapshot, error in
                    if let error = error{
                        Alert.showAlert(strTitle: "Error", strMessage: error.localizedDescription, viewController: self)
                                            Activity.removeIndicator(parentView: self.view, childView: self.activityIndicator)
                                            print("Registration Auth Error",error.localizedDescription)
                                        }
                        
                        
                    //   print(error)
                
                    if let userSnapshot = userSnapshot,
                       let userData = userSnapshot.data(){
                        let user = User(dict: userData)
                       let storyboard = UIStoryboard(name: "Main", bundle: nil)
                        if user.usertype {
                            let embassyviewcontroller = storyboard.instantiateViewController(identifier: "EmbassyNavigationController")
                            embassyviewcontroller.modalPresentationStyle = .fullScreen
                            self.present(embassyviewcontroller, animated: true, completion: nil)
                        }else {
                            let embassyviewcontroller = storyboard.instantiateViewController(identifier: "HomeNavigationController")
                            embassyviewcontroller.modalPresentationStyle = .fullScreen
                            self.present(embassyviewcontroller, animated: true, completion: nil)
                        }
                        }
                }
//if let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "HomeNavigationController") as? UINavigationController {
//                      Activity.removeIndicator(parentView: self.view, childView: self.activityIndicator)
//                        self.present(vc, animated: true, completion: nil)
//                        
//                }
    }
   
                }else {
                    if let error = error {
                        Alert.showAlert(strTitle: "Error", strMessage: error.localizedDescription, viewController: self)
                        Activity.removeIndicator(parentView: self.view, childView: self.activityIndicator)
                        print("Registration Auth Error",error.localizedDescription)
                        
                    }
                    
                    
                }
        }
    }
}
}
