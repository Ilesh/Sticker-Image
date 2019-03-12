//
//  ViewController.swift
//  StickerDemo
//
//  Created by macmini on 05/02/19.
//  Copyright © 2019 IP. All rights reserved.
//

import UIKit
import StickerView

class ViewController: UIViewController {

    @IBOutlet weak var imgSource : UIImageView!
    @IBOutlet weak var collectionView : UICollectionView!
    @IBOutlet weak var lblNoLable : UILabel!
    
    //MARK:- VARIABLE
    var imageSticker : UIImage!
    var arrStickers : [String] = ["100","101","102","103","104"]
    var arrBGImage : [String] = ["200","201","202"]
    
    private var _selectedStickerView:StickerView?
    var selectedStickerView:StickerView? {
        get {
            return _selectedStickerView
        }
        set {
            // if other sticker choosed then resign the handler
            if _selectedStickerView != newValue {
                if let selectedStickerView = _selectedStickerView {
                    selectedStickerView.showEditingHandlers = false
                }
                _selectedStickerView = newValue
            }
            // assign handler to new sticker added
            if let selectedStickerView = _selectedStickerView {
                selectedStickerView.showEditingHandlers = true
                selectedStickerView.superview?.bringSubviewToFront(selectedStickerView)
            }
        }
    }
    
    //MARK:- VIEW CYCLE START
    override func viewDidLoad() {
        super.viewDidLoad()
        //self.lblNoLable.isHidden = true
        collectionView.register(UINib(nibName: "StickerCell", bundle: nil), forCellWithReuseIdentifier: "StickerCell")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        imgSource.image = UIImage(named: self.arrBGImage[Int.random(in: 0..<3)])
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }

    @IBAction func btnSaveClick (sender:AnyObject) {
        selectedStickerView?.showEditingHandlers = false
        if self.imgSource.subviews.filter({$0.tag == 999}).count > 0 {
            if let image = mergeImages(imageView: imgSource){
                UIImageWriteToSavedPhotosAlbum(image, self, #selector(image(_:didFinishSavingWithError:contextInfo:)), nil)
            }else{
                print("Image not found !!")
            }
        }else{
            UIAlertController.showAlertWithOkButton(self, aStrMessage: "No Sticker is available.", completion: nil)
        }
    }
    
    //MARK: - Add image to Library
    @objc func image(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        if let error = error {
            // we got back an error!
            UIAlertController.showAlertWithOkButton(self, aStrMessage: "Save error", completion: nil)
        } else {
            UIAlertController.showAlertWithOkButton(self, aStrMessage: "Your image has been saved to your photos.", completion: nil)
        }
    }
    
    @IBAction func btnShareClick (sender:AnyObject) {
        selectedStickerView?.showEditingHandlers = false
        if self.imgSource.subviews.filter({$0.tag == 999}).count > 0 {
            if let image = mergeImages(imageView: imgSource){
                share(shareText: "", shareImage: image)
            }else{
                print("Image not found !!")
            }
        }else{
            UIAlertController.showAlertWithOkButton(self, aStrMessage: "No Sticker is available.", completion: nil)
        }
    }
    
    func mergeImages(imageView: UIImageView) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(imageView.frame.size, false, 0.0)
        imageView.superview!.layer.render(in: UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
    
    //MARK:- CUSTOM METHODS
    func share(shareText:String?,shareImage:UIImage?){
        
        var objectsToShare = [AnyObject]()
        
        if let shareTextObj = shareText{
            objectsToShare.append(shareTextObj as AnyObject)
        }
        
        if let shareImageObj = shareImage{
            objectsToShare.append(shareImageObj)
        }
        
        if shareText != nil || shareImage != nil{
            let activityViewController = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
            activityViewController.popoverPresentationController?.sourceView = self.view
            present(activityViewController, animated: true, completion: nil)
        }else{
            print("There is nothing to share")
        }
    }
    
}

extension ViewController : UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.arrStickers.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let aCell = collectionView.dequeueReusableCell(withReuseIdentifier: "StickerCell", for: indexPath) as! StickerCell
        aCell.imgProfile.image = UIImage(named: self.arrStickers[indexPath.item])
        return aCell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("Click Collection cell \(indexPath.item)")
        if let cell = collectionView.cellForItem(at: indexPath) as? StickerCell{
            if let imageSticker = cell.imgProfile.image {
                let testImage = UIImageView.init(frame: CGRect.init(x: 0, y: 0, width: 100, height: 100))
                testImage.image = imageSticker
                testImage.contentMode = .scaleAspectFit
                let stickerView3 = StickerView.init(contentView: testImage)
                stickerView3.center = CGPoint.init(x: 150, y: 150)
                stickerView3.delegate = self
                stickerView3.setImage(UIImage.init(named: "Close")!, forHandler: StickerViewHandler.close)
                stickerView3.setImage(UIImage.init(named: "Rotate")!, forHandler: StickerViewHandler.rotate)
                stickerView3.setImage(UIImage.init(named: "Flip")!, forHandler: StickerViewHandler.flip)
                stickerView3.showEditingHandlers = false
                stickerView3.tag = 999
                self.imgSource.addSubview(stickerView3)
                self.selectedStickerView = stickerView3
            }else{
                print("Sticker not loaded")
            }
        }
    }
}

extension ViewController : StickerViewDelegate {
    func stickerViewDidTap(_ stickerView: StickerView) {
        self.selectedStickerView = stickerView
    }
    
    func stickerViewDidBeginMoving(_ stickerView: StickerView) {
        self.selectedStickerView = stickerView
    }
    
    func stickerViewDidChangeMoving(_ stickerView: StickerView) {
        
    }
    
    func stickerViewDidEndMoving(_ stickerView: StickerView) {
        
    }
    
    func stickerViewDidBeginRotating(_ stickerView: StickerView) {
        
    }
    
    func stickerViewDidChangeRotating(_ stickerView: StickerView) {
        
    }
    
    func stickerViewDidEndRotating(_ stickerView: StickerView) {
        
    }
    
    func stickerViewDidClose(_ stickerView: StickerView) {
        
    }
}
