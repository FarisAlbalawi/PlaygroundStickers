//
//  TextBackgroundView.swift
//  PlaygroundStickers
//
//  Created by Faris Albalawi on 9/5/19.
//  Copyright © 2019 Faris Albalawi. All rights reserved.
//



import Foundation
import UIKit


enum TextBackgroundType {
    case angular
    case opacity

}

protocol TextBackgroundViewDelegate {
    func TextOpacityChanged(value: Float)
    func TextAngularChanged(value: Float)
}

class TextBackgroundView: UIView {
    
    
    var Delegate: TextBackgroundViewDelegate?
    
    private let opacitySlider: CustomSlider = {
        let opacitySlider = CustomSlider()
        opacitySlider.maximumValue = 1.0
        opacitySlider.minimumValue = 0
        opacitySlider.setValue(1.0, animated:true)
        opacitySlider.minimumTrackTintColor = barColor
        opacitySlider.maximumTrackTintColor = barColor
        opacitySlider.thumbTintColor = pinkColor
        opacitySlider.translatesAutoresizingMaskIntoConstraints = false
        opacitySlider.addTarget(self, action: #selector(TextBackgroundView.changeOpacityVlaue(_:)), for: .valueChanged)
        return opacitySlider
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
    
    private let angularSlider: CustomSlider = {
        let angularSlider = CustomSlider()
        angularSlider.maximumValue = 50.0
        angularSlider.minimumValue = 0
        angularSlider.setValue(1.0, animated:true)
        angularSlider.minimumTrackTintColor = barColor
        angularSlider.maximumTrackTintColor = barColor
        angularSlider.thumbTintColor = pinkColor
        angularSlider.translatesAutoresizingMaskIntoConstraints = false
        angularSlider.addTarget(self, action: #selector(TextBackgroundView.changeAngularVlaue(_:)), for: .valueChanged)
        return angularSlider
    }()
    
    

    
    
    let labAngular: UILabel = {
        let lab = UILabel()
        lab.font = UIFont.systemFont(ofSize: 10, weight: UIFont.Weight.bold)
        lab.textColor = blueColor
        lab.textAlignment = .center
        lab.text = "0.0"
        lab.sizeToFit()
        lab.translatesAutoresizingMaskIntoConstraints = false
        return lab
    }()
    
    
    private let screenSize = UIScreen.main.bounds.size
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        self.opacitySlider.setValue(1.0, animated:true)
        
    }
    
    
    //initWithCode to init view from xib or storyboard
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }
    
    private func setupView() {
    
    }
    
    func shadowTypes(_ Type: TextBackgroundType) {
        switch Type {
        case .angular:
            SetAngular()
        case .opacity:
            SetOpacity()
        }
    }
    
    func SetAngular() {
        self.addSubview(angularSlider)
        addSubview(labAngular)
        opacitySlider.removeFromSuperview()
        labOpacity.removeFromSuperview()
        let screenWidth = screenSize.width
        NSLayoutConstraint.activate([
            
            angularSlider.widthAnchor.constraint(equalToConstant: screenWidth / 1.15),
            angularSlider.topAnchor.constraint(equalTo: topAnchor,constant: 8),
            angularSlider.rightAnchor.constraint(equalTo: rightAnchor,constant: -5),
            
            labAngular.topAnchor.constraint(equalTo: topAnchor,constant: 23),
            labAngular.leftAnchor.constraint(equalTo: leftAnchor,constant: 4),
            
            
            
            ])
    }
    
    func SetOpacity() {
        self.addSubview(opacitySlider)
        addSubview(labOpacity)
        angularSlider.removeFromSuperview()
        labAngular.removeFromSuperview()
     
        let screenWidth = screenSize.width
        NSLayoutConstraint.activate([
            
            opacitySlider.widthAnchor.constraint(equalToConstant: screenWidth / 1.17),
            opacitySlider.topAnchor.constraint(equalTo: topAnchor,constant: 8),
            opacitySlider.rightAnchor.constraint(equalTo: rightAnchor,constant: -5),
            
            labOpacity.topAnchor.constraint(equalTo: topAnchor,constant: 23),
            labOpacity.leftAnchor.constraint(equalTo: leftAnchor,constant: 4),
            
            
            
            ])
    }
    
    
    
    @objc func changeOpacityVlaue(_ sender: UISlider) {
        self.Delegate?.TextOpacityChanged(value: sender.value)
        self.labOpacity.text = "\(round(sender.value * 100))%"
    }
    
    
    @objc func changeAngularVlaue(_ sender: UISlider) {
        self.Delegate?.TextAngularChanged(value: sender.value)
        self.labAngular.text = "\(round(sender.value))"
    }
    
    
}
