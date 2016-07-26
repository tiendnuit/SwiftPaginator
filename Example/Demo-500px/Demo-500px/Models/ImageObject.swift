//
//  ImageObject.swift
//  Demo-500px
//
//  Created by Tien Doan on 2/22/16.
//  Copyright © 2016 tiendnuit. All rights reserved.
//
import Foundation
import ObjectMapper
import SDWebImage

/*!
* @class ImageObject.
    Image's info: url, size and format
*/
class ImageObject: AbstractObject {
    
    var size: Int? {
        didSet{
            if let sizeId = size {
                sizeType = PhotoSizeType(rawValue: sizeId)
                
            }
        }
    }
    var format: String?
    var https_url: String?
    var url: String? {
        didSet{
            if sizeType == .Standard && url != nil{
                let manager:SDWebImageDownloader = SDWebImageDownloader.sharedDownloader()
                manager.shouldDecompressImages = false
                manager.downloadImageWithURL(NSURL(string: url!), options: SDWebImageDownloaderOptions.HighPriority, progress: nil, completed: {[weak self] (_, data:NSData?, _, finished:Bool) -> Void in
                    if finished {
                        if let data = data, image = UIImage(data: data) {
                            self?.image = image//.resizeImage(ScreenSize.SCREEN_WIDTH)
                        }
                        
                    }
                })
                
            }
        }
    }
    
    var sizeType:PhotoSizeType?
    var image:UIImage?
    
    required init?(_ map: ObjectMapper.Map){
        super.init(map)
    }
    
    override func mapping(map: ObjectMapper.Map){
        size <- map["size"]
        format <- map["format"]
        https_url <- map["https_url"]
        url <- map["url"]
    }
}
