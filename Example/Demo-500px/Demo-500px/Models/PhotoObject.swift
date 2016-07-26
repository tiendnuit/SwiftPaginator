//
//  PhotoObject.swift
//  Demo-500px
//
//  Created by Tien Doan on 2/22/16.
//  Copyright © 2016 tiendnuit. All rights reserved.
//

import Foundation
import ObjectMapper


/*!
* @class PhotoObject.
    PhotoObject includes all infos of photo.
*/

class PhotoObject: AbstractObject {

    var photoId: Int?
    var name: String?
    var description: String?
    var images:[ImageObject]?
    var likeCount:Int?
    var commentCount:Int?
    var user:UserObject?
    var createdDateString:String?{
        didSet{
            if createdDateString != nil {
                let formatter = NSDateFormatter()
                formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss-05:00"
                createdDate = formatter.dateFromString(createdDateString!)
            }
        }
    }
    var createdDate:NSDate?
    
    required init?(_ map: ObjectMapper.Map){
        super.init(map)
    }
    
    override func mapping(map: ObjectMapper.Map){
        photoId <- map["id"]
        description <- map["description"]
        name <- map["name"]
        images <- map["images"]
        likeCount <- map["favorites_count"]
        commentCount <- map["comments_count"]
        user <- map["user"]
        createdDateString <- map["created_at"]
    }
    
    func imageObject(sizeType:PhotoSizeType) -> ImageObject?{
        if let arr = images {
            return arr.filter{$0.sizeType == sizeType}.first
        }
        return nil
    }
}

