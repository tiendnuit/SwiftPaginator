//
//  UserObject.swift
//  Demo-500px
//
//  Created by Tien Doan on 2/24/16.
//  Copyright © 2016 tiendnuit. All rights reserved.
//

import Foundation
import ObjectMapper
import SDWebImage

/*!
* @class UserObject.
    User info: name, username, avatar...
*/
class UserObject: AbstractObject {
    var userId: Int?
    var username: String?
    var avatarURL:String?
    
    required init?(_ map: ObjectMapper.Map){
        super.init(map)
    }
    
    override func mapping(map: ObjectMapper.Map){
        userId <- map["id"]
        username <- map["username"]
        avatarURL <- map["userpic_url"]
    }

}