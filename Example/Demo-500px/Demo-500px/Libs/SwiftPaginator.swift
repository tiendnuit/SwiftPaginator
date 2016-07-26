//
//  SwiftPaginator.swift
//  Demo-500px
//
//  Created by Tien Doan on 3/8/16.
//  Copyright © 2016 tiendnuit. All rights reserved.
//

import Foundation


enum RequestStatus {
    case None
    case InProgress
    case Done
}

typealias CompletedFetchBlock = ((finished: Bool) -> Void)

public class SwiftPaginator:NSObject {
    var pageSize        = 0         // number of results per page
    var page            = 0         // current page
    var total           = 0         // total number of all items
    var requestStatus   = RequestStatus.None
    var results:[AnyObject] = [AnyObject]()
    
    
    init(size: Int) {
        super.init()
        reset()
        pageSize = size
    }
    
    //reset all value to default
    public func reset(){
        //pageSize = 0
        page = 0
        total = 0
        requestStatus = RequestStatus.None
        results = [AnyObject]()
    }
    
    //check paginator reached last page
    public func reachedLastPage() -> Bool{
        if requestStatus == .None {
            return false
        }
        
        if pageSize == 0 {
            return true
        }
        
        let totalPages = Int(ceil(Float(total)/Float(pageSize)))
        return page >= totalPages
    }
    
    //fetch next page
    func fetchNextPage(completed:CompletedFetchBlock){
        if requestStatus == .InProgress {
            return
        }
        
        if !reachedLastPage() {
            requestStatus = .InProgress
            fetchResults(page+1, pageSize: pageSize, completed: completed)
        }
    }
    
    //fetch first page
    func fetchFirstPage(completed:CompletedFetchBlock){
        reset()
        fetchNextPage(completed)
    }
    
    
    //begin fetch results
    func fetchResults(page:Int, pageSize:Int, completed:CompletedFetchBlock){
        //override this in subclass
    }
    
    //fetch succeed -> set all value to next page and callback block
    func fetchSucceed(results:[AnyObject], totalPages:Int, completed:CompletedFetchBlock){
        self.results.appendContentsOf(results)
        page += 1
        total = totalPages
        requestStatus = .Done
        
        completed(finished: true)
    }
    
    //fetch failed
    func fetchFailed(completed:CompletedFetchBlock){
        requestStatus = .Done
        completed(finished: false)
    }
    
}