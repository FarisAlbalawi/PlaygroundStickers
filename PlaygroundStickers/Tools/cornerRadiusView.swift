//
//  cornerRadiusView.swift
//  PlaygroundStickers
//
//  Created by Faris Albalawi on 9/6/19.
//  Copyright © 2019 Faris Albalawi. All rights reserved.
//



import Foundation
import UIKit


enum cornerRadiusViewType {
    case angular
    case BorderWidth
    
}

protocol cornerRadiusViewDelegate {
    func borderWidthChanged(value: Float)
    func cornerAngularChanged(value: Float)
}

class cornerRadiusView: UIView {
    
    
    var Delegate: cornerRadiusViewDelegate?
    
    private let BorderWidthSlider: CustomSlider = {
        let BorderWidthSlider = CustomSlider()
        BorderWidthSlider.maximumValue = 10
        BorderWidthSlider.minimumValue = 0
        BorderWidthSlider.setValue(1.0, animated:true)
        BorderWidthSlider.minimumTrackTintColor = barColor
        BorderWidthSlider.maximumTrackTintColor = barColor
        BorderWidthSlider.thumbTintColor = pinkColor
        BorderWidthSlider.translatesAutoresizingMaskIntoConstraints = false
        BorderWidthSlider.addTarget(self, action: #selector(cornerRadiusView.changeBorderWidthVlaue(_:)), for: .valueChanged)
        return BorderWidthSlider
    }()
    
    let BorderWidth: UILabel = {
        let lab = UILabel()
        lab.font = UIFont.systemFont(ofSize: 10, weight: UIFont.Weight.bold)
        lab.textColor = blueColor
        lab.textAlignment = .center
        lab.text = "0.0"
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
        angularSlider.addTarget(self, action: #selector(cornerRadiusView.changeAngularVlaue(_:)), for: .valueChanged)
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
        self.BorderWidthSlider.setValue(1.0, animated:true)
        
    }
    
    
    //initWithCode to init view from xib or storyboard
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }
    
    private func setupView() {
        
    }
    
    func cornerRadiusTypes(_ Type: cornerRadiusViewType) {
        switch Type {
        case .angular:
            SetAngular()
        case .BorderWidth:
            SetBorderWidth()
        }
    }
    
    func SetAngular() {
        self.addSubview(angularSlider)
        addSubview(labAngular)
        BorderWidthSlider.removeFromSuperview()
        BorderWidth.removeFromSuperview()
        let screenWidth = screenSize.width
        NSLayoutConstraint.activate([
            
            angularSlider.widthAnchor.constraint(equalToConstant: screenWidth / 1.13),
            angularSlider.topAnchor.constraint(equalTo: topAnchor,constant: 8),
            angularSlider.rightAnchor.constraint(equalTo: rightAnchor,constant: -5),
            
            labAngular.topAnchor.constraint(equalTo: topAnchor,constant: 23),
            labAngular.leftAnchor.constraint(equalTo: leftAnchor,constant: 10),
            
            
            
            ])
    }
    
    func SetBorderWidth() {
        self.addSubview(BorderWidthSlider)
        addSubview(BorderWidth)
        angularSlider.removeFromSuperview()
        labAngular.removeFromSuperview()
        
        let screenWidth = screenSize.width
        NSLayoutConstraint.activate([
            
            BorderWidthSlider.widthAnchor.constraint(equalToConstant: screenWidth / 1.13),
            BorderWidthSlider.topAnchor.constraint(equalTo: topAnchor,constant: 8),
            BorderWidthSlider.rightAnchor.constraint(equalTo: rightAnchor,constant: -5),
            
            BorderWidth.topAnchor.constraint(equalTo: topAnchor,constant: 23),
            BorderWidth.leftAnchor.constraint(equalTo: leftAnchor,constant: 10),
            
            
            
            ])
    }
    
    
    
    @objc func changeBorderWidthVlaue(_ sender: UISlider) {
        self.Delegate?.borderWidthChanged(value: sender.value)
        self.BorderWidth.text = "\(round(sender.value))"
    }
    
    
    @objc func changeAngularVlaue(_ sender: UISlider) {
        self.Delegate?.cornerAngularChanged(value: sender.value)
        self.labAngular.text = "\(round(sender.value))"
    }
    
    
}
