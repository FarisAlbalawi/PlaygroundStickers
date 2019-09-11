//
//  shadowView.swift
//  PlaygroundStickers
//
//  Created by Faris Albalawi on 8/24/19.
//  Copyright © 2019 Faris Albalawi. All rights reserved.
//

import UIKit


protocol shadowViewDelegate {
    func shadow(Width: Float, height: Float, Opacity: Float, Radius: Float)
   
}


enum shadowType {
    case shadowOffset
    case shadowOpacity
    case shadowRadius
}



class shadowView: UIView {

    
    var Delegate: shadowViewDelegate?

     let shadowOffsetWidth: CustomSlider = {
        let shadowOffsetWidth = CustomSlider()
        shadowOffsetWidth.maximumValue = 10
        shadowOffsetWidth.minimumValue = 0
        shadowOffsetWidth.thumbTintColor = ButtonColor
        shadowOffsetWidth.minimumTrackTintColor = barColor
        shadowOffsetWidth.maximumTrackTintColor = barColor
        
        shadowOffsetWidth.translatesAutoresizingMaskIntoConstraints = false
        shadowOffsetWidth.addTarget(self, action: #selector(shadowView.shadowOffsetWidthVlaue(_:)), for: .valueChanged)
        return shadowOffsetWidth
    }()
    
    let shadowOffsetHeight: CustomSlider = {
        let shadowOffsetHeight = CustomSlider()
        shadowOffsetHeight.maximumValue = 10
        shadowOffsetHeight.minimumValue = 0
        shadowOffsetHeight.minimumTrackTintColor = barColor
        shadowOffsetHeight.maximumTrackTintColor = barColor
        
        shadowOffsetHeight.thumbTintColor = ButtonColor
        shadowOffsetHeight.translatesAutoresizingMaskIntoConstraints = false
        shadowOffsetHeight.addTarget(self, action: #selector(shadowView.shadowOffsetHeightVlaue(_:)), for: .valueChanged)
        return shadowOffsetHeight
    }()
    
    
    let shadowOpacity: CustomSlider = {
        let shadowOpacity = CustomSlider()
        shadowOpacity.maximumValue = 1
        shadowOpacity.minimumValue = 0
        shadowOpacity.minimumTrackTintColor = barColor
        shadowOpacity.maximumTrackTintColor = barColor
        
        shadowOpacity.thumbTintColor = ButtonColor
        shadowOpacity.translatesAutoresizingMaskIntoConstraints = false
        shadowOpacity.addTarget(self, action: #selector(shadowView.shadowOpacityVlaue(_:)), for: .valueChanged)
        return shadowOpacity
    }()
    
    
    let shadowRadius: CustomSlider = {
        let shadowRadius = CustomSlider()
        shadowRadius.maximumValue = 10
        shadowRadius.minimumValue = 0
        shadowRadius.minimumTrackTintColor = barColor
        shadowRadius.maximumTrackTintColor = barColor
        
        shadowRadius.thumbTintColor = ButtonColor
        shadowRadius.translatesAutoresizingMaskIntoConstraints = false
        shadowRadius.addTarget(self, action: #selector(shadowView.shadowRadiusVlaue(_:)), for: .valueChanged)
        return shadowRadius
    }()
    
    let labWidth: UILabel = {
        let lab = UILabel()
        lab.font = UIFont.systemFont(ofSize: 10, weight: UIFont.Weight.bold)
        lab.textColor = blueColor
        lab.textAlignment = .center
        lab.text = "300%"
        lab.sizeToFit()
        lab.translatesAutoresizingMaskIntoConstraints = false
        return lab
    }()
    
    let labHeight: UILabel = {
        let lab = UILabel()
        lab.font = UIFont.systemFont(ofSize: 10, weight: UIFont.Weight.bold)
        lab.textColor = blueColor
        lab.text = "0.0%"
        lab.textAlignment = .center
        lab.sizeToFit()
        lab.translatesAutoresizingMaskIntoConstraints = false
        return lab
    }()
    
    let labOpacity: UILabel = {
        let lab = UILabel()
        lab.font = UIFont.systemFont(ofSize: 10, weight: UIFont.Weight.bold)
        lab.textColor = blueColor
        lab.textAlignment = .center
        lab.text = "100.0%"
        lab.sizeToFit()
        lab.translatesAutoresizingMaskIntoConstraints = false
        return lab
    }()
    
    let labRadius: UILabel = {
        let lab = UILabel()
        lab.font = UIFont.systemFont(ofSize: 10, weight: UIFont.Weight.bold)
        lab.textColor = blueColor
        lab.textAlignment = .center
        lab.text = "0.0%"
        lab.sizeToFit()
        lab.translatesAutoresizingMaskIntoConstraints = false
        return lab
    }()
    
    private let screenSize = UIScreen.main.bounds.size
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        shadowOffsetWidth.setValue(3.0, animated:true)
        shadowOpacity.setValue(1.0, animated:true)
    }
    
    //initWithCode to init view from xib or storyboard
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
    }
    
    
    func shadowTypes(_ Type: shadowType) {
        switch Type {
        case .shadowOffset:
            SetShadowOffset()
        case .shadowOpacity:
            SetShadowOpacity()
         case .shadowRadius:
            SetShadowRadius()
        }
    }
    
 
    func SetShadowOffset(){
        addSubview(shadowOffsetWidth)
        addSubview(shadowOffsetHeight)
        addSubview(labWidth)
        addSubview(labHeight)
        
        shadowOpacity.removeFromSuperview()
        shadowRadius.removeFromSuperview()
        labOpacity.removeFromSuperview()
        labRadius.removeFromSuperview()
        let screenWidth = screenSize.width
        
        NSLayoutConstraint.activate([
            shadowOffsetWidth.widthAnchor.constraint(equalToConstant: screenWidth / 1.17),
            shadowOffsetWidth.topAnchor.constraint(equalTo: topAnchor,constant: 0),
            shadowOffsetWidth.rightAnchor.constraint(equalTo: rightAnchor,constant: -5),
            
            labWidth.topAnchor.constraint(equalTo: topAnchor,constant: 15),
            labWidth.leftAnchor.constraint(equalTo: leftAnchor,constant: 4),
            
        
            shadowOffsetHeight.widthAnchor.constraint(equalToConstant: screenWidth / 1.17),
            shadowOffsetHeight.topAnchor.constraint(equalTo: shadowOffsetWidth.bottomAnchor,constant: 7),
            shadowOffsetHeight.rightAnchor.constraint(equalTo: rightAnchor,constant: -5),
            
            labHeight.topAnchor.constraint(equalTo: shadowOffsetWidth.bottomAnchor,constant: 20),
            labHeight.leftAnchor.constraint(equalTo: leftAnchor,constant: 4),
            
            ])
    }
    
    func SetShadowOpacity() {
        addSubview(shadowOpacity)
        addSubview(labOpacity)
        shadowOffsetWidth.removeFromSuperview()
        shadowRadius.removeFromSuperview()
        shadowOffsetHeight.removeFromSuperview()
        
        labHeight.removeFromSuperview()
        labWidth.removeFromSuperview()
        labRadius.removeFromSuperview()
     
        let screenWidth = screenSize.width
        
        NSLayoutConstraint.activate([
           
           
            shadowOpacity.widthAnchor.constraint(equalToConstant: screenWidth / 1.15),
            shadowOpacity.topAnchor.constraint(equalTo: topAnchor,constant: 8),
            shadowOpacity.rightAnchor.constraint(equalTo: rightAnchor,constant: -5),
           
            labOpacity.topAnchor.constraint(equalTo: topAnchor,constant: 23),
            labOpacity.leftAnchor.constraint(equalTo: leftAnchor,constant: 4),
            
            
            ])
        
    }
    
    func SetShadowRadius() {
        addSubview(shadowRadius)
        addSubview(labRadius)
        shadowOffsetWidth.removeFromSuperview()
        shadowOpacity.removeFromSuperview()
        shadowOffsetHeight.removeFromSuperview()

        labHeight.removeFromSuperview()
        labWidth.removeFromSuperview()
        labOpacity.removeFromSuperview()
        
        let screenWidth = screenSize.width
        
        NSLayoutConstraint.activate([
            
            shadowRadius.widthAnchor.constraint(equalToConstant: screenWidth / 1.17),
            shadowRadius.topAnchor.constraint(equalTo: topAnchor,constant: 8),
            shadowRadius.rightAnchor.constraint(equalTo: rightAnchor,constant: -5),
            
            labRadius.topAnchor.constraint(equalTo: topAnchor,constant: 23),
            labRadius.leftAnchor.constraint(equalTo: leftAnchor,constant: 4),
            
            
            
    
            
            ])
    }
    
    
    func setLastshadow(shadowOffsetWidth: CGFloat, shadowOffsetHeight: CGFloat, shadowOpacity: Float, shadowRadius: CGFloat ) {
        
        self.shadowOffsetWidth.setValue(Float(shadowOffsetWidth), animated:true)
        self.shadowOffsetHeight.setValue(Float(shadowOffsetHeight), animated:true)
        self.shadowOpacity.setValue(Float(shadowOpacity), animated:true)
        self.shadowRadius.setValue(Float(shadowRadius), animated:true)
        self.labWidth.text = "\(round(shadowOffsetWidth * 100))%"
        self.labHeight.text = "\(round(shadowOffsetHeight * 100))%"
        self.labRadius.text = "\(round(shadowRadius * 100))%"
        self.labOpacity.text = "\(round(shadowOpacity * 100))%"
    }
    
    
   @objc func shadowOffsetWidthVlaue(_ sender: UISlider) {
    Delegate?.shadow(Width: sender.value, height: shadowOffsetHeight.value, Opacity: shadowOpacity.value, Radius: shadowRadius.value)
       self.labWidth.text = "\(round(sender.value * 100))%"
       self.labHeight.text = "\(round(shadowOffsetHeight.value * 100))%"
       self.labRadius.text = "\(round(shadowRadius.value * 100))%"
       self.labOpacity.text = "\(round(shadowOpacity.value * 100))%"
    }
    
    @objc func shadowOffsetHeightVlaue(_ sender: UISlider) {
          Delegate?.shadow(Width: shadowOffsetWidth.value, height: sender.value, Opacity: shadowOpacity.value, Radius: shadowRadius.value)
        
        self.labWidth.text = "\(round(shadowOffsetWidth.value * 100))%"
        self.labHeight.text = "\(round(sender.value * 100))%"
        self.labRadius.text = "\(round(shadowRadius.value * 100))%"
        self.labOpacity.text = "\(round(shadowOpacity.value * 100))%"
        
    }
    
    
    @objc func shadowOpacityVlaue(_ sender: UISlider) {
          Delegate?.shadow(Width: shadowOffsetWidth.value, height: shadowOffsetHeight.value, Opacity: sender.value, Radius: shadowRadius.value)
        
        self.labWidth.text = "\(round(shadowOffsetWidth.value * 100))%"
        self.labHeight.text = "\(round(shadowOffsetHeight.value * 100))%"
        self.labRadius.text = "\(round(shadowRadius.value * 100))%"
        self.labOpacity.text = "\(round(sender.value * 100))%"
    }
    
    @objc func shadowRadiusVlaue(_ sender: UISlider) {
         Delegate?.shadow(Width: shadowOffsetWidth.value , height: shadowOffsetHeight.value , Opacity: shadowOpacity.value, Radius: sender.value)
        
        self.labWidth.text = "\(round(shadowOffsetWidth.value * 100))%"
        self.labHeight.text = "\(round(shadowOffsetHeight.value * 100))%"
        self.labRadius.text = "\(round(sender.value * 100))%"
        self.labOpacity.text = "\(round(shadowOpacity.value * 100))%"
    }
}
