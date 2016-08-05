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
    @IBOutlet weak var lbTitle: UILabel!
    @IBOutlet weak var imvAvatar: UIImageView!
    @IBOutlet weak var lbUsername: UILabel!
    @IBOutlet weak var lbTimer: UILabel!
    @IBOutlet weak var lbLikeCount: UILabel!
    @IBOutlet weak var lbCommentCount: UILabel!
    @IBOutlet weak var vwBottom: UIView!
    var timer:NSTimer?
//    
    @IBOutlet weak var imageTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var imageBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var imageTrailingConstraint: NSLayoutConstraint!
    @IBOutlet weak var imageLeadingConstraint: NSLayoutConstraint!
    
    var photoObj:PhotoObject?{
        didSet{
            //update image
            imvPhoto.image = nil
            updateZoomScale(imvPhoto.bounds.size)
            showInfo(true)

            if let imageObj = photoObj!.imageObject(PhotoSizeType.Standard) as ImageObject?, image = imageObj.image{
                imvPhoto.image = image

                updateZoomScale(image.size)
            }else if let imageObj = photoObj!.imageObject(PhotoSizeType.Standard) as ImageObject?, url = imageObj.url{
                let manager:SDWebImageDownloader = SDWebImageDownloader.sharedDownloader()
                manager.downloadImageWithURL(NSURL(string: url), options: SDWebImageDownloaderOptions.HighPriority, progress: nil, completed: {[weak self] (aa:UIImage!, data:NSData?, _, finished:Bool) -> Void in
                    if finished {
                        dispatch_async(dispatch_get_main_queue(), {[weak self] () -> Void in
                            if let data = data, image = UIImage(data: data) {
                                imageObj.image = image//.resizeImage(ScreenSize.SCREEN_WIDTH)
                                self?.imvPhoto.image = imageObj.image

                                self?.updateZoomScale(imageObj.image!.size)
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
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        updateZoomScale(imvPhoto.bounds.size)
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
        
        vwScrollview.delegate = self
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(PhotoDetailCollectionViewCell.tapOnView(_:)))
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
                    self.timer = NSTimer.scheduledTimerWithTimeInterval(3.0, target: self, selector: #selector(PhotoDetailCollectionViewCell.hideInfo), userInfo: nil, repeats: false)
                }
        })
    }
    
    func hideInfo(){
        showInfo(false)
    }
    
    func updateZoomScale(size:CGSize){
        if imvPhoto.image == nil {
            vwScrollview.minimumZoomScale = 1
            vwScrollview.zoomScale = 1
        }else{
            let widthScale = ScreenSize.SCREEN_WIDTH / size.width
            let heightScale = ScreenSize.SCREEN_HEIGHT / size.height
            let minScale = min(widthScale, heightScale)
            
            vwScrollview.minimumZoomScale = minScale
            vwScrollview.zoomScale = minScale
        }
        
        updateLayoutConstraints()
    }
    
    func updateLayoutConstraints(){
        let yOffset = max(0, (ScreenSize.SCREEN_HEIGHT - imvPhoto.frame.height) / 2)
        imageTopConstraint.constant = yOffset
        imageBottomConstraint.constant = yOffset
        
        let xOffset = max(0, (ScreenSize.SCREEN_WIDTH - imvPhoto.frame.width) / 2)
        imageLeadingConstraint.constant = xOffset
        imageTrailingConstraint.constant = xOffset
        
        layoutIfNeeded()
    }
    
    //MARK: UIScrollViewDelegate
    func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView? {
        return imvPhoto
    }
    
    func scrollViewDidZoom(scrollView: UIScrollView) {
        //vwScrollview.contentSize = imvPhoto.frame.size
        //layoutIfNeeded()
        //setNeedsDisplay()
        updateLayoutConstraints()
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
        self.performSelector(#selector(PhotoDetailViewController.showCollectionView), withObject: nil, afterDelay: 0.1)
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
            let frame = collectionView.frame
            return CGSize(width: frame.size.width, height: frame.size.height)
    }
}