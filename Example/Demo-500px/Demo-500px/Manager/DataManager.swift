//
//  DataManager.swift
//  Demo-500px
//
//  Created by Tien Doan on 2/24/16.
//  Copyright © 2016 tiendnuit. All rights reserved.
//

import Foundation
/*!
* @discussion This class using to manager global data for categories....

*/
class DataManager: NSObject {
    static let sharedInstance = DataManager()
    let arrCategories:[CategoryObject] = [CategoryObject(category: .Uncategorized), CategoryObject(category: .Celebrities), CategoryObject(category: .Film), CategoryObject(category: .Journalism), CategoryObject(category: .Nude), CategoryObject(category: .BlackAndWhite), CategoryObject(category: .StillLife), CategoryObject(category: .People), CategoryObject(category: .Landscapes), CategoryObject(category: .CityAndArchitecture), CategoryObject(category: .Abstract), CategoryObject(category: .Animals), CategoryObject(category: .Macro), CategoryObject(category: .Travel), CategoryObject(category: .Fashion), CategoryObject(category: .Commercial), CategoryObject(category: .Concert), CategoryObject(category: .Sport), CategoryObject(category: .Nature), CategoryObject(category: .PerformingArts), CategoryObject(category: .Family), CategoryObject(category: .Street), CategoryObject(category: .Underwater), CategoryObject(category: .Food), CategoryObject(category: .FineArt), CategoryObject(category: .Wedding), CategoryObject(category: .Transportation), CategoryObject(category: .UrbanExploration)]
    
    func updateCategoriesInfo(completedBlock:CompletedBlock){
        let group:dispatch_group_t = dispatch_group_create()

        for cate in arrCategories {
            dispatch_group_async(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0))
                {
                    let sem:dispatch_semaphore_t  = dispatch_semaphore_create(0);
                    cate.updateCategoryPhoto({ (finished, error) -> Void in
                        dispatch_semaphore_signal(sem)
                    })
                    dispatch_semaphore_wait(sem, DISPATCH_TIME_FOREVER);
                }
            
            dispatch_group_notify(group, dispatch_get_main_queue()){
                completedBlock(finished: true, error: nil);
            }
        }
    }
}