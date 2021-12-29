//
//  Post.swift
//  Ambassador
//
//  Created by زهور حسين on 24/05/1443 AH.
//


import Foundation
import Firebase
struct Post {
    var name = ""
    var imageUrl = ""
    var user:User
    var passportid = ""
    var expirdate = ""
    var country = ""
    var city = ""
    var phonenumber = ""
    var nameofhotel = ""
    var dateofgoing = ""
    var dateofreturn = ""
    var createdAt:Timestamp?

init(dict:[String:Any],id:String,user :User) {
    if let name = dict["name"] as? String,
//       let passportid = dict["passportid"] as? String,
       let imageUrl = dict["imageUrl"] as? String,
       let expirdate = dict["expirdate"] as? String,
       let country = dict["country"] as? String,
       let city = dict["city"] as? String,
       let phonenumber = dict["phonenumber"] as? String,
       let nameofhotel = dict["nameofhotel"] as? String,
       let dateofgoing = dict["dateofgoing"] as? String,
       let dateofreturn = dict["dateofgoing"] as? String,
       let createdAt = dict["createdAt"] as? Timestamp {
        self.name = name
        self.imageUrl = imageUrl
        self.expirdate = expirdate
        self.country = country
        self.city = city
        self.phonenumber = phonenumber
        self.nameofhotel = nameofhotel
        self.dateofgoing = dateofgoing
        self.dateofreturn = dateofreturn
        self.createdAt = createdAt
}
    self.passportid = id
      self.user = user
}
}