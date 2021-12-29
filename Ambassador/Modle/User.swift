//
//  User.swift
//  Ambassador
//
//  Created by زهور حسين on 24/05/1443 AH.
//

import Foundation
struct User {
    var id = ""
    var name = ""
    var imageUrl = ""
    var email = ""
    
    init(dict:[String:Any]) {
        if let id = dict["id"] as? String,
           let name = dict["name"] as? String,
           let imageUrl = dict["imageUrl"] as? String,
           let email = dict["email"] as? String {
            self.name = name
            self.id = id
            self.email = email
            self.imageUrl = imageUrl
        }
    }
}
