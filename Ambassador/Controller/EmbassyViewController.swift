//
//  EmbassyViewController.swift
//  Ambassador
//
//  Created by زهور حسين on 26/05/1443 AH.
//

import Foundation
import UIKit
import Firebase
class EmbassyViewController: UIViewController {
    

override func viewDidLoad() {
    super.viewDidLoad()

    // Do any additional setup after loading the view.
}
    @IBAction func handleLogout(_ sender: Any) {
        do {
            try Auth.auth().signOut()
            if let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LandingNavigationController") as? UINavigationController {
                vc.modalPresentationStyle = .fullScreen
                self.present(vc, animated: true, completion: nil)
                print("******")
            }
            
        } catch{
            print("ERROR in signout",error.localizedDescription)
        }
    }
}
