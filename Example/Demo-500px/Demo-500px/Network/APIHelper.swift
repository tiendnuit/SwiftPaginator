//
//  APIHelper.swift
//  Demo-500px
//
//  Created by Tien Doan on 2/22/16.
//  Copyright © 2016 tiendnuit. All rights reserved.
//

import Foundation
import Alamofire
import ObjectMapper
import CoreLocation
import MBProgressHUD


final class APIBox<T> {
    let value: T
    
    init(value: T) {
        self.value = value
    }
}

enum APIResult<T> {
    case Success(APIBox<T>)
    case Failure(Error)
}

struct Error: CustomStringConvertible {
    let code: Int
    let serverCode: String
    let message: String
    var infoMessages: [String:String]? = nil
    var description: String {
        return "Error: code = \(code); serverCode = \(serverCode); message = \(message);"
    }
    var infoMessagesStr: String? {
        if let _infoMessages=infoMessages {
            var r=""
            for infM in _infoMessages.values {
                r = r + infM + "\n"
            }
            return r
        }
        else {
            return message
        }
        
    }
    
    init(code: Int,serverCode:String,message:String) {
        self.code=code
        self.serverCode=serverCode
        self.message=message
    }
    
    init(code: Int, serverCode:String, message:String, infoMessages:[String:String]?) {
        self.code=code
        self.serverCode=serverCode
        self.message=message
        self.infoMessages=infoMessages
    }
    
    static func errorWithMessage(message:String) -> Error{
        return Error(code: 0, serverCode: "0", message: message)
    }
}


func cannotGetResponseError() -> Error {
    return Error(code: 0, serverCode: "0", message: "Can not get data")
}


func wrongResponseError() -> Error {
    return Error(code: 0, serverCode: "0", message: "Wrong Response")
}

func wrongConfigFormat() -> Error {
    return Error(code: 0, serverCode: "x", message: "Wrong Config Format")
}

struct APIHelper {
    static func getError(success: Bool, dict: [String:AnyObject], response: NSHTTPURLResponse?) -> Error?{
        
        
        if success == false{
            let message = (dict["message"] as! String) ?? "Unknown"
            return Error.errorWithMessage(message)
        }else{
            
            if let dictData = dict["data"] as? [String:AnyObject] {
                if let status = dictData["status"] as? NSNumber where status.intValue == 0{
                    let message = (dictData["message"] as! String)  ?? "Unknown"
                    return Error.errorWithMessage(message)
                }else if let status = dictData["status"] as? NSString where status == "0"{
                    let message = (dictData["message"] as! String)  ?? "Unknown"
                    return Error.errorWithMessage(message)
                }else{
                    
                    return nil
                }
            }else{
                ///
                return nil //wrongResponseError()
            }
            
        }
    }
    
    static func checkErrors(response: NSHTTPURLResponse?, result: Result<AnyObject>) -> Error? {
        if result.isSuccess {
            return nil
//            let dict = result.value as! [String:AnyObject]
//            if let success = dict["status_code"] as? Bool {
//                return getError(success,dict: dict,response: response)
//            }
            
        } else {
            print(result.error)
        }
        
        return wrongResponseError()
    }
    
    //MARK: - PHOTOS
    /*!
    * @discussion This function using to get photos.
    * @param
    * @param
    * @param completionHandler Result block.
    * @return Void.
    */
    static func getPhotos(paramsInfo: PhotoParamsInfo, completionHandler: (response: NSHTTPURLResponse?, data: AnyObject?, error: Error?) -> Void){
        request(APIRouter.GetPhotos(paramsInfo)).responseJSON { (request, response, result) -> Void in
            if let _error = APIHelper.checkErrors(response, result:result) {
                completionHandler(response: response, data: result.value, error:_error)
            } else {
                if let _json = result.value as? [String: AnyObject]{
                    //print(_json)
                    //let arrPhotos = Mapper<PhotoObject>().mapArray(photos)
                    completionHandler(response: response, data: _json, error:nil)
                } else {
                    completionHandler(response: response, data: result.data, error:wrongResponseError())
                }
            }
        }
    }
    
}
