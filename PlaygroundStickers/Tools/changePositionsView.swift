//
//  changePositionsView.swift
//  PlaygroundStickers
//
//  Created by Faris Albalawi on 8/21/19.
//  Copyright © 2019 Faris Albalawi. All rights reserved.
//

import UIKit

protocol PositionsDelegate {
    func PositionsMoved(recognizer: UIPanGestureRecognizer)
    func ButtonMoved(recognizer : UIPanGestureRecognizer, tag: Int)
}



class changePositionsView: UIView, UIGestureRecognizerDelegate{

    
    var Delegate : PositionsDelegate?
    
    
   var recognizer = UIPanGestureRecognizer()
    
    private let leftButton: UIButton = {
        let left = UIButton()
        let image = UIImage(named: "left")?.withRenderingMode(.alwaysTemplate)
        left.setImage(image, for: .normal)
        left.imageView?.tintColor = ButtonColor
        left.imageView?.contentMode = .scaleAspectFit
        left.addTarget(self, action: #selector(changePositionsView.didPressLeft), for: UIControl.Event.touchUpInside)
        left.translatesAutoresizingMaskIntoConstraints = false
        
        return left
    }()
    
    private let rightButton: UIButton = {
        let right = UIButton()
        let image = UIImage(named: "right")?.withRenderingMode(.alwaysTemplate)
        right.setImage(image, for: .normal)
         right.imageView?.tintColor = ButtonColor
        right.imageView?.contentMode = .scaleAspectFit
        right.addTarget(self, action: #selector(changePositionsView.didPressRight), for: UIControl.Event.touchUpInside)
        right.translatesAutoresizingMaskIntoConstraints = false
        
        return right
    }()
    
    
    private let upButton: UIButton = {
        let Up = UIButton()
        let image = UIImage(named: "up")?.withRenderingMode(.alwaysTemplate)
        Up.setImage(image, for: .normal)
        Up.imageView?.tintColor = ButtonColor
        Up.imageView?.contentMode = .scaleAspectFit
        Up.addTarget(self, action: #selector(changePositionsView.didPressUp), for: UIControl.Event.touchUpInside)
        Up.translatesAutoresizingMaskIntoConstraints = false
        
        return Up
    }()
    
    private let downButton: UIButton = {
        let down = UIButton()
        let image = UIImage(named: "down")?.withRenderingMode(.alwaysTemplate)
        down.setImage(image, for: .normal)
        down.imageView?.tintColor = ButtonColor
        down.imageView?.contentMode = .scaleAspectFit
        down.addTarget(self, action: #selector(changePositionsView.didPressDown), for: UIControl.Event.touchUpInside)
        down.translatesAutoresizingMaskIntoConstraints = false
        
        return down
    }()
    
    private let views: UIView = {
        let views = UIView()
        views.backgroundColor = yellowColor
        views.translatesAutoresizingMaskIntoConstraints = false
        views.layer.cornerRadius = 55 / 2
        return views
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
       
        
    }
    
    
    //initWithCode to init view from xib or storyboard
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }
    
    private func setupView() {
  
        self.addSubview(views)
        self.addSubview(leftButton)
        self.addSubview(rightButton)
        self.addSubview(downButton)
        self.addSubview(upButton)
        
        views.isUserInteractionEnabled = true
        let panGesture = UIPanGestureRecognizer(target: self,
                                                action: #selector(EditorView.panGesture))
       
        panGesture.delegate = self
        views.addGestureRecognizer(panGesture)
        
        NSLayoutConstraint.activate([
            
            views.widthAnchor.constraint(equalToConstant: 55),
            views.heightAnchor.constraint(equalToConstant: 55),
            views.centerYAnchor.constraint(equalTo: centerYAnchor),
            views.centerXAnchor.constraint(equalTo: centerXAnchor),


            leftButton.widthAnchor.constraint(equalToConstant: 40),
            leftButton.heightAnchor.constraint(equalToConstant: 40),
            leftButton.centerYAnchor.constraint(equalTo: centerYAnchor),
            leftButton.leftAnchor.constraint(equalTo: leftAnchor, constant: 20),
            
            rightButton.widthAnchor.constraint(equalToConstant: 40),
            rightButton.heightAnchor.constraint(equalToConstant: 40),
            rightButton.centerYAnchor.constraint(equalTo: centerYAnchor),
            rightButton.leftAnchor.constraint(equalTo: leftAnchor, constant: 80),
            
            

            downButton.widthAnchor.constraint(equalToConstant: 40),
            downButton.heightAnchor.constraint(equalToConstant: 40),
            downButton.centerYAnchor.constraint(equalTo: centerYAnchor),
            downButton.rightAnchor.constraint(equalTo: rightAnchor, constant: -20),

            upButton.widthAnchor.constraint(equalToConstant: 40),
            upButton.heightAnchor.constraint(equalToConstant: 40),
            upButton.centerYAnchor.constraint(equalTo: centerYAnchor),
            upButton.rightAnchor.constraint(equalTo: rightAnchor, constant: -80),
            
            
            
            

            ])
    }
    
    
    @objc func panGesture(_ recognizer: UIPanGestureRecognizer) {
 
        let previouTransform = self.views.transform
        
        self.recognizer = recognizer
       
        if recognizer.state == .began {
            let previouTransform =  self.views.transform
            UIView.animate(withDuration: 0.2,
                           animations: {
                            self.views.transform = self.views.transform.scaledBy(x: 1.2, y: 1.2)
            },
                           completion: { _ in
                            UIView.animate(withDuration: 0.2) {
                                self.views.transform  = previouTransform
                            }
            })
        }
        if recognizer.state == .changed {
       
            self.Delegate?.PositionsMoved(recognizer: recognizer)
        } else if recognizer.state == .ended {
            self.views.transform = previouTransform
            self.layoutIfNeeded()
           
        } 
      

    }
    
    @objc func didPressRight() {
        self.Delegate?.ButtonMoved(recognizer: recognizer, tag: 0)
    }
    
    @objc func didPressLeft() {
     
        self.Delegate?.ButtonMoved(recognizer: recognizer, tag: 1)
    }
    
   
    
    @objc func didPressUp() {
       self.Delegate?.ButtonMoved(recognizer: recognizer, tag: 2)
    }
    
    @objc func didPressDown() {
      self.Delegate?.ButtonMoved(recognizer: recognizer, tag: 3)
    }
    

}
