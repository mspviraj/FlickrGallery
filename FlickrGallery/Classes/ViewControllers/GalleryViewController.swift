//
//  GalleryViewController.swift
//  FlickrGallery
//
//  Created by Stephen Vinouze on 17/11/2015.
//
//

import UIKit
import FlickrKit
import SDWebImage

class GalleryViewController : UICollectionViewController {
    
    private let kFlickrApiKey = "035a49b6782ea1221be5cd6eecca4730"
    private let kFlickrApiSecret = "5a1cde0b4d0a7c96"
    private var photos = [NSURL]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let flickrKit = FlickrKit.sharedFlickrKit()
        flickrKit.initializeWithAPIKey(kFlickrApiKey, sharedSecret: kFlickrApiSecret)
        flickrKit.call(FKFlickrInterestingnessGetList()) { (response, error) -> Void in
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                
                if (response != nil) {
                    let topPhotos = response["photos"] as! [NSObject: AnyObject]
                    let photoArray = topPhotos["photo"] as! [[NSObject: AnyObject]]
                    for photoDictionary in photoArray {
                        let photoURL = flickrKit.photoURLForSize(FKPhotoSizeSmall240, fromPhotoDictionary: photoDictionary)
                        self.photos.append(photoURL)
                    }
                    self.collectionView?.reloadData()
                }
                else {
                    switch error.code {
                    case FKFlickrInterestingnessGetListError.ServiceCurrentlyUnavailable.rawValue:
                        break;
                    default:
                        break;
                    }
                    
                    let alertController = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .Alert)
                    alertController.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
                    
                    self.presentViewController(alertController, animated: true, completion: nil)
                }
            })
        }
    }
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photos.count
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("gallery_cell_identifier", forIndexPath: indexPath) as! GalleryCell
        cell.backgroundColor = UIColor.blackColor()
        cell.photo.sd_setImageWithURL(photos[indexPath.row])
        
        return cell
    }
    
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
    }
    
}
