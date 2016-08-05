//
//  PhotosViewController.swift
//  Demo-500px
//
//  Created by Tien Doan on 2/23/16.
//  Copyright © 2016 tiendnuit. All rights reserved.
//

import Foundation
import UIKit
import SDWebImage
import ObjectMapper
import MBProgressHUD

// MARK: - PhotoCollectionViewCell
let photoReuseIdentifierCell = "PhotoCollectionViewCell"
class PhotoCollectionViewCell:UICollectionViewCell {
    
    @IBOutlet weak var imvPhoto: UIImageView!
    @IBOutlet weak var lbTitle: UILabel!
    @IBOutlet weak var lbAuthor: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        imvPhoto.setIndicatorStyle(UIActivityIndicatorViewStyle.Gray)
        imvPhoto.setShowActivityIndicatorView(true)
    }
}

// MARK: - PhotosViewController - Class
class PhotosViewController: BaseViewController {
    
    @IBOutlet weak var vwPhotosCollectionView: UICollectionView!
    var loading:UIActivityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: .Gray)
    var refreshControl:UIRefreshControl = UIRefreshControl()
    var paginator:PhotosPaginator = PhotosPaginator(size: Constants.APIConstants.kAPIResultsPerPage)
    var cateName:String?
    var category:CategoryObject!
    
    @IBOutlet weak var imvBackground: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = cateName!
        //pull to refresh
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: #selector(PhotosViewController.refreshData), forControlEvents:
            UIControlEvents.ValueChanged)
        vwPhotosCollectionView.addSubview(refreshControl)
        
        //loading
        loading.hidesWhenStopped = true
        loading.startAnimating()
        vwPhotosCollectionView.reloadData()

        paginator.category = cateName
        fetchFirstPage()
        
        if let photo = category.defaultPhoto, imageObj = photo.imageObject(PhotoSizeType.Standard) as ImageObject?, url = imageObj.url{
            imvBackground.sd_setImageWithURL(NSURL(string: url))
        }
    }
    
    // MARK: - Paginator methods
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
}

// MARK: - PhotosViewController - UICollectionViewDataSource, UICollectionViewDelegate
extension PhotosViewController : UICollectionViewDataSource, UICollectionViewDelegate {
    func numberOfSectionsInCollectionView(collectionView:
        UICollectionView) -> Int {
            return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return paginator.results.count //arrPhotos.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(photoReuseIdentifierCell, forIndexPath: indexPath) as! PhotoCollectionViewCell
        let photo = paginator.results[indexPath.row] as! PhotoObject
        if let imageObj = photo.imageObject(PhotoSizeType.Square280x280) as ImageObject?, url = imageObj.url{
            cell.imvPhoto.sd_setImageWithURL(NSURL(string: url))
        }
        
        cell.lbTitle.text = photo.name!
        cell.lbAuthor.text = photo.user!.username!
        if indexPath.row == paginator.results.count-1 {
            if !paginator.reachedLastPage() {
                fetchNextPage()
                loading.startAnimating()
            }else{
                loading.stopAnimating()
            }
        }
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        //let photo = paginator.results[indexPath.row] as! PhotoObject
        let photoDetailVC = mainStoryboard().instantiateViewControllerWithIdentifier("PhotoDetailVC") as! PhotoDetailViewController
        photoDetailVC.arrPhotos = paginator.results as AnyObject as! [PhotoObject]
        photoDetailVC.startIndex = indexPath
        
        photoDetailVC.modalTransitionStyle   = UIModalTransitionStyle.CrossDissolve
        self.presentViewController(photoDetailVC, animated: true, completion: nil)
    }
    
    func collectionView(collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
            var numOfCol:CGFloat = 2
            if IS_IPAD() {
                numOfCol = 4
            }

            let width = (ScreenSize.SCREEN_WIDTH - (numOfCol+1)*10)/numOfCol
            return CGSize(width: width, height: width)
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        if paginator.reachedLastPage() && paginator.results.count > 0{
            return CGSizeZero
        }
        return CGSizeMake(self.view.frame.size.width, 44)
    }
    
    func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
        if kind == UICollectionElementKindSectionFooter {
            let footer = collectionView.dequeueReusableSupplementaryViewOfKind(kind, withReuseIdentifier: "PhotoFooter", forIndexPath: indexPath)

            loading.center = CGPointMake(footer.frame.size.width/2, footer.frame.size.height/2)
            footer.addSubview(loading)
            return footer
        }
        return UICollectionReusableView()
    }
}