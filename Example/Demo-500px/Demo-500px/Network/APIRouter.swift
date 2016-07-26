//
//  APIRouter.swift
//  Demo-500px
//
//  Created by Tien Doan on 2/22/16.
//  Copyright © 2016 tiendnuit. All rights reserved.
//

import Foundation
import Alamofire
import ObjectMapper


enum APIRouter: URLRequestConvertible {
    static let baseURLString = Constants.APIConstants.API_BASE_URL
    static let consumerKey = Constants.APIConstants.API_CONSUMER_KEY
    
    case GetPhotos(PhotoParamsInfo)
    case GetPhotoDetail
    var method: Alamofire.Method {
        switch self {
            
        case .GetPhotos:
            return .GET
        case .GetPhotoDetail:
            return .GET
        }
    }
    var URLRequest: NSMutableURLRequest {
        let result: (path: String, parameters: [String: AnyObject]) = {
            switch self {
                //Get photos
            case .GetPhotos(let info):
                return (Constants.APIConstants.kAPIGetPhotos, Mapper().toJSON(info))
                
            case .GetPhotoDetail():
                return (Constants.APIConstants.kAPIGetPhotos, [String: AnyObject]())
                
            }
            
        }()
        let URL = NSURL(string: APIRouter.baseURLString)
        let mutableURLRequest = NSMutableURLRequest(URL: URL!.URLByAppendingPathComponent(result.path))
        mutableURLRequest.HTTPMethod = method.rawValue
   
        let encoding = Alamofire.ParameterEncoding.URL
        var params = result.parameters
        params["consumer_key"] = APIRouter.consumerKey
        
        print("Request: \(mutableURLRequest)")
        print("Params: \(params)")
        
        return encoding.encode(mutableURLRequest, parameters: params).0
    }
}
