//
//  PostCell.swift
//  Ambassador
//
//  Created by زهور حسين on 29/05/1443 AH.
//

import UIKit

class PostCell: UITableViewCell {

    @IBOutlet weak var postimageview: UIImageView!{
        didSet {
            postimageview.layer.shadowColor = UIColor.gray.cgColor
            //        viewRegister.layer.shadowOpacity = 1
            postimageview.layer.shadowOffset = .zero
            postimageview.layer.cornerRadius = 10
            postimageview.layer.shadowPath = UIBezierPath(rect: postimageview.bounds).cgPath
            postimageview.layer.shouldRasterize = true
            self.postimageview.layer.cornerRadius = 10
                    
        }
    }
    
    @IBOutlet weak var userimageView: UIImageView!{
        didSet {
            userimageView.layer.borderColor = UIColor.systemGray.cgColor
            userimageView.layer.borderWidth = 3.0
            userimageView.layer.cornerRadius = userimageView.bounds.height / 2
            userimageView.layer.masksToBounds = true
            userimageView.isUserInteractionEnabled = true
        }
    }
    
    @IBOutlet weak var usernamelable: UILabel!
    
    
//    @IBOutlet weak var namelable: UILabel!
    
    
    @IBOutlet weak var passportid: UILabel!
    
    
    @IBOutlet weak var phonenumber: UILabel!
    
    @IBOutlet weak var expirydate: UILabel!
    
    
    @IBOutlet weak var citylable: UILabel!
    @IBOutlet weak var country: UILabel!
    
    @IBOutlet weak var nameofhotel: UILabel!
    
    
    @IBOutlet weak var dateofgoing: UILabel!
    
    
    @IBOutlet weak var dateofreturn: UILabel!
    
    
    @IBOutlet weak var viewPostcell: UIView!{
        didSet {
            viewPostcell.layer.cornerRadius = 8
        }
    }
    
    @IBOutlet weak var viewImage: UIView!{
        didSet {
            viewImage.layer.cornerRadius = 8
        }
    }
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
            passportid.text = post.passportid
//            namelable.text = post.name
        
        phonenumber.text = post.phonenumber
        expirydate.text = post.expirdate
        country.text = post.country
        citylable.text = post.city
        nameofhotel.text = post.nameofhotel
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
    

