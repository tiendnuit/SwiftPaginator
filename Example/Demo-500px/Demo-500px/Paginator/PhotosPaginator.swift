//
//  PhotosPaginator.swift
//  Demo-500px
//
//  Created by Tien Doan on 2/23/16.
//  Copyright © 2016 tiendnuit. All rights reserved.
//

import Foundation
import ObjectMapper

class PhotosPaginator:SwiftPaginator {
    var category:String?
    
    override func fetchResults(page: Int, pageSize: Int, completed:CompletedFetchBlock) {
        var params = Mapper<PhotoParamsInfo>().map([String : AnyObject]())!
        params.feature = "fresh_today"
        params.only = category!
        params.size = "3,4,600,30"
        params.limit = NSNumber(integer: pageSize)
        params.page = NSNumber(integer:page)
        APIHelper.getPhotos(params) {(response, data, error) -> Void in
            dispatch_async(dispatch_get_main_queue(), {[weak self] () -> Void in
                if let _ = error {
                    self?.fetchFailed(completed)
                }else {
                    if let dictData = data as! [String:AnyObject]?, photos = dictData["photos"]{
                        let total = dictData["total_items"]?.integerValue
                        let arrPhotos = Mapper<PhotoObject>().mapArray(photos)!
                        self?.fetchSucceed(arrPhotos, totalPages: total!, completed: completed)
                    }else{
                        self?.fetchFailed(completed)
                    }
                }
            })
        }
    }
}