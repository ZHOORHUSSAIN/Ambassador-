//
//  PostCell.swift
//  Ambassador
//
//  Created by زهور حسين on 29/05/1443 AH.
//

import UIKit

class PostCell: UITableViewCell {

    @IBOutlet weak var postimageview: UIImageView!
    
    @IBOutlet weak var userimageView: UIImageView!
    
    @IBOutlet weak var usernamelable: UILabel!
    
    
//    @IBOutlet weak var namelable: UILabel!
    
    
    @IBOutlet weak var passportid: UILabel!
    
    
    @IBOutlet weak var phonenumber: UILabel!
    
    @IBOutlet weak var expirydate: UILabel!
    
    
    @IBOutlet weak var country: UILabel!
    
    @IBOutlet weak var nameofhotel: UILabel!
    
    
    @IBOutlet weak var dateofgoing: UILabel!
    
    
    @IBOutlet weak var dateofreturn: UILabel!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configure(with post:Post) -> UITableViewCell {
            usernamelable.text = post.name
            passportid.text = post.id
//            namelable.text = post.name
        
        phonenumber.text = post.phonenumber
        expirydate.text = post.expirdate
        country.text = post.country
       // nameofhotel.text = post.
        dateofgoing.text = post.dateofgoing
        dateofreturn.text = post.dateofreturn
            postimageview.loadImageUsingCache(with: post.imageUrl)
            userimageView.loadImageUsingCache(with: post.user.imageUrl)
            return self
    }
        
        override func prepareForReuse() {
            userimageView.image = nil
            postimageview.image = nil
        }
    }
    

