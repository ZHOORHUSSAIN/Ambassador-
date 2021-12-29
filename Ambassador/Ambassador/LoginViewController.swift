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
                    if let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "HomeNavigationController") as? UINavigationController {
Activity.removeIndicator(parentView: self.view, childView: self.activityIndicator)
                        self.present(vc, animated: true, completion: nil)
                }
    }
   
}
        }
    }
}
