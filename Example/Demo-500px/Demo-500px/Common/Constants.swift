//
//  Constants.swift
//  Demo-500px
//
//  Created by Tien Doan on 2/22/16.
//  Copyright © 2016 tiendnuit. All rights reserved.
//

import Foundation

struct Constants {
    struct APIConstants {
        static let API_BASE_URL             = "https://api.500px.com/"
        static let API_CONSUMER_KEY         = "jHbbruGLUhw2Wt2Ey0xgxeisApBi6jIOTkcxkva4"
        static let kAPIResultsPerPage       = 20
        
        //api param keys
        static let kAPIGetPhotos            = "v1/photos"
    }
    
}

// MARK: - ENUM
enum PhotoSizeType:Int {
    case SmallSquare = 1        // 70x70
    case NormalSquare = 2       // 140x140
    case Square280x280 = 3      // 280x280
    case BigSquare = 600        // 600x600
    case Small = 30             // 256px on the longest edge
    case Standard = 4           // 900px on the longest edge
}

enum Category:Int{
    case Uncategorized = 0
    case Celebrities = 1
    case Film = 2
    case Journalism = 3
    case Nude = 4
    case BlackAndWhite = 5
    case StillLife = 6
    case People = 7
    case Landscapes = 8
    case CityAndArchitecture = 9
    case Abstract = 10
    case Animals = 11
    case Macro = 12
    case Travel = 13
    case Fashion = 14
    case Commercial = 15
    case Concert = 16
    case Sport = 17
    case Nature = 18
    case PerformingArts = 19
    case Family = 20
    case Street = 21
    case Underwater = 22
    case Food = 23
    case FineArt = 24
    case Wedding = 25
    case Transportation = 26
    case UrbanExploration = 27

    
    var cateName:String{
        switch self {
        case .Uncategorized:
            return "Uncategorized"
        case .Celebrities:
            return "Celebrities"
        case .Film:
            return "Film"
        case .Journalism:
            return "Journalism"
        case .Nude:
            return "Nude"
        case .BlackAndWhite:
            return "Black and White"
        case .StillLife:
            return "Still Life"
        case .People:
            return "People"
        case .Landscapes:
            return "Landscapes"
        case .CityAndArchitecture:
            return "City and Architecture"
        case .Abstract:
            return "Abstract"
        case .Animals:
            return "Animals"
        case .Macro:
            return "Macro"
        case .Travel:
            return "Travel"
        case .Fashion:
            return "Fashion"
        case .Commercial:
            return "Commercial"
        case .Concert:
            return "Concert"
        case .Sport:
            return "Sport"
        case .Nature:
            return "Nature"
        case .PerformingArts:
            return "Performing Arts"
        case .Family:
            return "Family"
        case .Street:
            return "Street"
        case .Underwater:
            return "Underwater"
        case .Food:
            return "Food"
            
        case .FineArt:
            return "Fine Art"
        case .Wedding:
            return "Wedding"
        case .Transportation:
            return "Transportation"
        case .UrbanExploration:
            return "Urban Exploration"
        }
    }

}

//MARK: - BLOCK
typealias CompletedBlock = ((finished: Bool, error:Error?) -> Void)
typealias ConfirmBlock = ((confirm: Bool) -> Void)
