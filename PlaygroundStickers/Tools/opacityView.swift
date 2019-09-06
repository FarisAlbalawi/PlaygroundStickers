//
//  opacityView.swift
//  PlaygroundStickers
//
//  Created by Faris Albalawi on 8/20/19.
//  Copyright © 2019 Faris Albalawi. All rights reserved.
//

import Foundation
import UIKit


protocol opacityViewDelegate {
    func opacityChanged(value: Float)
}

class opacityView: UIView {
    
    
    var opacityViewDelegate: opacityViewDelegate?
    
    private let opacitySlider: CustomSlider = {
        let opacitySlider = CustomSlider()
        opacitySlider.maximumValue = 1.0
        opacitySlider.minimumValue = 0
        opacitySlider.setValue(1.0, animated:true)
        opacitySlider.minimumTrackTintColor = barColor
        opacitySlider.maximumTrackTintColor = barColor
        opacitySlider.thumbTintColor = pinkColor
        opacitySlider.translatesAutoresizingMaskIntoConstraints = false
        opacitySlider.addTarget(self, action: #selector(opacityView.changeOpacityVlaue(_:)), for: .valueChanged)
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
        self.addSubview(opacitySlider)
        addSubview(labOpacity)
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
        self.opacityViewDelegate?.opacityChanged(value: sender.value)
        self.labOpacity.text = "\(round(sender.value * 100))%"
    }
}
