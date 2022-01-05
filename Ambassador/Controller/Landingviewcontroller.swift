//
//  Landingviewcontroller.swift
//  Ambassador
//
//  Created by زهور حسين on 22/05/1443 AH.
//

import UIKit

class Landingviewcontroller: UIViewController {
    @IBOutlet weak var segmntedcontroller: UISegmentedControl!{
        didSet {
            if let lang = UserDefaults.standard.string(forKey: "currentLanguage") {
                       switch lang {
                       case "ar":
                           segmntedcontroller.selectedSegmentIndex = 0
                       case "en":
                           segmntedcontroller.selectedSegmentIndex = 1
                       default:
                           let localLang =  Locale.current.languageCode
                            if localLang == "en" {
                                segmntedcontroller.selectedSegmentIndex = 1
                            
                            }else {
                                segmntedcontroller.selectedSegmentIndex = 0
                            }
                         
                       }
                   
                   }else {
                       let localLang =  Locale.current.languageCode
                       UserDefaults.standard.setValue([localLang], forKey: "AppleLanaguge")
                        if localLang == "en" {
                            segmntedcontroller.selectedSegmentIndex = 1
                            
                        }else {
                            
                            segmntedcontroller.selectedSegmentIndex = 0
                            segmntedcontroller.selectedSegmentIndex = 1
                        }
                   }
               }
    }
    
    @IBOutlet weak var Login: UIButton!{
        didSet {
            Login.setTitle(NSLocalizedString("Login", tableName: "Localizable", comment: ""), for: .normal)
    
        }
    }
    @IBOutlet weak var OR: UILabel!{
        didSet {
            OR.text = "OR".localized
        }
    }
    @IBOutlet weak var Register: UIButton!{
        didSet {
            Register.setTitle(NSLocalizedString("Register", tableName: "Localizable",  comment: ""), for: .normal)
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    

    @IBAction func segmintedcontrollerchangelangege(_ sender: UISegmentedControl) {
        
        if let language = sender.titleForSegment(at: sender.selectedSegmentIndex)?.lowercased(){
            if language == "ar"{
                    UIView.appearance().semanticContentAttribute = .forceRightToLeft
                  }else{
                    UIView.appearance().semanticContentAttribute = .forceLeftToRight
                  }
            UserDefaults.standard.set(language, forKey: "currentLanguage")
            Bundle.setLanguage(language)
            let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
            if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
               let sceneDelegate = windowScene.delegate as? SceneDelegate {
                sceneDelegate.window?.rootViewController = storyboard.instantiateInitialViewController()
            }
        }
    }
}
       extension String {
           var localized: String {
               return NSLocalizedString(self, tableName: "Localizable", bundle: .main, value: self, comment: self)
           }
       }
    
