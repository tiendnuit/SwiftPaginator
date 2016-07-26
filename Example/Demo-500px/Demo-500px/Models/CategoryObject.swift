//
//  CategoryObject.swift
//  Demo-500px
//
//  Created by Tien Doan on 2/24/16.
//  Copyright © 2016 tiendnuit. All rights reserved.
//

import Foundation
import ObjectMapper
import SDWebImage

/*!
* @class CategoryObject.

*/
class CategoryObject: NSObject {
    var categoryType:Category?
    var categoryName:String?
    var defaultPhoto:PhotoObject?
    
    init(category:Category){
        super.init()
        categoryType = category
        categoryName = category.cateName
    }
    
    func updateCategoryPhoto(completedBlock:CompletedBlock){
        var params = Mapper<PhotoParamsInfo>().map([String : AnyObject]())!
        params.feature = "fresh_today"
        params.only = categoryName!
        params.size = "3,4,600"
        params.limit = NSNumber(integer: 1)
        params.page = NSNumber(integer:1)
        
        APIHelper.getPhotos(params) {[weak self] (response, data, error) -> Void in
            if let err = error {
                completedBlock(finished: false, error: err)
            }else if let dictData = data as! [String:AnyObject]?, photos = dictData["photos"]{
                let photo = Mapper<PhotoObject>().mapArray(photos)!.first
                self?.defaultPhoto = photo
                completedBlock(finished: true, error: nil)
            }
        }
    }
}