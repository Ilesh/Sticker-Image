# Sticker-Image

<p align="center">
<img src="https://img.shields.io/badge/swift-4.0%2B-brightgreen.svg" alt="Swift 4.0"/>
<img src="https://img.shields.io/badge/platform-iOS-brightgreen.svg" alt="Platform: iOS"/>
<img src="https://img.shields.io/badge/xcode-10%2B-brightgreen.svg" alt="XCode 10+"/>
<img src="https://img.shields.io/badge/iOS-10%2B-brightgreen.svg" alt="iOS 10"/>
<img src="https://img.shields.io/badge/licence-MIT-lightgrey.svg" alt="licence MIT"/>
</a>
</p>

Sticker-Image is the demo-example of how to use sticekrs. It help you to adding stickr on `UIImageview` and `UIView`. It is very easy to implement in the existing project OR new project. Please find below the step of implemenation.

##### Also note, I am assumes you are comfortable with the basics of storyboards and view controllers.

![Adding sticker](https://i.imgflip.com/2vwqox.gif)
![Save and sharing](https://i.imgflip.com/2vwqnc.gif)

## Requirements

- iOS 10.0+
- Xcode 10

## Installation

Just add the `StickerView` file to your project.

or use [CocoaPods](https://cocoapods.org) with Podfile:
``` ruby
pod 'StickerView'
```
## Usage

1) If you are using pod then you need to import file.
```
import StickerView
```

2) Declare variable using below code.
```
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
```
3) Adding sticker on the View. Here I add sticker on the `UIImageview`.

```
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
```

4) Implement delegate methods
```
extension ViewController : StickerViewDelegate {

    func stickerViewDidTap(_ stickerView: StickerView) {
        self.selectedStickerView = stickerView
    }
    
    func stickerViewDidBeginMoving(_ stickerView: StickerView) {
        self.selectedStickerView = stickerView
    }
    
    /// Other delegate methods which we not used currently but choose method according to your event and requirements. 
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
```

5) For Save Image to the gallery.

we need to add permission first in the `info.plist` file.

```
<key>NSPhotoLibraryAddUsageDescription</key>
<string>Please allow access to save photo in your photo library</string>
```

```
@IBAction func btnSaveClick (sender:AnyObject) {
        selectedStickerView?.showEditingHandlers = false
        // CHECK HERE FIRST STICKER ADDED OR NOT?
        if self.imgSource.subviews.filter({$0.tag == 999}).count > 0 {
            if let image = mergeImages(imageView: imgSource){
                UIImageWriteToSavedPhotosAlbum(image, self, #selector(image(_:didFinishSavingWithError:contextInfo:)), nil)
            }else{
                print("Image not found !!")
            }
        }else{
            print("No Sticker is available.")
            //UIAlertController.showAlertWithOkButton(self, aStrMessage: "No Sticker is available.", completion: nil)
        }
    }
    
    //MARK: - Add image to Library
    @objc func image(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        if let error = error {
            // we got back an error!
            print("Save error")
            //UIAlertController.showAlertWithOkButton(self, aStrMessage: "Save error", completion: nil)
        } else {
            print("Your image has been saved to your photos.")
            //UIAlertController.showAlertWithOkButton(self, aStrMessage: "Your image has been saved to your photos.", completion: nil)
        }
    }
```

## Contributing

- If you **need help** or you'd like to **ask a general question**, open an issue.
- If you **found a bug**, open an issue.
- If you **have a feature request**, open an issue.
- If you **want to contribute**, submit a pull request.

## 👨🏻‍💻 Author

* **[Ilesh Panchal](https://twitter.com/ilesh_panchal)**

<a href="https://www.buymeacoffee.com/dD9nr61qx" target="_blank"><img src="https://www.buymeacoffee.com/assets/img/custom_images/black_img.png" alt="Buy Me A Coffee" style="height: auto !important;width: auto !important;" ></a>

## License

Sticker-Image is released under the MIT license.
See [LICENSE](./LICENSE) for details.






