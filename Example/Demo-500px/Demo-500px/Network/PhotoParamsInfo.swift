//
//  PhotoParamsInfo.swift
//  Demo-500px
//
//  Created by Tien Doan on 2/22/16.
//  Copyright © 2016 tiendnuit. All rights reserved.
//

import Foundation
import ObjectMapper

struct PhotoParamsInfo: Mappable{
    var feature: String!
    var only: String?
    var limit: NSNumber?
    var page: NSNumber?
    var size: String?
    
    init?(_ map: ObjectMapper.Map) {
        feature = "popular"
        limit = Constants.APIConstants.kAPIResultsPerPage
        page = NSNumber(integer: 1)
    }
    
    mutating func mapping(map: ObjectMapper.Map) {
        feature <- map["feature"]
        only <- map["only"]
        limit <- map["rpp"]
        page <- map["page"]
        size <- map["image_size"]
    }
}
