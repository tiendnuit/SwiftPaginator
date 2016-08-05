//
//  CategoryViewController.swift
//  Demo-500px
//
//  Created by Tien Doan on 2/23/16.
//  Copyright © 2016 tiendnuit. All rights reserved.
//

import Foundation
import UIKit
import MBProgressHUD
// MARK: - CategoryCollectionViewCell
let categoryReuseIdentifierCell = "CategoryCell"
class CategoryCollectionViewCell: UICollectionViewCell{
    
    @IBOutlet weak var imvCategory: UIImageView!
    @IBOutlet weak var lbName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.layer.borderColor = UIColor.grayColor().CGColor
        self.layer.borderWidth = 1
        imvCategory.setIndicatorStyle(UIActivityIndicatorViewStyle.White)
        imvCategory.setShowActivityIndicatorView(true)
    }
    
}


// MARK: - PhotosViewController
class CategoryViewController: BaseViewController {
    @IBOutlet weak var vwCategoriesCollection: UICollectionView!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.automaticallyAdjustsScrollViewInsets = false
        MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        DataManager.sharedInstance.updateCategoriesInfo { (finished, error) -> Void in
            dispatch_async(dispatch_get_main_queue(), {[weak self] () -> Void in
                MBProgressHUD.hideAllHUDsForView(self!.view, animated: true)
                self?.vwCategoriesCollection.reloadData()
            })
            
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        //vwCategoriesCollection.contentOffset = CGPointZero
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

// MARK: - CategoryViewController - UICollectionView delegate & datasource
extension CategoryViewController:UICollectionViewDataSource, UICollectionViewDelegate {
    func numberOfSectionsInCollectionView(collectionView:
        UICollectionView) -> Int {
            return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return DataManager.sharedInstance.arrCategories.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(categoryReuseIdentifierCell, forIndexPath: indexPath) as! CategoryCollectionViewCell
        let category = DataManager.sharedInstance.arrCategories[indexPath.row]
        cell.lbName.text = category.categoryName
        if let photo = category.defaultPhoto, imageObj = photo.imageObject(PhotoSizeType.Square280x280) as ImageObject?, url = imageObj.url{
            cell.imvCategory.sd_setImageWithURL(NSURL(string: url))
        }
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        let category = DataManager.sharedInstance.arrCategories[indexPath.row]
        
        let photosVC = mainStoryboard().instantiateViewControllerWithIdentifier("PhotosVC") as! PhotosViewController
        photosVC.cateName = category.categoryName
        photosVC.category = category
        self.navigationController!.pushViewController(photosVC, animated: true)
        
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
}