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
    
    
    @IBOutlet weak var namelable: UILabel!
    
    
    @IBOutlet weak var passportid: UILabel!
    
    
    
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
            namelable.text = post.name
            postimageview.loadImageUsingCache(with: post.imageUrl)
            userimageView.loadImageUsingCache(with: post.user.imageUrl)
            return self
    }
        
        override func prepareForReuse() {
            userimageView.image = nil
            postimageview.image = nil
        }
    }
    

