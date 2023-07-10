//
//  DetailViewController.swift
//  Calculator_01
//
//  Created by mac1014 on 2021/2/19.
//  Copyright © 2021 Kong. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate, UITextFieldDelegate, UITextViewDelegate {
    
    // Navigation Item outlet
    var item: Item!
    
    // MARK: photo Key For Delete
    var photoKeyForDelete: String? = nil
    // MARK: text view key close
    var textViewKeyClose: String? = nil
    
    @IBOutlet weak var navigationOutlet: UINavigationItem!
    // clear first responder, dismiss the keyboard
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    // MARK: - scrollView outlet
    @IBOutlet weak var scrollViewOutlet: UIScrollView!
    
    // MARK: - SplitViewDispalyMode
    var splitViewWithGesture: UISplitViewController? = nil
    @IBOutlet weak var displayModeButtonOutlet: UIButton!
    @IBAction func displayModeButton(_ sender: UIButton) {
        let device = UIDevice.current.model
        switch device {
        case "iPhone":
            splitViewWithGesture?.preferredDisplayMode = .primaryOverlay
        case "iPad":
//            switch UIDevice.current.orientation {
//            case .landscapeRight, .landscapeLeft:
//                print("lr or ll")
//                if splitViewWithGesture?.preferredDisplayMode != .allVisible {
//                    splitViewWithGesture?.preferredDisplayMode = .allVisible
//                } else {
//                    splitViewWithGesture?.preferredDisplayMode = .primaryHidden
//                }
//            case .portrait, .portraitUpsideDown:
//                print("p or pud")
//                splitViewWithGesture?.preferredDisplayMode = .primaryOverlay
//            default:
//                print("other")
//            }
            splitViewWithGesture?.preferredDisplayMode = .primaryOverlay
        default:
            splitViewWithGesture?.preferredDisplayMode = .primaryOverlay
        }
        print(device)
    }
    
    @objc func receiverOrientationChange() {
        let orient = UIDevice.current.orientation
        switch orient {
        case .portrait, .portraitUpsideDown:
            print("p or pud")
            splitViewWithGesture?.preferredDisplayMode = .primaryHidden
        case .landscapeLeft, .landscapeRight:
            print("ll or lr")
            splitViewWithGesture?.preferredDisplayMode = .allVisible
        default:
            print("other")
            splitViewWithGesture?.preferredDisplayMode = .primaryOverlay
        }
    }
    
    // MARK: - get drawView
//    lazy var drawView: DrawView = self.view.viewWithTag(1) as! DrawView
    @IBOutlet weak var drawView: DrawView!
    
    // MARK: - drawView property
    let drawViewShadowColor = CGColor(srgbRed: 0, green: 0, blue: 0, alpha: 1)
    let drawViewShadowOpacity: Float = 0.2
    let drawViewShadowRadius: CGFloat = 8
    let drawViewShadowOffset: CGSize = CGSize(width: -6, height: -6)
    
    //
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        UIDevice.current.beginGeneratingDeviceOrientationNotifications()
        NotificationCenter.default.addObserver(self, selector: #selector(receiverOrientationChange), name: UIDevice.orientationDidChangeNotification, object: nil)
    }
    
    // MARK: - view will disappear
    override func viewWillDisappear(_ animated:Bool) {
        super.viewWillDisappear(animated)
        // MARK: 右滑返回手势识别设置
        navigationController?.interactivePopGestureRecognizer?.isEnabled = true;
        
        // save title change to item
        item.title = (navigationOutlet.titleView as! UITextField).text ?? item.title
        
        // clear first responder, dismiss the keyboard
        navigationOutlet.titleView?.endEditing(true)
        
        splitViewWithGesture?.preferredDisplayMode = .automatic
        UIDevice.current.endGeneratingDeviceOrientationNotifications()
    }
    
    // MARK: - view did appear
    override func viewDidAppear(_ animated:Bool) {
        // MARK: 右滑返回手势识别设置
        navigationController?.interactivePopGestureRecognizer?.isEnabled = false;
    }
    
    // MARK: - view did load
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // MARK: scroll gesture
//        scrollViewOutlet.isScrollEnabled = false
        scrollViewOutlet.panGestureRecognizer.minimumNumberOfTouches = 2
        scrollViewOutlet.panGestureRecognizer.maximumNumberOfTouches = 2
        
//        scrollViewOutlet.pinchGestureRecognizer
        
        // MARK: navigation title
//        navigationOutlet.title = Itemtitle
        let detailViewTitle = UITextField()
        detailViewTitle.text = item.title
        detailViewTitle.backgroundColor = .none
        detailViewTitle.textColor = UIColor.label
        detailViewTitle.font = UIFont.systemFont(ofSize: 19)
        detailViewTitle.adjustsFontSizeToFitWidth = true
        detailViewTitle.keyboardType = .default
        detailViewTitle.isUserInteractionEnabled = true
        // clear first responder, dismiss the keyboard
        detailViewTitle.delegate = self
        
        navigationOutlet.titleView = detailViewTitle
        
        // Do any additional setup after loading the view.
        // MARK: view shandow setting
        drawView.layer.shadowColor = drawViewShadowColor
        drawView.layer.shadowOpacity = drawViewShadowOpacity
        drawView.layer.shadowRadius = drawViewShadowRadius
        drawView.layer.shadowOffset = drawViewShadowOffset
        
        // MARK: line width stepper setting
        lineWidthStepperOutlet.value = 3
        
        // MARK: color button corner and border setting
        colorButtonCornerAndBorder()
        
        // MARK: handle pinch
        drawView.isUserInteractionEnabled = true
        let pinch = UIPinchGestureRecognizer(target: self, action: #selector(drawViewPinch(byHandlingGestureRecognizedBy:)))
//        pinch.delaysTouchesBegan = true
        drawView.addGestureRecognizer(pinch)
        
        // MARK: handle rotation
        let rotation = UIRotationGestureRecognizer(target: self, action: #selector(drawViewRotation(byHandlingGestureRecognizedBy:)))
        rotation.shouldBeRequiredToFail(by: pinch)
//        rotation.delaysTouchesBegan = true
        drawView.addGestureRecognizer(rotation)
        
        // MARK: handle pan
        let pan = UIPanGestureRecognizer(target: self, action: #selector(drawViewPan(byHandlingGestureRecognizedBy:)))
//        pan.delaysTouchesBegan = true
        pan.minimumNumberOfTouches = 3
        pan.maximumNumberOfTouches = 3
        drawView.addGestureRecognizer(pan)
        
        // MARK: handle LonePress
        let lonePress = UILongPressGestureRecognizer(target: self, action: #selector(drawViewLongPress(byHandlingGestureRecognizedBy:)))
        lonePress.allowableMovement = 5
        drawView.addGestureRecognizer(lonePress)
        
        
        
        
    }

    // MARK: - tool choice
    func getLineType(selectedIndex: Int) -> String {
        return "\(selectedIndex)"
    }
    
    // MARK: - tool segment choice
    @IBOutlet weak var toolSegmentedOutlet: UISegmentedControl!
    @IBAction func toolSegmentedControl(_ sender: UISegmentedControl) {
        drawView.tool = drawView.toolKit[sender.selectedSegmentIndex]
        drawView.lineStore = drawView.lineStoreKit[sender.selectedSegmentIndex]
        if drawView.tool is EraserTool {
            drawView.lineColor = drawView.backgroundColor!
        } else if drawView.lineColor == drawView.backgroundColor! {
            drawView.lineColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        }
        
        drawView.lineType = getLineType(selectedIndex: sender.selectedSegmentIndex)
    }
    
    // MARK: - line color
    @IBOutlet var colorChange: [UIButton]!
    @IBAction func colorChangeAction(_ sender: UIButton) {
        guard drawView.tool is EraserTool else {
            switch sender.accessibilityIdentifier {
            case "blackButton"?:
                drawView.lineColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
            case "blueButton"?:
                drawView.lineColor = #colorLiteral(red: 0, green: 0, blue: 1, alpha: 1)
            case "redButton"?:
                drawView.lineColor = #colorLiteral(red: 1, green: 0, blue: 0, alpha: 1)
            default:
                drawView.lineColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
            }
            return
        }
    }
    
    // MARK: - line width
    @IBOutlet weak var lineWidthStepperOutlet: UIStepper!
    @IBAction func lineWidthStepperControl(_ sender: UIStepper) {
        let lineWidth: CGFloat = CGFloat(sender.value)
        drawView.lineWidth = lineWidth
        print(sender.value)
    }
    
    // MARK: - draw view color button set
    func colorButtonCornerAndBorder() {
        if colorChange != nil {
            for button in colorChange {
                button.layer.cornerRadius = button.frame.height / 2
                button.layer.borderWidth = 3
                button.layer.borderColor =  #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
            }
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: - Gesture
    @objc func drawViewPinch(byHandlingGestureRecognizedBy recognizer: UIPinchGestureRecognizer) {
        switch recognizer.state {
        case .changed, .ended:
            drawView.transform = drawView.transform.scaledBy(x: recognizer.scale, y: recognizer.scale)
            recognizer.scale = 1.0
        default:
            break
        }
        
    }
    
    @objc func drawViewRotation(byHandlingGestureRecognizedBy recognizer: UIRotationGestureRecognizer) {
        switch recognizer.state {
        case .began, .changed:
            drawView.transform = drawView.transform.rotated(by: recognizer.rotation)
            recognizer.rotation = 0.0
        default:
            break
        }
        
    }
    
    var startCenter = CGPoint.zero
    @objc func drawViewPan(byHandlingGestureRecognizedBy recognizer: UIPanGestureRecognizer) {
        let translation = recognizer.translation(in: drawView.superview)
        if recognizer.state == .began {
            startCenter = drawView.center
        }
        if recognizer.state != .cancelled {
            drawView.center = CGPoint(x: startCenter.x + translation.x, y: startCenter.y + translation.y)
        }
    }
        
    // MARK: - Long Press for inser photos
    @objc func drawViewLongPress(byHandlingGestureRecognizedBy recognizer: UILongPressGestureRecognizer) {
        print("long press")
        if (UIMenuController.shared.isMenuVisible) {
            UIMenuController.shared.hideMenu(from: drawView)
        }
        
        let point = recognizer.location(in: drawView)
        // menu
        let menu = UIMenuController.shared
        drawView.becomeFirstResponder()
        let targetRect: CGRect
        // index of photo
        let closePhotoKey: String? = indexOfPhoto(at: point)
        let closeTextViewKey: String? = indexOfTextView(at: point)
        
        if closePhotoKey != nil {
            photoKeyForDelete = closePhotoKey
            var photoPoint = drawView.image.getImageAndPosition(forKey: closePhotoKey!).1!
            let widthAndHeight = drawView.image.getWidthAndHeightForImage(withKey: closePhotoKey!)
            photoPoint.x = photoPoint.x + widthAndHeight!.width / 2
            photoPoint.y = photoPoint.y + widthAndHeight!.height / 2
            let closePhotoItemForDelete = UIMenuItem(title: "Delete", action: #selector(deletePhoto))
            let closePhotoItemForPan = UIMenuItem(title: "Pan", action: #selector(panPhoto))
            let closePhotoItemForPinch = UIMenuItem(title: "Pinch", action: #selector(pinchPhoto))
            menu.menuItems = [closePhotoItemForDelete, closePhotoItemForPan, closePhotoItemForPinch]
            targetRect = CGRect(x: photoPoint.x, y: photoPoint.y, width: 2, height: 2)
        } else if closeTextViewKey != nil {
            textViewKeyClose = closeTextViewKey
            var textViewPoint = drawView.textView.getTextAndPosition(forKey: closeTextViewKey!).1!
            textViewPoint.x = textViewPoint.x + drawView.frame.width / 4
            textViewPoint.y = textViewPoint.y + drawView.frame.width / 8
            let closeTextViewItemForDelete = UIMenuItem(title: "Delete", action: #selector(deleteTextView))
            let closeTextViewItemForPan = UIMenuItem(title: "Pan", action: #selector(panTextView))
            menu.menuItems = [closeTextViewItemForDelete, closeTextViewItemForPan]
            targetRect = CGRect(x: textViewPoint.x, y: textViewPoint.y, width: 2, height: 2)
            
        } else {
        // insert a menu and set photo position
            // MARK: get point where photo or textView should show it
            let positionX = min(max(0, point.x - self.width / 4), self.width - self.width / 2)
            let positionY = min(max(0, point.y - self.width / 8), self.height - self.width / 4)
            drawView.imagePoint = CGPoint(x: positionX, y: positionY)
            drawView.textViewPoint = CGPoint(x: positionX, y: positionY)
            
            // MARK: get menu and set it items
            
            let photoItem = UIMenuItem(title: "Photo", action: #selector(selectPhotoFromPhotoLibrary))
            
            menu.menuItems = [photoItem]
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                menu.menuItems?.append(UIMenuItem(title: "Camera", action: #selector(selectPhotoFromCamera)))
            }
            let textItem = UIMenuItem(title: "Text", action: #selector(addTextView))
            menu.menuItems?.append(textItem)
            // MARK: given point where menu should be show
            targetRect = CGRect(x: point.x, y: point.y, width: 2, height: 2)
        }
        menu.showMenu(from: drawView, rect: targetRect)
        drawView.setNeedsDisplay()
    }
    
    @objc func selectPhotoFromPhotoLibrary(_ sender: UIMenuController) {
        // MARK: - get imagePicker to select Photo
        let imagePicker = UIImagePickerController()
            imagePicker.sourceType = .photoLibrary
        imagePicker.delegate = self
        present(imagePicker, animated: true, completion: nil)
    }
    
    @objc func selectPhotoFromCamera(_ sender: UIMenuController) {
        // MARK: - get imagePicker to select Photo
        let imagePicker = UIImagePickerController()
            imagePicker.sourceType = .camera
        imagePicker.delegate = self
        present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
        let imageKey = "\(String(describing: drawView.itemKey)) - \(Date())"
        let widthAndHeight = CGSize(width: drawView.width / 2, height: drawView.width / 4)
        drawView.image.setImage(image, forKey: imageKey, in: drawView.imagePoint, with: widthAndHeight)
        
        //MARK: get image view for show image
        let frameRect = CGRect(x: drawView.imagePoint.x,
                               y: drawView.imagePoint.y,
                               width: self.width / 2,
                               height: self.width / 4)
        let imageView: UIImageView = UIImageView(frame: frameRect)
//        imageView.backgroundColor = .orange
        // MARK: set image mode
        imageView.contentMode = .scaleAspectFit
        // MARK: add image in image view
        imageView.image = image
        imageView.accessibilityIdentifier = imageKey
        // MARK: add image view in draw view
        drawView.addSubview(imageView)
        
        dismiss(animated: true, completion: nil)

        print("picture")
    }
    
    @objc func addTextView(_ sender: UIMenuController) {
        
        let textViewKey = "\(String(describing: drawView.itemKey)) - \(Date())"
        let widthAndHeight = CGSize(width: drawView.width / 2, height: drawView.width / 4)
        drawView.textView.setText(forKey: textViewKey, in: drawView.textViewPoint, with: widthAndHeight)
        
        
        let frameRect = CGRect(x: drawView.textViewPoint.x,
                               y: drawView.textViewPoint.y,
                               width: self.width / 2,
                               height: self.width / 4)
        let textView: UITextView = UITextView(frame: frameRect)
        textView.layer.borderWidth = 1
        textView.layer.borderColor = UIColor.gray.cgColor
        textView.textColor = .black
        textView.backgroundColor = .none
                
        textView.accessibilityIdentifier = textViewKey
        
        textView.delegate = drawView
        
        drawView.addSubview(textView)
        
        print("textView")
    }
    
//    func textViewDidChange(_ textView: UITextView) {
//        print("text view did change")
//
//        saveNewText(to: textView)
//    }
//
//    func textViewDidEndEditing(_ textView: UITextView) {
//        print("text view did end editing")
//
//        saveNewText(to: textView)
//    }
//
//    func saveNewText(to textView: UITextView) {
//        let textViewKey = textView.accessibilityIdentifier
//        let newText = textView.text
//        drawView.textView.setText(forKey: textViewKey!, with: newText!)
//    }
    
    func indexOfPhoto(at point: CGPoint) -> String? {
        // Find a photo close to point
        for key in drawView.image.keyStore {
            let (_, position) = drawView.image.getImageAndPosition(forKey: key)
            let widthAndHeight = drawView.image.getWidthAndHeightForImage(withKey: key)
            if hypot(position!.x + widthAndHeight!.width / 2 - point.x, position!.y + widthAndHeight!.height / 2 - point.y) < 70 {
                return key
            }
        }
        
        // If nothing is close enough to the tapped point, then we did not select a photo
        return nil
    }
    
    func indexOfTextView(at point: CGPoint) -> String? {
        for key in drawView.textView.textKeyStore {
            let (_, position) = drawView.textView.getTextAndPosition(forKey: key)
            if hypot(position!.x - point.x, position!.y - point.y) < 100 {
                return key
            }
        }
        
        return nil
    }
    
    @objc func deletePhoto() {
        print("delete photo")
        drawView.image.deleteImage(forKey: photoKeyForDelete!)
        
        for subview in drawView.subviews {
            if subview.accessibilityIdentifier == photoKeyForDelete! {
                subview.removeFromSuperview()
                photoKeyForDelete = nil
                print("done delete photo")
            }
        }
        drawView.setNeedsDisplay()
    }
    
    @objc func panPhoto() {
        for subview in drawView.subviews {
            if subview.accessibilityIdentifier == photoKeyForDelete! {
                let panSubview = UIPanGestureRecognizer(target: self, action: #selector(photoPan))
                panSubview.minimumNumberOfTouches = 1
                panSubview.maximumNumberOfTouches = 1
                subview.isUserInteractionEnabled = true
                subview.isMultipleTouchEnabled = true
                subview.addGestureRecognizer(panSubview)
                print("pan photo")
            }
        }
    }
    
    var photoStartCenter: CGPoint = .zero
    @objc func photoPan(byHandlingGestureRecognizedBy recognizer: UIPanGestureRecognizer) {
        guard photoKeyForDelete != nil else {
            print("photoKeyForDelete is nil")
            return
        }
        
        // TODO: - not on photo
//        let point = recognizer.location(in: drawView)
        
        let translation = recognizer.translation(in: drawView)
        
        for subview in drawView.subviews {
            if subview.accessibilityIdentifier == photoKeyForDelete! {
                if recognizer.state == .began {
                    photoStartCenter = subview.center
                }
                if recognizer.state != .cancelled {
                    subview.center = CGPoint(x: photoStartCenter.x + translation.x, y: photoStartCenter.y + translation.y)
                }
                if recognizer.state == .ended {
                    drawView.image.panPhoto(forKey: photoKeyForDelete!, with: translation)
                }
            }
        }
        print("pan on photo")
    }
    
    @objc func pinchPhoto() {
        for subview in drawView.subviews {
            if subview.accessibilityIdentifier == photoKeyForDelete! {
                let pinchSubview = UIPinchGestureRecognizer(target: self, action: #selector(photoPinch))
                subview.isUserInteractionEnabled = true
                subview.isMultipleTouchEnabled = true
                subview.addGestureRecognizer(pinchSubview)
                print("pinch")
            }
        }
    }
    
    @objc func photoPinch(byHandlingGestureRecognizedBy recognizer: UIPinchGestureRecognizer) {
        guard photoKeyForDelete != nil else {
            print("photoKeyForDelete is nil")
            return
        }
        
        // TODO: - not on photo
        
        for subview in drawView.subviews {
            if subview.accessibilityIdentifier == photoKeyForDelete! {
                switch recognizer.state {
                case .changed, .ended:
                    subview.transform = subview.transform.scaledBy(x: recognizer.scale, y: recognizer.scale)
                    recognizer.scale = 1.0
                   
                    let newSize = subview.frame.size
                    drawView.image.pinchPhoto(forKey: photoKeyForDelete!, with: newSize)
                    print("pinch")
                    
                default:
                    break
                }
            }
        }
    }
    
    @objc func deleteTextView() {
        print("delete text view")
        drawView.textView.deleteTextView(forKey: textViewKeyClose!)
        
        for subview in drawView.subviews {
            if subview.accessibilityIdentifier == textViewKeyClose! {
                subview.removeFromSuperview()
                textViewKeyClose = nil
                print("done delete text view")
            }
        }
        drawView.setNeedsDisplay()
    }
    
    @objc func panTextView() {
        for subview in drawView.subviews {
            if subview.accessibilityIdentifier == textViewKeyClose! {
                let panSubview = UIPanGestureRecognizer(target: self, action: #selector(textViewPan))
                panSubview.minimumNumberOfTouches = 1
                panSubview.maximumNumberOfTouches = 1
                subview.isUserInteractionEnabled = true
                subview.isMultipleTouchEnabled = true
                subview.addGestureRecognizer(panSubview)
                print("pan text view")
            }
        }
    }
    
    var textViewStartCenter: CGPoint = .zero
    @objc func textViewPan(byHandlingGestureRecognizedBy recognizer: UIPanGestureRecognizer) {
        guard textViewKeyClose != nil else {
            print("textViewKey is nil")
            return
        }
        
        // TODO: - not on photo
        // let point = recognizer.location(in: drawView)
        
        
        let translation = recognizer.translation(in: drawView)
        for subview in drawView.subviews {
            if subview.accessibilityIdentifier == textViewKeyClose! {
                if recognizer.state == .began {
                    textViewStartCenter = subview.center
                }
                if recognizer.state != .cancelled {
                    subview.center = CGPoint(x: textViewStartCenter.x + translation.x, y: textViewStartCenter.y + translation.y)
                }
                if recognizer.state == .ended {
                    drawView.textView.panTextView(forKey: textViewKeyClose!, with: translation)
                }
            }
        }
        print("pan on text view")
        
    }
    
    lazy var width = drawView.frame.width
    lazy var height = drawView.frame.height
    
    //MARK: - withdraw
    @IBOutlet weak var withdrawButtonOutlet: UIBarButtonItem!
    @IBAction func withdrawButton(_ sender: UIBarButtonItem) {
        guard !drawView.allLineWithStyle.finishedLines.isEmpty else { return }
        
        let withdrawLine = drawView.allLineWithStyle.finishedLines.removeLast()
        drawView.withdrawLine.append(withdrawLine)
        
        let indexOfLineType = Int(withdrawLine.lineType!)!
        drawView.lineStoreKit[indexOfLineType].finishedLines.removeLast()
        
        if !unWithdrawButtonOutlet.isEnabled {
            unWithdrawButtonOutlet.isEnabled = true
        }
        
        drawView.setNeedsDisplay()
    }
    
    //MARK: - unWithdraw
    @IBOutlet weak var unWithdrawButtonOutlet: UIBarButtonItem!
    @IBAction func unWithdraw(_ sender: UIBarButtonItem) {
        if !drawView.withdrawLine.isEmpty {
            let unWithdrawLine = drawView.withdrawLine.removeLast()
            let indexOfLineType = Int(unWithdrawLine.lineType!)!
            drawView.allLineWithStyle.finishedLines.append(unWithdrawLine)
            drawView.lineStoreKit[indexOfLineType].finishedLines.append(unWithdrawLine)
            
            drawView.setNeedsDisplay()
        }
        
        if drawView.withdrawLine.isEmpty {
            unWithdrawButtonOutlet.isEnabled = false
        }
    }
    
    @IBAction func capture(_ sender: UIBarButtonItem){
        
        var captureImage: UIImage? = nil
        
        UIGraphicsBeginImageContext(drawView.bounds.size)
        
        let savedFrame = drawView.frame
        
        scrollViewOutlet.frame = CGRect(x: 0, y: 0, width: width, height: height)
        UIGraphicsBeginImageContextWithOptions(CGSize(width: drawView.frame.width, height: drawView.frame.height), false, 0.0)
        drawView.layer.render(in: UIGraphicsGetCurrentContext()!)
        captureImage = UIGraphicsGetImageFromCurrentImageContext()
        
        drawView.frame = savedFrame
        
        UIGraphicsEndImageContext()
        
        if captureImage != nil {
            UIImageWriteToSavedPhotosAlbum(captureImage!, nil, nil, nil)
            
            let alert = UIAlertController.init(title: "Photo", message: "photo", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        
//        var captureImage: UIImage? = nil
//
//        UIGraphicsBeginImageContext(scrollViewOutlet.contentSize)
//        do {
//            let savedContentOffset = scrollViewOutlet.contentOffset
//            let savedFrame = scrollViewOutlet.frame
//
//            scrollViewOutlet.contentOffset = .zero
//            scrollViewOutlet.frame = CGRect(x: 0, y: 0,
//                                            width: scrollViewOutlet.contentSize.width,
//                                            height: scrollViewOutlet.contentSize.height)
//            UIGraphicsBeginImageContextWithOptions(CGSize(
//                width: scrollViewOutlet.contentSize.width,
//                height: scrollViewOutlet.contentSize.height), false, 0.0)
//
//            scrollViewOutlet.layer.render(in: UIGraphicsGetCurrentContext()!)
//            captureImage = UIGraphicsGetImageFromCurrentImageContext()
//
//            scrollViewOutlet.contentOffset = savedContentOffset
//            scrollViewOutlet.frame = savedFrame
//        }
//        UIGraphicsEndImageContext()
//
//        if captureImage != nil {
//            UIImageWriteToSavedPhotosAlbum(captureImage!, nil, nil, nil)
//        }

    }
}
