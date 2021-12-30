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
    
    
    @IBOutlet weak var emailTextfildlogin: UITextField!
    
    
    @IBOutlet weak var psswordTextfildlogin: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
                        print(error)
                    }
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
if let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "HomeNavigationController") as? UINavigationController {
                      Activity.removeIndicator(parentView: self.view, childView: self.activityIndicator)
                        self.present(vc, animated: true, completion: nil)
                        
                }
    }
   
}
        }
    }
}
}
