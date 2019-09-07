//
//  ViewGestures.swift
//  PlaygroundStickers
//
//  Created by Faris Albalawi on 8/9/19.
//  Copyright © 2019 Faris Albalawi. All rights reserved.
//


import UIKit

extension EditorView: UIGestureRecognizerDelegate {
    
    //Gestures
    func addGestures(view: UIView, tag: Int) {
        view.tag = tag
        view.isUserInteractionEnabled = true
        let panGesture = UIPanGestureRecognizer(target: self,
                                                action: #selector(EditorView.panGesture))
        panGesture.minimumNumberOfTouches = 1
        panGesture.maximumNumberOfTouches = 1
        panGesture.delegate = self
        view.addGestureRecognizer(panGesture)
        
        let pinchGesture = UIPinchGestureRecognizer(target: self,
                                                    action: #selector(EditorView.pinchGesture))
        pinchGesture.delegate = self
        view.addGestureRecognizer(pinchGesture)
        
        let rotationGestureRecognizer = UIRotationGestureRecognizer(target: self,
                                                                    action:#selector(EditorView.rotationGesture) )
        rotationGestureRecognizer.delegate = self
        view.addGestureRecognizer(rotationGestureRecognizer)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(EditorView.tapGesture))
        view.addGestureRecognizer(tapGesture)
        
        
    }
    
    //Translation is moving object
    @objc func panGesture(_ recognizer: UIPanGestureRecognizer) {
        if let view = recognizer.view {
            let viewIndex = tempImageView.subviews.firstIndex(of: view)
            
           moveView(view: view, index: viewIndex!, recognizer: recognizer)
        }
    }
    
    @objc func pinchGesture(_ recognizer: UIPinchGestureRecognizer) {
        if let view = recognizer.view {
            lastView = view
            
           
            let maxScale : CGFloat  = 3.0;
            let minScale : CGFloat  = 0.01;
            
            let currentScale = view.frame.width/view.bounds.size.width
            var newScale = recognizer.scale
            if currentScale * recognizer.scale < minScale {
                newScale = minScale / currentScale
            } else if currentScale * recognizer.scale > maxScale {
                newScale = maxScale / currentScale
            }
            
            if view is UITextView {
                
            
                let textView = view as! UITextView
                textView.isScrollEnabled = true
                let font = UIFont(name: textView.font!.fontName, size: textView.font!.pointSize * newScale)
                textView.font = font
                
                let sizeToFit = textView.sizeThatFits(CGSize(width: UIScreen.main.bounds.size.width,
                                                             height:CGFloat.greatestFiniteMagnitude))
                
                textView.bounds.size = CGSize(width: sizeToFit.width,
                                              height: sizeToFit.height)
                
                textView.setNeedsDisplay()
                textView.isScrollEnabled = false
    
            } else {
             
                view.transform = view.transform.scaledBy(x: newScale, y: newScale)
                print(recognizer.scale)
               
           
                
            }
            recognizer.scale = 1
        }
    }
    
    
    @objc func rotationGesture(_ recognizer: UIRotationGestureRecognizer) {
        if let view = recognizer.view {
            view.transform = view.transform.rotated(by: recognizer.rotation)
            recognizer.rotation = 0
            lastView = view
            
            
        }
    }
    
    @objc func tapGesture(_ recognizer: UITapGestureRecognizer) {
        if let view = recognizer.view {
        
                scaleEffect(view: view)
        }
    }
    
    
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        if gestureRecognizer is UILongPressGestureRecognizer ||
            otherGestureRecognizer is UILongPressGestureRecognizer {
            return true
        }
        
        return false
    }
    
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRequireFailureOf otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return false
    }
    
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldBeRequiredToFailBy otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return false
    }
    
    
    @objc func screenEdgeSwiped(_ recognizer: UIScreenEdgePanGestureRecognizer) {
        if recognizer.state == .recognized {
            if !bottomSheetIsVisible {
                photosView()
            }
        }
    }
    
    // to Override Control Center screen edge pan from bottom
    override public var prefersStatusBarHidden: Bool {
        return true
    }
    
    @objc func scaleEffect(view: UIView) {
    
         hideToolbar(hide: true)
         activeView = view
        
        if view is UIImageView {
            if let views = view as? UIImageView {
                activeImage = views
                editorType(tag: view.tag, Image: views)
                //  views.setImage(string: nil, color: nil, circular: false, stroke: true)
            
                
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
    
    func moveView(view: UIView, index: Int, recognizer: UIPanGestureRecognizer)  {
        
       hideToolbar(hide: true)
       deleteView.isHidden = false
       LayersViews.isHidden = true
       LineX.isHidden = false
       LineY.isHidden = false
       lastView = view
        
        let pointToSuperView = recognizer.location(in: self.view)
      
        //
        view.center = CGPoint(x: view.center.x + recognizer.translation(in: tempImageView).x,
                              y: view.center.y + recognizer.translation(in: tempImageView).y)
        
        recognizer.setTranslation(CGPoint.zero, in: tempImageView)
        
        if view.center.x == LineX.center.x && view.center.y == LineY.center.y {
            if #available(iOS 10.0, *) {
                let generator = UIImpactFeedbackGenerator(style: .heavy)
                generator.impactOccurred()
            }
        } else if view.center.x == LineX.center.x {
            if #available(iOS 10.0, *) {
                let generator = UIImpactFeedbackGenerator(style: .light)
                generator.impactOccurred()
            }
        } else if view.center.y == LineY.center.y {
            if #available(iOS 10.0, *) {
                let generator = UIImpactFeedbackGenerator(style: .light)
                generator.impactOccurred()
            }
        }
        
        if let previousPoint = lastPanPoint {
         
                
            if deleteView.frame.contains(pointToSuperView) && !deleteView.frame.contains(previousPoint) {
                if #available(iOS 10.0, *) {
                    let generator = UIImpactFeedbackGenerator(style: .heavy)
                    generator.impactOccurred()
                }
                UIView.animate(withDuration: 0.3, animations: {
                    view.transform = view.transform.scaledBy(x: 0.25, y: 0.25)
                    view.center = recognizer.location(in: self.tempImageView)
                })
            }
                
                //View is going out of deleteView
            else if deleteView.frame.contains(previousPoint) && !deleteView.frame.contains(pointToSuperView) {
                //Scale to original Size
                UIView.animate(withDuration: 0.3, animations: {
                    view.transform = view.transform.scaledBy(x: 4, y: 4)
                    view.center = recognizer.location(in: self.tempImageView)
                })
            }
        }
        
        lastPanPoint = pointToSuperView
        
        if recognizer.state == .ended {
            imageViewToPan = nil
            lastPanPoint = nil
            hideToolbar(hide: false)
            LayersViews.isHidden = false

            LineX.isHidden = true
            LineY.isHidden = true
            
            deleteView.isHidden = true
            let point = recognizer.location(in: self.view)
            
            if deleteView.frame.contains(point) { // Delete the view
                view.removeFromSuperview()
               
                var index_1 = [Int]()
                for i in 0...self.LayersViews.LayersArray.count - 1 {
                    index_1.append(i)
                }
                
                let index_2 = Array(index_1.reversed())
                self.LayersViews.LayersArray.remove(at: index_2[index])
                self.LayersViews.collectionView.reloadData()
                self.LayersViews.collectionView.layoutIfNeeded()
    
     
                if #available(iOS 10.0, *) {
                    let generator = UINotificationFeedbackGenerator()
                    generator.notificationOccurred(.success)
                }
            } else if !tempImageView.bounds.contains(view.center) { //Snap the view back to tempimageview
                UIView.animate(withDuration: 0.3, animations: {
                    view.center = self.tempImageView.center
                })
                
            }
        }
    }
    

    @objc func subImageViews(view: UIView) -> [UIImageView] {
        var imageviews: [UIImageView] = []
        for tempImageView in view.subviews {
            if tempImageView is UIImageView {
                imageviews.append(tempImageView as! UIImageView)
            }
        }
        return imageviews
    }
}


extension Array {
    mutating func rearrange(from: Int, to: Int) {
        insert(remove(at: from), at: to)
    }
}


func rotate(view: UIView ,angle: CGFloat) {
    let radians = angle / 180.0 * CGFloat.pi
    let rotation = view.transform.rotated(by: radians)
    view.transform = rotation
}
