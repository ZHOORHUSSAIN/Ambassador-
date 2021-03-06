//
//  DetailsViewController.swift
//  Ambassador
//
//  Created by زهور حسين on 25/05/1443 AH.
//

import UIKit
import Firebase
class DetailsViewController: UIViewController {
    var selectedPost:Post?
    var selectedPostImage:UIImage?
    @IBOutlet weak var postimageview: UIImageView!{
        didSet{
            postimageview.layer.shadowColor = UIColor.gray.cgColor
            //        viewRegister.layer.shadowOpacity = 1
            postimageview.layer.shadowOffset = .zero
            postimageview.layer.cornerRadius = 10
            postimageview.layer.shadowPath = UIBezierPath(rect: postimageview.bounds).cgPath
            postimageview.layer.shouldRasterize = true
            self.postimageview.layer.cornerRadius = 10
        }
    }
    
    @IBOutlet weak var nameTextfild: UILabel!
    
    @IBOutlet weak var passportidtexfild: UILabel!
    
    
    @IBOutlet weak var phonenumbertextfild: UILabel!
    
    
    @IBOutlet weak var expirdatetextfild: UILabel!
    
    @IBOutlet weak var countrytextfild: UILabel!
    
    @IBOutlet weak var citytextfild: UILabel!
    
    @IBOutlet weak var nameofhoteltextfild: UILabel!
    
    @IBOutlet weak var dateofgoingtextfild: UILabel!
    
    
    @IBOutlet weak var dateofreturntextfild: UILabel!
    
    
    @IBOutlet weak var nextlable: UIButton!{
        didSet {
            nextlable.setTitle("next".localized, for: .normal)
        }
    }
    
    
    
    @IBOutlet weak var viewDetails: UIView!{
        didSet {
            viewDetails.layer.cornerRadius = 8
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        navigationItem.backBarButtonItem = UIBarButtonItem(title: "backButton".localized, style: .plain, target: nil, action: nil)
        if let selectedPost = selectedPost,
        let selectedImage = selectedPostImage{
            nameTextfild.text = selectedPost.name
            passportidtexfild.text = selectedPost.passportid
            postimageview.image = selectedImage
            phonenumbertextfild.text = selectedPost.phonenumber
            expirdatetextfild.text = selectedPost.expirdate
            countrytextfild.text = selectedPost.country
            citytextfild.text = selectedPost.city
            nameofhoteltextfild.text = selectedPost.nameofhotel
            dateofgoingtextfild.text = selectedPost.dateofgoing
            dateofreturntextfild.text = selectedPost.dateofreturn
            
        }

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
