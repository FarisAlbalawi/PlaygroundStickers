//
//  EditorView.swift
//  PlaygroundStickers
//
//  Created by Faris Albalawi on 8/9/19.
//  Copyright © 2019 Faris Albalawi. All rights reserved.
//

import Foundation
import UIKit
import CoreImage



protocol rotateViewDelegate {
    func rotateChanged(value: CGFloat)
}


class EditorView: UIViewController {

    
    var photoGallery: PhotoGallery!
    var shapes: shapeView!
    var sliderColorVC: UISliderColorVC!
    var Emojis : EmojisVC!
    
    
    var rotateViewDelegate : rotateViewDelegate?


    
    let deleteView : UIView = {
        let deleteView = UIView()
        deleteView.backgroundColor = UIColor.red
        deleteView.alpha = 0.5
        deleteView.translatesAutoresizingMaskIntoConstraints = false
        deleteView.layer.cornerRadius = 50 / 2
        deleteView.layer.borderWidth = 1.0
        deleteView.layer.borderColor = UIColor.white.cgColor
        deleteView.clipsToBounds = true
        let icons = UIImageView()
        icons.frame.size = CGSize(width: 30, height: 30)
        icons.image = UIImage(named: "delete")
        icons.contentMode = .scaleAspectFit
        deleteView.addSubview(icons)
        icons.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            icons.heightAnchor.constraint(equalToConstant: 25),
            icons.widthAnchor.constraint(equalToConstant: 25),
            icons.centerXAnchor.constraint(equalTo: deleteView.centerXAnchor),
            icons.centerYAnchor.constraint(equalTo: deleteView.centerYAnchor)
            ])
        
        return deleteView
    }()
    
    let TopView: UIView = {
        let TopView = UIView()
        TopView.translatesAutoresizingMaskIntoConstraints = false
        TopView.backgroundColor = barColor
        
        let cancelButton = UIButton()
        cancelButton.setTitle("Cancel", for: .normal)
        cancelButton.setTitleColor(.white, for: .normal)
      //  cancelButton.backgroundColor = redColor
        cancelButton.layer.cornerRadius = 28 / 2
        cancelButton.addTarget(self, action: #selector(EditorView.didPressCancel), for: UIControl.Event.touchUpInside)
        cancelButton.translatesAutoresizingMaskIntoConstraints = false
        TopView.addSubview(cancelButton)
        
        let ExportButton = UIButton()
        ExportButton.setTitle("Export", for: .normal)
        ExportButton.setTitleColor(.white, for: .normal)
      //  ExportButton.backgroundColor = blueColor
        ExportButton.layer.cornerRadius = 28 / 2
        ExportButton.addTarget(self, action: #selector(EditorView.didPressExport), for: UIControl.Event.touchUpInside)
        ExportButton.translatesAutoresizingMaskIntoConstraints = false
        TopView.addSubview(ExportButton)
        
         let Titlelab = UILabel()
        Titlelab.font = UIFont.systemFont(ofSize: 20, weight: UIFont.Weight.heavy)
        Titlelab.text = "Editor"
        Titlelab.textColor = ButtonColor
        Titlelab.translatesAutoresizingMaskIntoConstraints = false
        TopView.addSubview(Titlelab)
        
        
        NSLayoutConstraint.activate([
            cancelButton.heightAnchor.constraint(equalToConstant: 28),
            cancelButton.widthAnchor.constraint(equalToConstant: 75),
            cancelButton.centerYAnchor.constraint(equalTo: TopView.centerYAnchor),
            cancelButton.leftAnchor.constraint(equalTo: TopView.leftAnchor, constant: 10),
            
            ExportButton.heightAnchor.constraint(equalToConstant: 28),
            ExportButton.widthAnchor.constraint(equalToConstant: 75),
            ExportButton.centerYAnchor.constraint(equalTo: TopView.centerYAnchor),
            ExportButton.rightAnchor.constraint(equalTo: TopView.rightAnchor, constant: -10),
            
            Titlelab.centerYAnchor.constraint(equalTo: TopView.centerYAnchor),
            Titlelab.centerXAnchor.constraint(equalTo: TopView.centerXAnchor),
            
            ])
   
        
        
        return TopView
    }()
    
    let BottomView: BottomToolView = {
        let BottomView = BottomToolView()
        BottomView.translatesAutoresizingMaskIntoConstraints = false
        BottomView.backgroundColor = barColor
        return BottomView
    }()
    
    
    let ColorViews: ColorView = {
        let ColorViews = ColorView()
        ColorViews.translatesAutoresizingMaskIntoConstraints = false
        ColorViews.backgroundColor = topColor
        return ColorViews
    }()
    
   
    let LayersViews: LayersView = {
        let ColorView = LayersView()
        ColorView.translatesAutoresizingMaskIntoConstraints = false
        ColorView.backgroundColor = barColor
        return ColorView
    }()
    
    
    let shapeTools: ShapeTools = {
        let shapeTools = ShapeTools()
        shapeTools.translatesAutoresizingMaskIntoConstraints = false
        shapeTools.backgroundColor = barColor
        return shapeTools
    }()
    
    let TextTools: TextTool = {
        let TextTools = TextTool()
        TextTools.translatesAutoresizingMaskIntoConstraints = false
        TextTools.backgroundColor = barColor
        return TextTools
    }()
   
    let textBackgroundTools: textBackgroundTool = {
        let textBackgroundTools = textBackgroundTool()
        textBackgroundTools.translatesAutoresizingMaskIntoConstraints = false
        textBackgroundTools.backgroundColor = barColor
        return textBackgroundTools
    }()
    
    let cornerRadiusTools: cornerRadiusTool = {
        let cornerRadiusTools = cornerRadiusTool()
        cornerRadiusTools.translatesAutoresizingMaskIntoConstraints = false
        cornerRadiusTools.backgroundColor = barColor
        return cornerRadiusTools
    }()
    
    
    
    
    let imageTool: imageTools = {
        let imageTool = imageTools()
        imageTool.translatesAutoresizingMaskIntoConstraints = false
        imageTool.backgroundColor = barColor
        return imageTool
    }()
  
    let FontViews: FontView = {
        let FontViews = FontView()
        FontViews.translatesAutoresizingMaskIntoConstraints = false
        FontViews.backgroundColor = barColor
        return FontViews
    }()
    
    let scaleViews: scaleView = {
        let scaleViews = scaleView()
        scaleViews.translatesAutoresizingMaskIntoConstraints = false
        scaleViews.backgroundColor = barColor
        return scaleViews
    }()
    
    
    let FiltersView: FiltersMenuView = {
        let FiltersView = FiltersMenuView()
        FiltersView.translatesAutoresizingMaskIntoConstraints = false
        FiltersView.backgroundColor = topColor
        return FiltersView
    }()
    
    let MaskViews: MaskView = {
        let MaskViews = MaskView()
        MaskViews.translatesAutoresizingMaskIntoConstraints = false
        MaskViews.backgroundColor = topColor
        return MaskViews
    }()
    
    
  
    
    let CanvasView: UIView = {
        let CanvasView = UIView()
        CanvasView.translatesAutoresizingMaskIntoConstraints = false
        CanvasView.backgroundColor = UIColor.clear
        CanvasView.isOpaque = false
        
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.backgroundColor = .clear
        imageView.image = UIImage(named: "Screen")
        
        CanvasView.addSubview(imageView)
        
        
        NSLayoutConstraint.activate([
            // tempImageView layout
            imageView.leadingAnchor.constraint(equalTo: CanvasView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: CanvasView.trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: CanvasView.bottomAnchor),
            imageView.topAnchor.constraint(equalTo: CanvasView.topAnchor),
            
            ])
        
        
        return CanvasView
    }()
    
    
    let tempImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.backgroundColor = .clear
        return imageView
    }()
    
    
    let LineX: UIView = {
        let LineX = UIView()
        LineX.translatesAutoresizingMaskIntoConstraints = false
        LineX.backgroundColor = yellowColor
        return LineX
    }()
    
    
    let LineY: UIView = {
        let LineY = UIView()
        LineY.translatesAutoresizingMaskIntoConstraints = false
        LineY.backgroundColor = yellowColor
        return LineY
    }()
    
    let opacityViews: opacityView = {
        let opacityViews = opacityView()
        opacityViews.translatesAutoresizingMaskIntoConstraints = false
        opacityViews.backgroundColor = topColor
        return opacityViews
    }()
    
    
    let TextBackgroundViews: TextBackgroundView = {
        let TextBackgroundViews = TextBackgroundView()
        TextBackgroundViews.translatesAutoresizingMaskIntoConstraints = false
        TextBackgroundViews.backgroundColor = topColor
        return TextBackgroundViews
    }()
    
    let cornerRadiusViews: cornerRadiusView = {
        let cornerRadiusViews = cornerRadiusView()
        cornerRadiusViews.translatesAutoresizingMaskIntoConstraints = false
        cornerRadiusViews.backgroundColor = topColor
        return cornerRadiusViews
    }()
    
    
    
    
    
    let shadowViews: shadowView = {
        let shadowViews = shadowView()
        shadowViews.translatesAutoresizingMaskIntoConstraints = false
        shadowViews.backgroundColor = topColor
        return shadowViews
    }()
    
    let rotateViews: RotationDial = {
        let rotateViews = RotationDial()
        rotateViews.translatesAutoresizingMaskIntoConstraints = false
        return rotateViews
    }()
    
    let positionsView: changePositionsView = {
        let positionsView = changePositionsView()
        positionsView.translatesAutoresizingMaskIntoConstraints = false
        positionsView.backgroundColor = topColor
        return positionsView
    }()
    
    
    
    let shadowTool: shadowTools = {
        let shadowTool = shadowTools()
        shadowTool.translatesAutoresizingMaskIntoConstraints = false
        shadowTool.backgroundColor = topColor
        return shadowTool
    }()
    
    
    
    

   
    
     let DoneButton: UIButton = {
        let DoneButton = UIButton()
        DoneButton.setTitle("Done", for: .normal)
        DoneButton.setTitleColor(.white, for: .normal)
        DoneButton.backgroundColor = blueColor
        DoneButton.layer.cornerRadius = 28 / 2
        DoneButton.addTarget(self, action: #selector(EditorView.didPressDone), for: UIControl.Event.touchUpInside)
        DoneButton.translatesAutoresizingMaskIntoConstraints = false
        
        return DoneButton
    }()
    
    
    
    let EdeiterView: UIView = {
        let EdeiterView = UIView()
        EdeiterView.translatesAutoresizingMaskIntoConstraints = false
        EdeiterView.backgroundColor = topColor
        return EdeiterView
    }()
    
    let TextAlignmenViews: TextAlignmenView = {
        let TextAlignmenViews = TextAlignmenView()
        TextAlignmenViews.translatesAutoresizingMaskIntoConstraints = false
        TextAlignmenViews.backgroundColor = topColor
        return TextAlignmenViews
    }()
    
    
    
    
    var LayersViewHeight = NSLayoutConstraint()
    var EdeiterViewHeight = NSLayoutConstraint()
    var shadowViewsHeight = NSLayoutConstraint()
    var ColorViewsBottomAnchor =  NSLayoutConstraint()
    
    var originalImage = UIImage()
 
    var lastRotation   = CGFloat()
    
    var colorForType: Int?
    
    
    var TextBackgroundColor: Bool?
    
    var lastPanPoint: CGPoint?
    var imageViewToPan: UIImageView?
    var activeImage: UIImageView?
    var bottomSheetIsVisible = false
    var lastColors: UIColor?
    
    var lastTextViewTransform: CGAffineTransform?
    var lastTextViewTransCenter: CGPoint?
    var lastTextViewFont:UIFont?
    var activeTextView: UITextView?
    var activeView: UIView?
    var textIndex: Int?
    var lastView: UIView?
    
    var orientation: Config.Orientation = .normal
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

       
        view.backgroundColor = barColor
        
        
        // call func
        self.layout()
        
    
        
        BottomView.BottomToolDelegate = self
        ColorViews.colorDelegate = self
        LayersViews.LayersViewDelegate = self
        shapeTools.shapeToolDelegate = self
        opacityViews.opacityViewDelegate = self
        self.rotateViewDelegate = self
        imageTool.Delegate = self
        FiltersView.Delegate = self
        positionsView.Delegate = self
        TextTools.Delegate = self
        FontViews.Delegate = self
        TextAlignmenViews.Delegate = self
        shadowViews.Delegate = self
        MaskViews.Delegate = self
        shadowTool.Delegate = self
        textBackgroundTools.Delegate = self
        TextBackgroundViews.Delegate = self
        cornerRadiusTools.Delegate = self
        cornerRadiusViews.Delegate = self
        scaleViews.Delegate = self
  
        rotateViews.setup()
        rotateViews.didRotate = {[weak self] angle in
            guard let self = self else { return }
            self.rotateViewDelegate?.rotateChanged(value: angle.degrees)
        }
        
        
   
     
        
        let edgePan = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(screenEdgeSwiped))
        edgePan.edges = .bottom
        edgePan.delegate = self
        self.view.addGestureRecognizer(edgePan)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillShow),
                                               name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillHide),
                                               name: UIResponder.keyboardWillHideNotification, object: nil)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillChangeFrame),
                                               name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        
       
        let pinchGesture = UIPinchGestureRecognizer(target: self,
                                                    action: #selector(EditorView.tempImageViewGesture))
        tempImageView.addGestureRecognizer(pinchGesture)
        
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        var config = Config()
        config.angleShowLimitType = .limit(angle: CGAngle(degrees: 60))
        
        config.numberShowSpan = 2
        config.centerAxisColor = yellowColor
        config.bigScaleColor = yellowColor
        config.smallScaleColor = yellowColor
        config.indicatorColor = blueColor
        config.numberColor = blueColor
        config.backgroundColor = topColor
        
        
        if orientation == .normal {
            config.orientation = .normal
        }
        
        orientation = config.orientation
        rotateViews.setup(with: config)
    }
    
    @objc func tempImageViewGesture(_ recognizer: UIPinchGestureRecognizer) {
        if lastView != nil {
            
            
            let maxScale : CGFloat  = 2.0;
            let minScale : CGFloat  = 0.1;
            
            let currentScale = view.frame.width/view.bounds.size.width
            var newScale = recognizer.scale
            if currentScale * recognizer.scale < minScale {
                newScale = minScale / currentScale
            } else if currentScale * recognizer.scale > maxScale {
                newScale = maxScale / currentScale
            }
            
            if lastView is UITextView {
                
                if let textView = lastView as? UITextView {
                    
                    textView.isScrollEnabled = true
                    
                    let font = UIFont(name: textView.font!.fontName, size: textView.font!.pointSize * newScale)
                    textView.font = font
                    
                    let sizeToFit = textView.sizeThatFits(CGSize(width: UIScreen.main.bounds.size.width,
                                                                 height:CGFloat.greatestFiniteMagnitude))
                    
                    textView.bounds.size = CGSize(width: sizeToFit.width,
                                                  height: sizeToFit.height)
                    
                    textView.setNeedsDisplay()
                    textView.isScrollEnabled = false
                    
                }
             
            } else {
                
                lastView?.transform = (lastView?.transform.scaledBy(x: newScale, y: newScale))!
        
            }
            recognizer.scale = 1
        }
        
        
    }
    
    
    // Cancel Button
    @objc func didPressCancel() {
        print("Cancel")
    }
    
    // for export the image
    @objc func didPressExport() {
//        let image = tempImageView.asImage()
//        UIImageWriteToSavedPhotosAlbum(pngFrom(image: image),self, #selector(EditorView.Saveimage(_:withPotentialError:contextInfo:)), nil)
    }
    
    
    @objc func keyboardWillShow(notification: NSNotification) {
       
        lastView = nil
        DoneButton.isHidden = false
        hideToolbar(hide: true)
      
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        
        DoneButton.isHidden = true
        hideToolbar(hide: false)
        self.tempImageView.isUserInteractionEnabled = true
        
    }
    
    @objc func keyboardWillChangeFrame(_ notification: NSNotification) {
        
    }
    
    
    @objc func didPressDone() {
        view.endEditing(true)
        hideToolbar(hide: false)
        self.lastView = nil
        self.TextBackgroundColor = nil
        self.colorForType = nil
        self.activeView = nil
        self.activeImage = nil
        
        self.EdeiterViewHeight.constant = 0
        self.tempImageView.isUserInteractionEnabled = true
        self.DoneButton.isHidden = true
        self.shapeTools.isHidden = true
        self.rotateViews.isHidden = true
        self.opacityViews.isHidden = true
        self.ColorViews.isHidden = true
        self.FiltersView.isHidden = true
        self.imageTool.isHidden = true
        self.TextTools.isHidden = true
        self.FontViews.isHidden = true
        self.MaskViews.isHidden = true
        self.TextAlignmenViews.isHidden = true
        self.shadowTool.isHidden = true
        self.shadowViews.isHidden = true
        self.positionsView.isHidden = true
        
        self.textBackgroundTools.isHidden = true
        self.TextBackgroundViews.isHidden = true
        self.cornerRadiusTools.isHidden = true
        self.cornerRadiusViews.isHidden = true
        self.ColorViews.collectionView.reloadData()
        self.shapeTools.collectionView.reloadData()
        self.imageTool.collectionView.reloadData()
        self.TextTools.collectionView.reloadData()
        self.shadowTool.collectionView.reloadData()
        self.MaskViews.collectionView.reloadData()
        self.ColorViews.collectionView.reloadData()
        self.FontViews.collectionView.reloadData()
        self.FiltersView.collectionView.reloadData()
        self.textBackgroundTools.collectionView.reloadData()
        
        
        if #available(iOS 10.0, *) {
            let generator = UIImpactFeedbackGenerator(style: .heavy)
            generator.impactOccurred()
        }
        
        UIView.animate(withDuration: 0.2, animations: {
            self.view.layoutIfNeeded()
        }, completion: {finished in })
        
    }
    
    
    
    func hideToolbar(hide: Bool) {
        self.LayersViewHeight.constant = 35
        if hide == true {
            self.LayersViews.HideButton.isEnabled = false
            self.LayersViews.isHiddenOrShowing = true
            self.LayersViews.HideButton.setTitle("▼ Hide Layers", for: .normal)
            self.LayersViews.collectionView.reloadData()
        } else {
            self.LayersViews.isHiddenOrShowing = false
            self.LayersViews.HideButton.setTitle("▲ Show Layers", for: .normal)
            self.LayersViews.HideButton.isEnabled = true
            self.LayersViews.collectionView.reloadData()
        }
      
        
        UIView.animate(withDuration: 0.5, animations: {
            self.view.layoutIfNeeded()
        }, completion: {finished in })
        
        
       // self.LayersViews.isHidden = hide
        self.BottomView.isHidden = hide
        self.TopView.isHidden = hide
      
        
        
      
    }
    
    func viewSlideInFromTopToBottom(view: UIView) -> Void {
        let transition:CATransition = CATransition()
        transition.duration = 0.5
        transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        transition.type = CATransitionType.push
        transition.subtype = CATransitionSubtype.fromBottom
        view.layer.add(transition, forKey: kCATransition)
    }
    
    func textEditor(text: UITextView) {
        self.DoneButton.isHidden = false
        hideToolbar(hide: true)
        
        activeTextView = text
        self.tempImageView.isUserInteractionEnabled = false
        TextTools.isHidden = false
        self.DoneButton.isHidden = false
    }
    
    func editorType(tag: Int, Image: UIImageView) {
        self.tempImageView.isUserInteractionEnabled = false
        self.DoneButton.isHidden = false
        hideToolbar(hide: true)
        
        if tag == 0 {
            self.activeImage = Image
            self.imageTool.isHidden = false
            self.originalImage = Image.image!
            self.FiltersView.imageToBeEdited = Image
            self.FiltersView.collectionView.reloadData()
            self.TextTools.isHidden = true
            self.shapeTools.isHidden = true
            
        } else if tag == 1 {
            self.activeImage = Image
            self.shapeTools.isHidden = false
            self.FiltersView.isHidden = true
            self.imageTool.isHidden = true
            self.TextTools.isHidden = true
        } else if tag == 3 {
          
        }
    
        UIView.animate(withDuration: 2, animations: {
            self.view.layoutIfNeeded()
        }, completion: {finished in })
        
        
    }
 
}


extension EditorView: TextAlignmenDelegate, shadowViewDelegate,
shadowToolsDelegate, textBackgroundToolDelegate, TextBackgroundViewDelegate, cornerRadiusToolDelegate, cornerRadiusViewDelegate {
    
    func borderWidthChanged(value: Float) {
        if activeTextView != nil {
            activeTextView!.layer.borderWidth = CGFloat(value)
        }
    }
    
    func cornerAngularChanged(value: Float) {
        if activeTextView != nil {
            activeTextView?.layer.cornerRadius = CGFloat(value)
            activeTextView?.clipsToBounds = false
        }
    }
    
    
    func cornerRadiusToolTapped(Index: Int) {
        if Index == 0 {
            if activeTextView != nil {
                 activeTextView!.layer.borderWidth = 0
            }
            self.EdeiterViewHeight.constant = cornerRadiusTools.frame.height
            self.cornerRadiusViews.isHidden = true
            self.ColorViews.isHidden = true
            self.ColorViewsBottomAnchor.constant = 0
            
        } else if Index == 1 {
            
          //  cornerRadiusTypes
            self.EdeiterViewHeight.constant = 0
            self.ColorViews.isHidden = true
            self.cornerRadiusViews.isHidden = false
            self.cornerRadiusViews.cornerRadiusTypes(.BorderWidth)
            self.ColorViewsBottomAnchor.constant = 0
            self.EdeiterViewHeight.constant = textBackgroundTools.frame.height + cornerRadiusViews.frame.height
            
            
        } else if Index == 2 {
            
            self.EdeiterViewHeight.constant = 0
            self.ColorViews.isHidden = true
            self.cornerRadiusViews.isHidden = false
            self.cornerRadiusViews.cornerRadiusTypes(.angular)
            self.ColorViewsBottomAnchor.constant = 0
            self.EdeiterViewHeight.constant = cornerRadiusTools.frame.height + cornerRadiusViews.frame.height
            
        } else if Index == 3 {
            
            self.EdeiterViewHeight.constant = cornerRadiusTools.frame.height + ColorViews.frame.height
            self.ColorViews.isHidden = false
            self.cornerRadiusViews.isHidden = true
            self.ColorViewsBottomAnchor.constant = -70
            self.colorForType = 3
            
        }
        
        UIView.animate(withDuration: 0.2, animations: {
            self.view.layoutIfNeeded()
        }, completion: {finished in })
        
    }
    
    
    
    
    func TextOpacityChanged(value: Float) {
        let color = self.lastColors
        if activeTextView != nil {
            if lastColors != nil {
                activeTextView!.layer.backgroundColor = UIColor(red: color!.redValue, green: color!.greenValue, blue: color!.blueValue, alpha: CGFloat(value)).cgColor
            }
        }
    }
    
    
    func TextAngularChanged(value: Float) {
        if activeTextView != nil {
            activeTextView?.layer.cornerRadius = CGFloat(value)
            activeTextView?.clipsToBounds = false
        }
    }
    
    

    func textBackgroundToolsTapped(Index: Int) {
        
        if Index == 0 {
            if activeTextView != nil {
                activeTextView!.layer.backgroundColor = UIColor.clear.cgColor
            }
            self.EdeiterViewHeight.constant = textBackgroundTools.frame.height
            self.TextBackgroundViews.isHidden = true
            self.ColorViews.isHidden = true
            self.ColorViewsBottomAnchor.constant = 0
        } else if Index == 1 {
            
            self.EdeiterViewHeight.constant = textBackgroundTools.frame.height + ColorViews.frame.height
            self.ColorViews.isHidden = false
            self.TextBackgroundViews.isHidden = true
            self.ColorViewsBottomAnchor.constant = -70
            self.colorForType = 2
         
            
        } else if Index == 2 {
            self.EdeiterViewHeight.constant = 0
            self.ColorViews.isHidden = true
            self.TextBackgroundViews.isHidden = false
            self.TextBackgroundViews.shadowTypes(.angular)
            self.ColorViewsBottomAnchor.constant = 0
            self.EdeiterViewHeight.constant = textBackgroundTools.frame.height + TextBackgroundViews.frame.height
            
        } else if Index == 3 {
            self.EdeiterViewHeight.constant = 0
            self.ColorViews.isHidden = true
            self.TextBackgroundViews.isHidden = false
            self.TextBackgroundViews.shadowTypes(.opacity)
            self.ColorViewsBottomAnchor.constant = 0
            self.EdeiterViewHeight.constant = textBackgroundTools.frame.height + TextBackgroundViews.frame.height
            
        }
        
        UIView.animate(withDuration: 0.2, animations: {
            self.view.layoutIfNeeded()
        }, completion: {finished in })
        
        
    }
    
    
    
    
    func shadowToolsTapped(Index: Int) {
        if Index == 0 {
            
            self.EdeiterViewHeight.constant = shadowTool.frame.height
            self.shadowViews.isHidden = true
            self.shadowViewsHeight.constant = 0
            if activeTextView != nil {
                activeTextView?.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
                activeTextView?.layer.shadowOpacity = 1.0
                activeTextView?.layer.shadowRadius = 0.0
            } else if activeView != nil {
                activeView?.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
                activeView?.layer.shadowOpacity = 1.0
                activeView?.layer.shadowRadius = 0.0
            }
            
        } else if Index == 1 {
            self.EdeiterViewHeight.constant = shadowTool.frame.height + 80
            self.shadowViews.isHidden = false
            self.ColorViews.isHidden = true
            self.shadowViewsHeight.constant = 80
            self.shadowViews.shadowTypes(.shadowOffset)
        } else if Index == 2 {
            self.EdeiterViewHeight.constant = shadowTool.frame.height + 55
            self.shadowViews.shadowTypes(.shadowOpacity)
            self.shadowViews.isHidden = false
            self.ColorViews.isHidden = true
            self.shadowViewsHeight.constant = 55
           
        } else if Index == 3 {
              self.EdeiterViewHeight.constant = shadowTool.frame.height + 55
              self.shadowViews.shadowTypes(.shadowRadius)
              self.shadowViews.isHidden = false
              self.ColorViews.isHidden = true
              self.shadowViewsHeight.constant = 55
           
        } else if Index == 4 {
              self.EdeiterViewHeight.constant = shadowTool.frame.height + ColorViews.frame.height
              self.shadowViews.isHidden = true
              self.ColorViews.isHidden = false
              self.shadowViewsHeight.constant = 0
          
        }
        
        UIView.animate(withDuration: 0.2, animations: {
            self.view.layoutIfNeeded()
        }, completion: {finished in })
        
    }
    
    
    func shadow(Width: Float, height: Float, Opacity: Float, Radius: Float) {
        if activeTextView != nil {
            activeTextView?.layer.shadowOffset = CGSize(width: Double(Width), height: Double(height))
            activeTextView!.layer.shadowOpacity = Opacity
            activeTextView!.layer.shadowRadius = CGFloat(Radius)
     
        } else if activeView != nil {
            activeView!.layer.shadowOffset = CGSize(width: Double(Width), height: Double(height))
            activeView!.layer.shadowOpacity = Opacity
            activeView!.layer.shadowRadius = CGFloat(Radius)
     
        }
        
    }
    
  
    
    func AlignmenTapped(index: Int) {
        if index == 0 {
             activeTextView?.textAlignment = .left
        } else if index == 1 {
             activeTextView?.textAlignment = .center
        } else {
             activeTextView?.textAlignment = .right
        }
    }
    
    
}



extension EditorView: TextToolDelegate {
    func TextToolTapped(index: Int) {
        
        self.scaleViews.collectionView.scrollToItem(at:IndexPath(item: 500, section: 0), at: .right, animated: false)
        self.scaleViews.collectionView.layoutIfNeeded()
        
        
        if index == 0 {
            
            self.ColorViewsBottomAnchor.constant = 0
            self.colorForType = 0
            self.EdeiterViewHeight.constant = ColorViews.frame.height
            self.ColorViews.isHidden = false
            self.rotateViews.isHidden = true
            self.positionsView.isHidden = true
            self.FontViews.isHidden = true
            self.TextAlignmenViews.isHidden = true
            self.shadowViews.isHidden = true
            self.shadowTool.isHidden = true
            self.textBackgroundTools.isHidden = true
            self.TextBackgroundViews.isHidden = true
            self.scaleViews.isHidden = true
            
        } else if index == 1 {
            
            self.EdeiterViewHeight.constant = FontViews.frame.height
            self.FontViews.isHidden = false
            self.ColorViews.isHidden = true
            self.rotateViews.isHidden = true
            self.positionsView.isHidden = true
            self.TextAlignmenViews.isHidden = true
            self.shadowViews.isHidden = true
            self.shadowTool.isHidden = true
            self.textBackgroundTools.isHidden = true
            self.cornerRadiusTools.isHidden = true
            self.scaleViews.isHidden = true
             self.TextBackgroundViews.isHidden = true
        } else if index == 2 {
            
            self.EdeiterViewHeight.constant = cornerRadiusTools.frame.height
            self.FontViews.isHidden = true
            self.ColorViews.isHidden = true
            self.rotateViews.isHidden = true
            self.positionsView.isHidden = true
            self.TextAlignmenViews.isHidden = true
            self.shadowViews.isHidden = true
            self.shadowTool.isHidden = true
            self.textBackgroundTools.isHidden = true
            self.cornerRadiusTools.isHidden = false
            self.scaleViews.isHidden = true
             self.TextBackgroundViews.isHidden = true
            
        } else if index == 3 {
            
            self.EdeiterViewHeight.constant = textBackgroundTools.frame.height
            self.FontViews.isHidden = true
            self.ColorViews.isHidden = true
            self.rotateViews.isHidden = true
            self.positionsView.isHidden = true
            self.TextAlignmenViews.isHidden = true
            self.shadowViews.isHidden = true
            self.shadowTool.isHidden = true
            self.textBackgroundTools.isHidden = false
            self.cornerRadiusTools.isHidden = true
            self.scaleViews.isHidden = true
             self.TextBackgroundViews.isHidden = true
        } else if index == 4 {
            
            self.ColorViewsBottomAnchor.constant = -50
            self.colorForType = 1
            self.FontViews.isHidden = true
            self.EdeiterViewHeight.constant = shadowTool.frame.height
            self.ColorViews.isHidden = true
            self.rotateViews.isHidden = true
            self.positionsView.isHidden = true
            self.TextAlignmenViews.isHidden = true
            self.shadowViews.isHidden = true
            self.shadowTool.isHidden = false
            self.textBackgroundTools.isHidden = true
            self.cornerRadiusTools.isHidden = true
            self.cornerRadiusViews.isHidden = true
            self.scaleViews.isHidden = true
             self.TextBackgroundViews.isHidden = true
        } else if index == 5 {
            
            self.EdeiterViewHeight.constant = TextAlignmenViews.frame.height
            self.FontViews.isHidden = true
            self.ColorViews.isHidden = true
            self.rotateViews.isHidden = true
            self.positionsView.isHidden = true
            self.TextAlignmenViews.isHidden = false
            self.shadowViews.isHidden = true
            self.shadowTool.isHidden = true
            self.textBackgroundTools.isHidden = true
            self.cornerRadiusTools.isHidden = true
            self.scaleViews.isHidden = true
            self.TextBackgroundViews.isHidden = true
            self.cornerRadiusViews.isHidden = true
            
        } else if index == 6 {
            
            self.EdeiterViewHeight.constant = rotateViews.frame.height
            self.ColorViews.isHidden = true
            self.rotateViews.isHidden = false
            self.positionsView.isHidden = true
            self.TextAlignmenViews.isHidden = true
            self.shadowViews.isHidden = true
            self.shadowTool.isHidden = true
            self.FontViews.isHidden = true
            self.textBackgroundTools.isHidden = true
            self.cornerRadiusTools.isHidden = true
            self.scaleViews.isHidden = true
            self.TextBackgroundViews.isHidden = true
            self.cornerRadiusViews.isHidden = true
        } else if index == 7 {
            
            self.EdeiterViewHeight.constant = positionsView.frame.height
            self.ColorViews.isHidden = true
            self.rotateViews.isHidden = true
            self.positionsView.isHidden = false
            self.TextAlignmenViews.isHidden = true
            self.shadowViews.isHidden = true
            self.shadowTool.isHidden = true
            self.FontViews.isHidden = true
            self.textBackgroundTools.isHidden = true
            self.cornerRadiusTools.isHidden = true
            self.scaleViews.isHidden = true
            self.TextBackgroundViews.isHidden = true
            self.cornerRadiusViews.isHidden = true
            
        } else if index == 8 {
            
            self.EdeiterViewHeight.constant =  self.scaleViews.frame.height
            self.ColorViews.isHidden = true
            self.rotateViews.isHidden = true
            self.positionsView.isHidden = true
            self.TextAlignmenViews.isHidden = true
            self.shadowViews.isHidden = true
            self.shadowTool.isHidden = true
            self.FontViews.isHidden = true
            self.textBackgroundTools.isHidden = true
            self.cornerRadiusTools.isHidden = true
            self.scaleViews.isHidden = false
           
            self.TextBackgroundViews.isHidden = true
            self.cornerRadiusViews.isHidden = true
        }
     
        UIView.animate(withDuration: 0.2, animations: {
            self.view.layoutIfNeeded()
        }, completion: {finished in })
        
        
    }
    
    
    
}

extension EditorView: PositionsDelegate, scaleViewDelegate {
    
    func scaleChanged(value: Float) {
    
     
        if activeView != nil {
             activeView?.transform = (activeView?.transform.scaledBy(x: CGFloat(value), y: CGFloat(value)))!
        } else if activeTextView != nil {
            activeTextView!.isScrollEnabled = true
            
            let font = UIFont(name: activeTextView!.font!.fontName, size: activeTextView!.font!.pointSize * CGFloat(value))
            activeTextView!.font = font
            
            let sizeToFit = activeTextView!.sizeThatFits(CGSize(width: UIScreen.main.bounds.size.width,
                                                                height:CGFloat.greatestFiniteMagnitude))
            
            activeTextView!.bounds.size = CGSize(width: sizeToFit.width,
                                                 height: sizeToFit.height)
            
            activeTextView!.setNeedsDisplay()
            activeTextView!.isScrollEnabled = false
        }
      
        
       
      
    }
    
    
    
    func ButtonMoved(recognizer: UIPanGestureRecognizer, tag: Int) {
      
        if tag == 0 {
            
            activeView?.center = CGPoint(x: (activeView?.center.x)! + 1 + recognizer.translation(in: tempImageView).x,
                                                y: (activeView?.center.y)! + recognizer.translation(in: tempImageView).y)
            recognizer.setTranslation(CGPoint.zero, in: tempImageView)
            
        } else if tag == 1{
            activeView?.center = CGPoint(x: (activeView?.center.x)! - 1 + recognizer.translation(in: tempImageView).x,
                                                y: (activeView?.center.y)! + recognizer.translation(in: tempImageView).y)
            recognizer.setTranslation(CGPoint.zero, in: tempImageView)
        } else if tag == 2 {
            
            activeView?.center = CGPoint(x: (activeView?.center.x)! + recognizer.translation(in: tempImageView).x,
                                                y: (activeView?.center.y)! - 1 + recognizer.translation(in: tempImageView).y)
            recognizer.setTranslation(CGPoint.zero, in: tempImageView)
            
        } else if tag == 3 {
            
            activeView?.center = CGPoint(x: (activeView?.center.x)! + recognizer.translation(in: tempImageView).x,
                                                y: (activeView?.center.y)! + 1 + recognizer.translation(in: tempImageView).y)
            recognizer.setTranslation(CGPoint.zero, in: tempImageView)
            
        }
    
    }


    

    func PositionsMoved(recognizer: UIPanGestureRecognizer) {
        activeView?.center = CGPoint(x: (activeView?.center.x)! + recognizer.translation(in: tempImageView).x,
                                            y: (activeView?.center.y)! + recognizer.translation(in: tempImageView).y)
        recognizer.setTranslation(CGPoint.zero, in: tempImageView)
    }
    
    
}


extension EditorView: imageToolDelegate, FiltersMenuViewDelegate{
    func imageToolTapped(index: Int) {
        // Assign final Image
  
        self.scaleViews.collectionView.scrollToItem(at:IndexPath(item: 500, section: 0), at: .right, animated: false)
        self.scaleViews.collectionView.layoutIfNeeded()
        
        
        if index == 0 {
            
            self.EdeiterViewHeight.constant = FiltersView.frame.height
            self.FiltersView.isHidden = false
            self.opacityViews.isHidden = true
            self.rotateViews.isHidden = true
            self.positionsView.isHidden = true
            self.MaskViews.isHidden = true
            self.shadowTool.isHidden = true
            self.shadowViews.isHidden = true
            self.scaleViews.isHidden = true
            self.ColorViews.isHidden = true
            
        } else if index == 1 {
            
            self.EdeiterViewHeight.constant = MaskViews.frame.height
            self.opacityViews.isHidden = true
            self.FiltersView.isHidden = true
            self.rotateViews.isHidden = true
            self.positionsView.isHidden = true
            self.MaskViews.isHidden = false
            self.shadowTool.isHidden = true
            self.shadowViews.isHidden = true
            self.scaleViews.isHidden = true
            self.ColorViews.isHidden = true
        } else if index == 2 {
            
            self.ColorViewsBottomAnchor.constant = -50
            self.colorForType = 1
            self.EdeiterViewHeight.constant = shadowTool.frame.height
            self.opacityViews.isHidden = true
            self.FiltersView.isHidden = true
            self.rotateViews.isHidden = true
            self.positionsView.isHidden = true
            self.MaskViews.isHidden = true
            self.shadowTool.isHidden = false
            self.scaleViews.isHidden = true
            self.ColorViews.isHidden = true
            
        } else if index == 3 {
            
            self.EdeiterViewHeight.constant = opacityViews.frame.height
            self.FiltersView.isHidden = true
            self.rotateViews.isHidden = true
            self.opacityViews.isHidden = false
            self.positionsView.isHidden = true
            self.MaskViews.isHidden = true
            self.shadowTool.isHidden = true
            self.shadowViews.isHidden = true
            self.scaleViews.isHidden = true
            self.ColorViews.isHidden = true
            
        } else if index == 4 {
            
            self.EdeiterViewHeight.constant = rotateViews.frame.height
            self.FiltersView.isHidden = true
            self.rotateViews.isHidden = false
            self.opacityViews.isHidden = true
            self.positionsView.isHidden = true
            self.MaskViews.isHidden = true
            self.shadowTool.isHidden = true
            self.shadowViews.isHidden = true
            self.scaleViews.isHidden = true
            self.ColorViews.isHidden = true
            
        } else if index == 5 {
            
            self.EdeiterViewHeight.constant = positionsView.frame.height
            self.FiltersView.isHidden = true
            self.rotateViews.isHidden = true
            self.opacityViews.isHidden = true
            self.positionsView.isHidden = false
            self.MaskViews.isHidden = true
            self.shadowTool.isHidden = true
            self.shadowViews.isHidden = true
            self.scaleViews.isHidden = true
            self.ColorViews.isHidden = true
        } else if index == 6 {
            
            self.EdeiterViewHeight.constant =  self.scaleViews.frame.height
            self.FiltersView.isHidden = true
            self.rotateViews.isHidden = true
            self.opacityViews.isHidden = true
            self.positionsView.isHidden = true
            self.MaskViews.isHidden = true
            self.shadowTool.isHidden = true
            self.shadowViews.isHidden = true
            self.scaleViews.isHidden = false
            self.ColorViews.isHidden = true
        }
        
        
        UIView.animate(withDuration: 0.2, animations: {
            self.view.layoutIfNeeded()
        }, completion: {finished in })
        
    }
    
    func FilterTapped(string: String) {
        
      
        self.FiltersView.collectionView.layoutIfNeeded()
        activeImage!.image = originalImage
        
        if string == "None" {
            activeImage!.image = originalImage
        } else {
            let CIfilterName = "\(string)"
            
            let ciContext = CIContext(options: nil)
            let coreImage = CIImage(image: activeImage!.image!)
            let filter = CIFilter(name: CIfilterName)
            filter!.setDefaults()
            
            // Vignette filter
            
            // Finalize the filtered image
            filter!.setValue(coreImage, forKey: kCIInputImageKey)
            let filteredImageData = filter!.value(forKey: kCIOutputImageKey) as! CIImage
            let filteredImageRef = ciContext.createCGImage(filteredImageData, from: filteredImageData.extent)
            
            let originalOrientation = activeImage!.image!.imageOrientation
            let originalScale = activeImage!.image!.scale
            activeImage!.image = UIImage(cgImage: filteredImageRef!, scale: originalScale, orientation: originalOrientation)
            
        }
    }
    
    
    
}


extension EditorView: rotateViewDelegate {
    func rotateChanged(value: CGFloat) {
        if activeImage != nil {
         
            
            let radians = degreesToRadians(Double(value))
     
            
            let scaleX = activeImage?.transform.scaleX
            let scaleY = activeImage?.transform.scaleY
            
            
            activeImage?.transform = CGAffineTransform(scaleX: scaleX!, y: scaleY!).rotated(by: CGFloat(radians))
            
            
        } else if activeTextView != nil {
            let radians = degreesToRadians(Double(value))
            let scaleX = activeTextView?.transform.scaleX
            let scaleY = activeTextView?.transform.scaleY
            
            activeTextView?.transform = CGAffineTransform(scaleX: scaleX!, y: scaleY!).rotated(by: CGFloat(radians))
            
            
        }
    }
    
   
    
    /// private function ///
    fileprivate func degreesToRadians(_ degrees: Double) -> Double {
        return degrees * Double.pi / 180.0
    }
    
    
}

extension EditorView: opacityViewDelegate {
    func opacityChanged(value: Float) {
        if activeImage != nil {
            self.activeImage?.alpha = CGFloat(value)
        }
    }
    
    
}

extension EditorView: shapeToolDelegate {
    func shapeToolTapped(index: Int) {
        
        self.scaleViews.collectionView.scrollToItem(at:IndexPath(item: 500, section: 0), at: .right, animated: false)
        self.scaleViews.collectionView.layoutIfNeeded()
        
        if index == 0 {
            
            self.ColorViewsBottomAnchor.constant = 0
            self.colorForType = 0
            self.EdeiterViewHeight.constant = ColorViews.frame.height
            self.ColorViews.isHidden = false
            self.opacityViews.isHidden = true
            self.rotateViews.isHidden = true
            self.positionsView.isHidden = true
            self.shadowViews.isHidden = true
            self.shadowTool.isHidden = true
            self.scaleViews.isHidden = true
        } else if index == 1 {
            
             self.EdeiterViewHeight.constant = opacityViews.frame.height
             self.opacityViews.isHidden = false
             self.ColorViews.isHidden = true
             self.rotateViews.isHidden = true
             self.positionsView.isHidden = true
             self.shadowViews.isHidden = true
             self.shadowTool.isHidden = true
             self.scaleViews.isHidden = true
        } else if index == 2 {
            
            self.ColorViewsBottomAnchor.constant = -50
            self.colorForType = 1
            self.EdeiterViewHeight.constant = shadowTool.frame.height
            self.shadowViews.isHidden = true
            self.rotateViews.isHidden = true
            self.opacityViews.isHidden = true
            self.ColorViews.isHidden = true
            self.positionsView.isHidden = true
            self.shadowTool.isHidden = false
            self.scaleViews.isHidden = true
        } else if index == 3 {
            
            self.EdeiterViewHeight.constant = rotateViews.frame.height
            self.rotateViews.isHidden = false
            self.opacityViews.isHidden = true
            self.ColorViews.isHidden = true
            self.positionsView.isHidden = true
            self.shadowViews.isHidden = true
            self.shadowTool.isHidden = true
            self.scaleViews.isHidden = true
        } else if index == 4 {
            
            self.EdeiterViewHeight.constant = positionsView.frame.height
            self.rotateViews.isHidden = true
            self.opacityViews.isHidden = true
            self.ColorViews.isHidden = true
            self.positionsView.isHidden = false
            self.shadowViews.isHidden = true
            self.shadowTool.isHidden = true
            self.scaleViews.isHidden = true
            
        } else if index == 5 {
            self.EdeiterViewHeight.constant = scaleViews.frame.height
            self.rotateViews.isHidden = true
            self.opacityViews.isHidden = true
            self.ColorViews.isHidden = true
            self.positionsView.isHidden = true
            self.shadowViews.isHidden = true
            self.shadowTool.isHidden = true
            self.scaleViews.isHidden = false
            
            
        }
        
        UIView.animate(withDuration: 0.2, animations: {
            self.view.layoutIfNeeded()
        }, completion: {finished in })
        
    }
    
    
}
extension EditorView: LayersViewDelegate {
   

    func HideView(hide: Bool) {
        if hide == true {
            self.LayersViewHeight.constant = 130
            self.LayersViews.isHiddenOrShowing = true
            self.LayersViews.HideButton.setTitle("▼ Hide Layers", for: .normal)
            UIView.animate(withDuration: 0.5, animations: {
                self.view.layoutIfNeeded()
            }, completion: {finished in })
            
        } else {
          
            self.LayersViewHeight.constant = 35
            self.LayersViews.isHiddenOrShowing = false
            self.LayersViews.HideButton.setTitle("▲ Show Layers", for: .normal)
            UIView.animate(withDuration: 0.5, animations: {
                self.view.layoutIfNeeded()
            }, completion: {finished in
                 self.LayersViews.collectionView.layoutIfNeeded()
                 self.LayersViews.collectionView.reloadData()
            })
            
        }
    }

    
    
    func LayerRemoved(index: Int) {
       let indexs =  Array(self.tempImageView.subviews.reversed())
       let view = indexs[index]
       view.removeFromSuperview()
    }
    
    
    func LayerMoved(view: [UIView]) {
        for view in tempImageView.subviews{
            view.removeFromSuperview()
        }
        
       
        for i in view {
            tempImageView.addSubview(i)
            tempImageView.sendSubviewToBack(i)
           
            
        }
        
    }
    
    func LayerTapped(index: Int) {
        let indexs =  Array(self.tempImageView.subviews.reversed())
        let view = indexs[index]
        if view is UIImageView {
            if let views = view as? UIImageView {
                print(view.tag)
                editorType(tag: view.tag, Image: views)
            }
        } else if view is UITextView {
            if let text = view as? UITextView {
                textEditor(text: text)
            }
        }
        
        if #available(iOS 10.0, *) {
            let generator = UIImpactFeedbackGenerator(style: .heavy)
            generator.impactOccurred()
        }
        let previouTransform =  view.transform
        UIView.animate(withDuration: 0.2,
                       animations: {
                        view.transform = view.transform.scaledBy(x: 1.2, y: 1.2)
        },
                       completion: { _ in
                        UIView.animate(withDuration: 0.2) {
                            view.transform  = previouTransform
                        }
        })
        
        
        
    }
    

    
    
}

extension EditorView: UITextViewDelegate, FontViewDelegate {
    
   
    func fontTapped(font: String) {
        activeTextView!.font = UIFont(name: font, size: ((activeTextView?.font!.pointSize)!))
    
        self.activeTextView!.isScrollEnabled = true
        let font = UIFont(name: self.activeTextView!.font!.fontName, size: self.activeTextView!.font!.pointSize)
        self.activeTextView!.font = font
        
        let sizeToFit = self.activeTextView!.sizeThatFits(CGSize(width: UIScreen.main.bounds.size.width,
                                                                 height:CGFloat.greatestFiniteMagnitude))
        
        self.activeTextView!.bounds.size = CGSize(width: sizeToFit.width,
                                                  height: sizeToFit.height)
        
        self.activeTextView!.setNeedsDisplay()
        self.activeTextView!.isScrollEnabled = false
            
        }
    
    
    public func textViewDidChange(_ textView: UITextView) {
        hideToolbar(hide: true)
      
        let rotation = atan2(textView.transform.b, textView.transform.a)
        if rotation == 0 {
            let oldFrame = textView.frame
            let sizeToFit = textView.sizeThatFits(CGSize(width: oldFrame.width, height:CGFloat.greatestFiniteMagnitude))
            textView.frame.size = CGSize(width: oldFrame.width, height: sizeToFit.height)
        }
    }
    public func textViewDidBeginEditing(_ textView: UITextView) {
      
        textView.frame = CGRect(x: 0, y: tempImageView.center.y,
        width: UIScreen.main.bounds.width, height: textView.frame.height)
        lastTextViewTransform =  textView.transform
        lastTextViewTransCenter = textView.center
        lastTextViewFont = textView.font!
        activeTextView = textView
        self.textIndex = tempImageView.subviews.firstIndex(of: textView)
        textView.superview?.bringSubviewToFront(textView)
        textView.font = UIFont(name: textView.font!.fontName, size: textView.font!.pointSize)
        UIView.animate(withDuration: 0.3,
                       animations: {
                        textView.transform = CGAffineTransform.identity
                        textView.center = CGPoint(x: UIScreen.main.bounds.width / 2, y: 100)
        }, completion: nil)
        
    }
    
    public func textViewDidEndEditing(_ textView: UITextView) {
        guard lastTextViewTransform != nil && lastTextViewTransCenter != nil && lastTextViewFont != nil
            else {
                return
        }
        activeTextView = nil
    
        let whitespaceSet = CharacterSet.whitespaces
        if textView.text.trimmingCharacters(in: whitespaceSet).isEmpty {
            textView.removeFromSuperview()
            if let index = self.LayersViews.LayersArray.firstIndex(of: textView) {
                self.LayersViews.LayersArray.remove(at: index)
                self.LayersViews.collectionView.reloadData()
            }
            
        } else {
            
            tempImageView.insertSubview(textView, at: textIndex!)
            let textIndex = tempImageView.subviews.firstIndex(of: textView)
            let text = tempImageView.subviews[textIndex!]
            var indexs =  Array(self.LayersViews.LayersArray.reversed())
            indexs[textIndex!] = text
            self.LayersViews.collectionView.reloadData()
           
        }
    
        textView.isScrollEnabled = true
        let font = UIFont(name: textView.font!.fontName, size: textView.font!.pointSize)
       textView.font = font
        
        let sizeToFit = textView.sizeThatFits(CGSize(width: UIScreen.main.bounds.size.width,
                                                                 height:CGFloat.greatestFiniteMagnitude))
        
        textView.bounds.size = CGSize(width: sizeToFit.width,
                                                  height: sizeToFit.height)
        
        textView.setNeedsDisplay()
        textView.isScrollEnabled = false
     
        UIView.animate(withDuration: 0.3,
                       animations: {
                        textView.transform = self.lastTextViewTransform!
                        textView.center = self.lastTextViewTransCenter!
        }, completion: nil)
        
    
    }
    
    
    func textButtonTapped() {
        self.tempImageView.isUserInteractionEnabled = false
        self.DoneButton.isHidden = false
        self.TopView.isHidden = true
        self.BottomView.isHidden = true
        let textView = UITextView(frame: CGRect(x: 0, y: tempImageView.center.y,
                                                width: UIScreen.main.bounds.width, height: 30))
        
        //Text Attributes
        textView.clipsToBounds = false
        textView.textAlignment = .center
        textView.font =  UIFont.systemFont(ofSize: 40, weight: UIFont.Weight.bold)
       
        textView.textColor = UIColor.black
        textView.layer.shadowColor = UIColor.black.cgColor
        textView.layer.backgroundColor = UIColor.clear.cgColor
        //
        textView.autocorrectionType = .no
        textView.isScrollEnabled = false
        textView.delegate = self
        self.tempImageView.addSubview(textView)
        self.LayersViews.LayersArray.insert(textView, at: 0)
        self.LayersViews.collectionView.reloadData()
        
        addGestures(view: textView, tag: 2)
        textView.becomeFirstResponder()
    }
    
}


extension EditorView: BottomToolDelegate {
    func BottomToolTapped(index: Int) {
    
        if #available(iOS 10.0, *) {
            let generator = UIImpactFeedbackGenerator(style: .heavy)
            generator.impactOccurred()
        }
        
        
        if index == 1 {
            photoGallery = PhotoGallery(nibName: nil, bundle: Bundle(for: PhotoGallery.self))
            photosView()
        } else if index == 2 {
            shapes = shapeView(nibName: nil, bundle: Bundle(for: shapeView.self))
             shapesView()
        } else if index == 3 {
            self.textButtonTapped()
            
        } else if index == 4 {
            
        } else if index == 5 {
          
            Emojis = EmojisVC(nibName: nil, bundle: Bundle(for: EmojisVC.self))
            showEmojis()
        } else if index == 6 {
            
        } else if index == 7 {
            
            Restart()
   
        } else {

        }
      
      
        UIView.animate(withDuration: 0.2, animations: {
            self.view.layoutIfNeeded()
        }, completion: {finished in })
        

    }
    

    
    func pngFrom(image: UIImage) -> UIImage {
        let imageData = image.pngData()!
        let imagePng = UIImage(data: imageData)!
        return imagePng
    }

    
    func imageWithView(inView: UIView) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(inView.bounds.size, false, 0.0)
        if let context = UIGraphicsGetCurrentContext() {
            inView.layer.render(in: context)
            let image = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            return image
        }
        return nil
    }
    
    
    @objc func Saveimage(_ image: UIImage, withPotentialError error: NSErrorPointer, contextInfo: UnsafeRawPointer) {
        let alert = UIAlertController(title: "Image Saved", message: "Image successfully saved to Photos library", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
  
    
    func Restart() {
        let alert = UIAlertController(title: "Restart", message: "Are you sure you want to restart?",preferredStyle: UIAlertController.Style.alert)
        
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.default, handler: { _ in
            //Cancel Action
        }))
        alert.addAction(UIAlertAction(title: "Yes",
                                      style: UIAlertAction.Style.default,
                                      handler: {(_: UIAlertAction!) in
                                        
                                        for views in self.tempImageView.subviews {
                                            views.removeFromSuperview()
                                        }
                                        self.LayersViews.LayersArray.removeAll()
                                        self.LayersViews.collectionView.reloadData()
                                        
                                        
        }))
        self.present(alert, animated: true, completion: nil)
    }
    

    
    
}


extension EditorView: EmojiDelegate {
    
    
    func showEmojis() {
        bottomSheetIsVisible = true
        self.tempImageView.isUserInteractionEnabled = true
        Emojis.delegate = self
        
        self.addChild(Emojis)
        self.view.addSubview(Emojis.view)
        Emojis.didMove(toParent: self)
        let height = view.frame.height
        let width  = view.frame.width
        Emojis.view.frame = CGRect(x: 0, y: self.view.frame.maxY , width: width, height: height)
    }
    
    func removeEmojis() {
        bottomSheetIsVisible = false
        self.tempImageView.isUserInteractionEnabled = true
        UIView.animate(withDuration: 0.3,
                       delay: 0,
                       options: UIView.AnimationOptions.curveEaseIn,
                       animations: { () -> Void in
                        var frame = self.Emojis.view.frame
                        frame.origin.y = UIScreen.main.bounds.maxY
                        self.Emojis.view.frame = frame
                        
        }, completion: { (finished) -> Void in
            self.Emojis.view.removeFromSuperview()
            self.Emojis.removeFromParent()
        })
    }
    
    
    func EmojiTapped(EmojiName: String) {
      
     
        let emojiLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 150, height: 150))
        emojiLabel.text = EmojiName
        emojiLabel.font = UIFont.systemFont(ofSize: 150)
        emojiLabel.sizeToFit()
     
     
     
        let image = UIImage.imageWithLabel(emojiLabel)
        
        let imageView = UIImageView(image: image)
        imageView.contentMode = .scaleAspectFit
        imageView.layer.shadowColor = UIColor.black.cgColor
        imageView.frame.size = CGSize(width: 150, height: 150)
        imageView.center = tempImageView.center
        
        
        self.tempImageView.addSubview(imageView)
        self.LayersViews.LayersArray.insert(imageView, at: 0)
        self.LayersViews.collectionView.reloadData()
        
        addGestures(view: imageView, tag: 1)
        self.removeEmojis()
    }
    

    
    
}


extension EditorView: PhotosDelegate, MaskViewDelegate {
    func MaskViewOff() {
        if activeImage != nil {
            activeImage!.mask = nil
         
            

            
        }
        
    }
    
    
    func MaskViewTapped(Image: UIImage) {
        if activeImage != nil {
            let maskImageview  = UIImageView(frame: CGRect(x: 0, y: 0, width: 250, height: 250))
            maskImageview.image = Image
            activeImage?.contentMode = .scaleAspectFill
            maskImageview.contentMode = .scaleAspectFill
            maskImageview.frame = activeImage!.bounds
            activeImage!.mask = maskImageview
            
        }
    }
    
    
    func photoTapped(image: UIImage) {
        
      
        let img = UIImageView(frame: CGRect(x: 0, y: 0, width: 250, height: 250))
        img.contentMode = .scaleAspectFit
        img.image = image
        img.layer.shadowColor = UIColor.black.cgColor
        img.center = tempImageView.center
        self.tempImageView.addSubview(img)
        //Gestures
        addGestures(view: img, tag: 0)
        
        self.LayersViews.LayersArray.insert(img, at: 0)
        self.LayersViews.collectionView.reloadData()
        
    }
    
    
    
    func photosView() {
        bottomSheetIsVisible = true
        self.tempImageView.isUserInteractionEnabled = true
        photoGallery.photoDelegate = self
        
        let views = photoGallery
        self.present(views!, animated: true, completion: nil)
        
    }
    
    
}



extension EditorView: shapeDelegate{
    func shapeTapped(image: UIImage) {
        self.removeshapesView()
        let imageView = UIImageView(image: image)
        imageView.contentMode = .scaleAspectFit
        imageView.frame.size = CGSize(width: 150, height: 150)
        imageView.center = tempImageView.center
        imageView.layer.shadowColor = UIColor.black.cgColor
        self.tempImageView.addSubview(imageView)
        self.LayersViews.LayersArray.insert(imageView, at: 0)
        self.LayersViews.collectionView.reloadData()
        
        addGestures(view: imageView, tag: 1)
    }
    
    
    func shapesView() {
        bottomSheetIsVisible = true
        shapes.shapesDelegate = self
        
        self.addChild(shapes)
        self.view.addSubview(shapes.view)
        shapes.didMove(toParent: self)
        let height = view.frame.height
        let width  = view.frame.width
        shapes.view.frame = CGRect(x: 0, y: self.view.frame.maxY , width: width, height: height)
    }
    
    func removeshapesView() {
        bottomSheetIsVisible = false
        self.tempImageView.isUserInteractionEnabled = true
        UIView.animate(withDuration: 0.3,
                       delay: 0,
                       options: UIView.AnimationOptions.curveEaseIn,
                       animations: { () -> Void in
                        var frame = self.shapes.view.frame
                        frame.origin.y = UIScreen.main.bounds.maxY
                        self.shapes.view.frame = frame
                        
        }, completion: { (finished) -> Void in
            self.shapes.view.removeFromSuperview()
            self.shapes.removeFromParent()
        })
    }
    
}


extension EditorView: colorDelegate {
    func colorOff() {
        switch colorForType {
        case 0:
            if activeImage != nil {
               
                self.activeImage?.image = activeImage?.image?.withRenderingMode(.alwaysOriginal)
           
                
            }  else if activeTextView != nil {
                activeTextView!.textColor = UIColor.black
                
            }
        case 1:
            if activeTextView != nil {
                activeTextView!.layer.shadowColor = nil
            } else if  activeImage != nil {
                activeImage!.layer.shadowColor = nil
            }
        case 2:
            
            if activeTextView != nil {
                activeTextView!.layer.backgroundColor = nil
               
            }
        case 3:
            if activeTextView != nil {
                activeTextView!.layer.borderColor = nil
               
            }
            
        case .none:
            print("a status")
        case .some(_):
            print("no status")
        }
    }
    
    
    func UISliderColorTapped() {
        sliderColorVC = UISliderColorVC(nibName: nil, bundle: Bundle(for: UISliderColorVC.self))
        showColorView()
    }
    
    func showColorView() {
        if self.lastColors != nil {
            self.sliderColorVC.setLastColor(color: lastColors!)
        } else {
            self.sliderColorVC.setLastColor(color: UIColor.black)
        }
        
        self.sliderColorVC.SliderColorDelegate = self
        self.sliderColorVC.style(.dark)
        self.addChild(sliderColorVC)
        self.view.addSubview(sliderColorVC.view)
        sliderColorVC.didMove(toParent: self)
        let height = view.frame.height
        let width  = view.frame.width
        sliderColorVC.view.frame = CGRect(x: 0, y: self.view.frame.maxY , width: width, height: height)
    }
    
    func colorTapped(color: UIColor) {
        
        switch colorForType {
        case 0:
            if activeImage != nil {
                self.activeImage?.image = activeImage?.image?.withRenderingMode(.alwaysTemplate)
                self.activeImage?.tintColor = color
                self.lastColors = color
                
            }  else if activeTextView != nil {
                activeTextView!.textColor = color
                self.lastColors = color
            }
        case 1:
            if activeTextView != nil {
                activeTextView!.layer.shadowColor = color.cgColor
            } else if  activeImage != nil {
                activeImage!.layer.shadowColor = color.cgColor
            }
        case 2:
            
            if activeTextView != nil {
                activeTextView!.layer.backgroundColor = color.cgColor
                 self.lastColors = color
            }
        case 3:
            if activeTextView != nil {
                activeTextView!.layer.borderColor = color.cgColor
                self.lastColors = color
            }
            
        case .none:
             print("a status")
        case .some(_):
             print("no status")
        }
    
        
        
    }
    
    
}

extension EditorView: UISliderColorDelegate {
    func sliderColorCancel(color: UIColor) {
        switch colorForType {
        case 0:
            if activeImage != nil {
                self.activeImage?.image = activeImage?.image?.withRenderingMode(.alwaysTemplate)
                self.activeImage?.tintColor = color
                self.lastColors = color
                
            }  else if activeTextView != nil {
                activeTextView!.textColor = color
                self.lastColors = color
            }
        case 1:
            if activeTextView != nil {
                activeTextView!.layer.shadowColor = color.cgColor
                self.lastColors = color
            } else if activeImage != nil {
                activeImage!.layer.shadowColor = color.cgColor
                self.lastColors = color
            }
        case 2:
            
            if activeTextView != nil {
                activeTextView!.layer.backgroundColor = color.cgColor
                self.lastColors = color
            }
            
        case 3:
            if activeTextView != nil {
                activeTextView!.layer.borderColor = color.cgColor
                self.lastColors = color
            }
            
        case .none:
            print("a status")
        case .some(_):
            print("no status")
        }
        
        
    }
    
    func sliderColorDone(color: UIColor) {
        switch colorForType {
        case 0:
            if activeImage != nil {
                self.activeImage?.image = activeImage?.image?.withRenderingMode(.alwaysTemplate)
                self.activeImage?.tintColor = color
                self.lastColors = color
                
            }  else if activeTextView != nil {
                activeTextView!.textColor = color
                self.lastColors = color
            }
        case 1:
            if activeTextView != nil {
                activeTextView!.layer.shadowColor = color.cgColor
                self.lastColors = color
            } else if activeImage != nil {
                activeImage!.layer.shadowColor = color.cgColor
                self.lastColors = color
            }
        case 2:
            
            if activeTextView != nil {
                activeTextView!.layer.backgroundColor = color.cgColor
                self.lastColors = color
            }
            
        case 3:
            if activeTextView != nil {
                activeTextView!.layer.borderColor = color.cgColor
                self.lastColors = color
            }
            
        case .none:
            print("a status")
        case .some(_):
            print("no status")
        }
        
        
        
        self.lastColors = color
        colorsArray.insert(color, at: 0)
        self.ColorViews.collectionView.reloadData()
    }
    
    func sliderColorChanged(color: UIColor) {
        switch colorForType {
        case 0:
            if activeImage != nil {
                self.activeImage?.image = activeImage?.image?.withRenderingMode(.alwaysTemplate)
                self.activeImage?.tintColor = color
                self.lastColors = color
                
            }  else if activeTextView != nil {
                activeTextView!.textColor = color
                self.lastColors = color
            }
        case 1:
            if activeTextView != nil {
                activeTextView!.layer.shadowColor = color.cgColor
            } else if  activeImage != nil {
                activeImage!.layer.shadowColor = color.cgColor
                self.lastColors = color
            }
        case 2:
            
            if activeTextView != nil {
                activeTextView!.layer.backgroundColor = color.cgColor
                self.lastColors = color
            }
            
        case 3:
            if activeTextView != nil {
                activeTextView!.layer.borderColor = color.cgColor
                self.lastColors = color
            }
            
        case .none:
            print("a status")
        case .some(_):
            print("no status")
        }
        
    }
}


extension CGAffineTransform {
    var angle: CGFloat { return atan2(-self.c, self.a) }
    
    var angleInDegrees: CGFloat { return self.angle * 180 / .pi }
    
    var scaleX: CGFloat {
        let angle = self.angle
        return self.a * cos(angle) - self.c * sin(angle)
    }
    
    var scaleY: CGFloat {
        let angle = self.angle
        return self.d * cos(angle) + self.b * sin(angle)
    }
}
