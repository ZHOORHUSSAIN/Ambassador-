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
    @IBOutlet weak var postimageview: UIImageView!
    
    @IBOutlet weak var nameTextfild: UILabel!
    
    @IBOutlet weak var passportidtexfild: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let selectedPost = selectedPost,
        let selectedImage = selectedPostImage{
            nameTextfild.text = selectedPost.name
            passportidtexfild.text = selectedPost.passportid
            postimageview.image = selectedImage
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
