# SwiftPaginator
A simple Swift class for easier pagination.
<p>This project was heavily inspired by <a href="https://github.com/nmondollot/NMPaginator">NMPaginator</a></p> 

<h2>How to use</h2>
Copy <b>SwiftPaginator.swift</b> file into your project.
<p>Create a <b>subclass SwiftPaginator</b> and override function <code>func fetchResults(page: Int, pageSize: Int, completed:CompletedFetchBlock)</code></p>
```Swift
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
```
<p>Init and usage SwiftPaginator instance in ViewController</p>
```Swift
  var paginator:PhotosPaginator = PhotosPaginator(size: 10)
  
  func refreshData(){
        refreshControl.endRefreshing()
        fetchFirstPage()
        vwPhotosCollectionView.reloadData()
        loading.startAnimating()
    }
    
    func fetchFinished(finished:Bool){
        if finished {
            loading.stopAnimating()
            vwPhotosCollectionView.reloadData()
        }else{
            loading.stopAnimating()
            showSimpleAlert("Error", message: "Cannot get photos!", presentingController: self)
        }
    }
    
    func fetchFirstPage(){
        paginator.fetchFirstPage { (finished) in
            self.fetchFinished(finished)
        }
    }
    
    func fetchNextPage(){
        paginator.fetchNextPage { (finished) in
            self.fetchFinished(finished)
        }
    }
```
<p>You can see more detail in demo project</p>
