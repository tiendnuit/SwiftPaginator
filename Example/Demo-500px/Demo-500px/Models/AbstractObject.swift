//
//  AbstractObject.swift
//  Demo-500px
//
//  Created by Tien Doan on 2/22/16.
//  Copyright © 2016 tiendnuit. All rights reserved.
//

import Foundation
import ObjectMapper

class AbstractObject: Mappable {

    var modelName: String {
        return String(self.dynamicType)
    }
    
    required init?(_ map: ObjectMapper.Map){
        
    }
    
    func mapping(map: ObjectMapper.Map){
        
    }
}
