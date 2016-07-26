//
//  PhotoDetailViewController.swift
//  Demo-500px
//
//  Created by Tien Doan on 2/24/16.
//  Copyright © 2016 tiendnuit. All rights reserved.
//

import Foundation
import UIKit
import SDWebImage
// MARK: - PhotoDetailCollectionViewCell
let photoDetailReuseIdentifierCell = "PhotoDetailCollectionViewCell"
let MAXIMUM_SCALE = CGFloat(3.0)
let MINIMUM_SCALE = CGFloat(0.5)
class PhotoDetailCollectionViewCell:UICollectionViewCell, UIScrollViewDelegate {
    
    @IBOutlet weak var vwScrollview: UIScrollView!
    @IBOutlet weak var imvPhoto: UIImageView!
    @IBOutlet weak var imageWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var imageHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var lbTitle: UILabel!
    @IBOutlet weak var imvAvatar: UIImageView!
    @IBOutlet weak var lbUsername: UILabel!
    @IBOutlet weak var lbTimer: UILabel!
    @IBOutlet weak var lbLikeCount: UILabel!
    @IBOutlet weak var lbCommentCount: UILabel!
    @IBOutlet weak var vwBottom: UIView!
    var timer:NSTimer?
    
    var photoObj:PhotoObject?{
        didSet{
            //update image
            imvPhoto.image = nil
            showInfo(true)
            zoomImage(1)
            if let imageObj = photoObj!.imageObject(PhotoSizeType.Standard) as ImageObject?, image = imageObj.image{
                imvPhoto.image = image
//                imageWidthConstraint.constant = image.size.width
//                imageHeightConstraint.constant = image.size.height
                imageWidthConstraint.constant = ScreenSize.SCREEN_WIDTH
                imageHeightConstraint.constant = ScreenSize.SCREEN_WIDTH*image.size.height/image.size.width
            }else if let imageObj = photoObj!.imageObject(PhotoSizeType.Standard) as ImageObject?, url = imageObj.url{
                let manager:SDWebImageDownloader = SDWebImageDownloader.sharedDownloader()
                manager.downloadImageWithURL(NSURL(string: url), options: SDWebImageDownloaderOptions.HighPriority, progress: nil, completed: {[weak self] (aa:UIImage!, data:NSData?, _, finished:Bool) -> Void in
                    if finished {
                        dispatch_async(dispatch_get_main_queue(), {[weak self] () -> Void in
                            if let data = data, image = UIImage(data: data) {
                                imageObj.image = image//.resizeImage(ScreenSize.SCREEN_WIDTH)
                                self?.imvPhoto.image = imageObj.image
                                
                                self?.imageWidthConstraint.constant = ScreenSize.SCREEN_WIDTH
                                self?.imageHeightConstraint.constant = ScreenSize.SCREEN_WIDTH*image.size.height/image.size.width
                            }
                        })
                    }
                    
                })
            }
            
            //update info
            lbTitle.text = photoObj?.name
            lbLikeCount.text = "\(photoObj!.likeCount!)"
            lbCommentCount.text = "\(photoObj!.commentCount!)"
            lbUsername.text = photoObj!.user!.username!
            lbTimer.text = timeFromNow(photoObj!.createdDate)
            if let urlStr = photoObj?.user?.avatarURL {
                imvAvatar.sd_setImageWithURL(NSURL(string: urlStr))
            }
            
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        //avatar
        imvAvatar.setIndicatorStyle(UIActivityIndicatorViewStyle.White)
        imvAvatar.setShowActivityIndicatorView(true)
        imvAvatar.layer.masksToBounds = true
        imvAvatar.layer.cornerRadius = imvAvatar.bounds.size.width/2
        
        imvPhoto.setIndicatorStyle(UIActivityIndicatorViewStyle.White)
        imvPhoto.setShowActivityIndicatorView(true)
        
        let pinch = UIPinchGestureRecognizer(target: self, action: "pinch:")
        imvPhoto.gestureRecognizers = [pinch]
        imvPhoto.userInteractionEnabled = true
        vwScrollview.delegate = self
        
        let tap = UITapGestureRecognizer(target: self, action: "tapOnView:")
        self.addGestureRecognizer(tap)
    }
    
    @IBAction func tapOnView(sender: AnyObject) {
        showInfo(true)
    }
    
    
    func showInfo(show:Bool){
        timer?.invalidate()
        timer = nil
        
        let option = show ? UIViewAnimationOptions.CurveEaseOut : UIViewAnimationOptions.CurveEaseIn
        let alpha:CGFloat = show ? 1.0 : 0.0
        UIView.animateWithDuration(0.3, delay: 0, options: option, animations: { () -> Void in
            self.vwBottom.alpha = alpha
            }, completion: { (finished) -> Void in
                if show {
                    self.timer = NSTimer.scheduledTimerWithTimeInterval(3.0, target: self, selector: "hideInfo", userInfo: nil, repeats: false)
                }
        })
    }
    
    func hideInfo(){
        showInfo(false)
    }
    
    func pinch(gesture:UIPinchGestureRecognizer) {
        if gesture.state == UIGestureRecognizerState.Ended || gesture.state == UIGestureRecognizerState.Changed{
            let currentScale = self.frame.size.width / self.bounds.size.width
            let newScale = currentScale*gesture.scale
            
            zoomImage(newScale)
        }
    }
    
    func zoomImage(scale:CGFloat){
        var newScale = scale
        if newScale < MINIMUM_SCALE {
            newScale = MINIMUM_SCALE
        }
        
        if newScale > MAXIMUM_SCALE {
            newScale = MAXIMUM_SCALE
        }
        
        let transform = CGAffineTransformMakeScale(newScale, newScale)
        imvPhoto.transform = transform
        vwScrollview.contentSize = imvPhoto.frame.size
    }
    
    //MARK: UIScrollViewDelegate
    func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView? {
        return imvPhoto
    }
}

// MARK: - PhotoDetailViewController - Class
class PhotoDetailViewController: UIViewController {
    @IBOutlet weak var vwPhotosCollectionView: UICollectionView!
    @IBOutlet weak var btnClose: UIButton!
    
    var arrPhotos:[PhotoObject] = [PhotoObject]()
    var photo:PhotoObject?
    var startIndex:NSIndexPath = NSIndexPath(forRow: 0, inSection: 0)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        vwPhotosCollectionView.alpha = 0.0
        vwPhotosCollectionView.reloadData()
        self.performSelector("showCollectionView", withObject: nil, afterDelay: 0.1)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        
        vwPhotosCollectionView.setContentOffset(CGPointMake(CGFloat(startIndex.row)*ScreenSize.SCREEN_WIDTH, 0), animated: false)
    }
    
    func showCollectionView(){
        self.vwPhotosCollectionView.scrollToItemAtIndexPath(self.startIndex, atScrollPosition: UICollectionViewScrollPosition.Left, animated: false)
        UIView.animateWithDuration(0.3) {[weak self] () -> Void in
            if self != nil {
                self!.vwPhotosCollectionView.alpha = 1.0
            }
            
        }
        
    }
    
    
    //MARK: - Event methods
    @IBAction func btnCancelClicked(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
}


// MARK: - PhotoDetailViewController - UICollectionViewDataSource, UICollectionViewDelegate
extension PhotoDetailViewController : UICollectionViewDataSource, UICollectionViewDelegate {
    func numberOfSectionsInCollectionView(collectionView:
        UICollectionView) -> Int {
            return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrPhotos.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(photoDetailReuseIdentifierCell, forIndexPath: indexPath) as! PhotoDetailCollectionViewCell
        let photo = arrPhotos[indexPath.row]
        cell.photoObj = photo
        
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {

    }
    
    func collectionView(collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
//            var numOfCol:CGFloat = 2
//            if IS_IPAD() {
//                numOfCol = 4
//            }
//            
//            let photo = arrPhotos[indexPath.row]
//            if let imageObj = photo.imageObject(PhotoSizeType.Standard) as ImageObject?, image = imageObj.image{
//                return image.size
//            }
            
            //let width = (ScreenSize.SCREEN_WIDTH - (numOfCol+1)*10)/numOfCol
            let frame = collectionView.frame
            return CGSize(width: frame.size.width, height: frame.size.height)
    }
}