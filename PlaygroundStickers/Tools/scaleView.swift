//
//  scaleView.swift
//  PlaygroundStickers
//
//  Created by Faris Albalawi on 9/6/19.
//  Copyright © 2019 Faris Albalawi. All rights reserved.
//



import UIKit



protocol scaleViewDelegate {
    func scaleChanged(value: Double)
}

class scaleView: UIView {
    
    var Delegate : scaleViewDelegate?
    
    private let slider: HorizontalDial = {
        let slider = HorizontalDial()
        slider.maximumValue = 3
        slider.minimumValue = 0.000001
        slider.value = 0
        slider.tick = 1
        slider.centerMarkWidth = 0
        slider.centerMarkRadius = 0
        slider.markColor = ButtonColor
        slider.markWidth = 1
        slider.markCount = 20
        slider.enableRange = false
        slider.centerMarkHeightRatio = 1
        slider.padding = 14
        slider.translatesAutoresizingMaskIntoConstraints = false
        slider.backgroundColor = UIColor.clear
        
        return slider
    }()
    
    
    private let plusButton: UIButton = {
        let plusButton = UIButton()
        let image = UIImage(named: "plus")?.withRenderingMode(.alwaysTemplate)
        plusButton.setImage(image, for: .normal)
        plusButton.imageView?.contentMode = .scaleAspectFit
        plusButton.tintColor = blueColor
        plusButton.addTarget(self, action: #selector(scaleView.didPressPlusButton), for: UIControl.Event.touchUpInside)
        plusButton.translatesAutoresizingMaskIntoConstraints = false
        
        return plusButton
    }()
    
    private let minusButton: UIButton = {
        let minusButton = UIButton()
        let image = UIImage(named: "minus")?.withRenderingMode(.alwaysTemplate)
        minusButton.setImage(image, for: .normal)
        minusButton.imageView?.contentMode = .scaleAspectFit
        minusButton.tintColor = blueColor
        minusButton.addTarget(self, action: #selector(scaleView.didPressMinusButton), for: UIControl.Event.touchUpInside)
        minusButton.translatesAutoresizingMaskIntoConstraints = false
        return minusButton
    }()
    

    
    
    private let screenSize = UIScreen.main.bounds.size
    
    

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        slider.delegate = self
        
    }
    
    
    //initWithCode to init view from xib or storyboard
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }
    
    private func setupView() {
        self.addSubview(slider)
          self.addSubview(plusButton)
          self.addSubview(minusButton)
        NSLayoutConstraint.activate([
            slider.leadingAnchor.constraint(equalTo: leadingAnchor),
            slider.trailingAnchor.constraint(equalTo: trailingAnchor),
            slider.topAnchor.constraint(equalTo: topAnchor),
            slider.bottomAnchor.constraint(equalTo: bottomAnchor,constant: 0),
         
            minusButton.heightAnchor.constraint(equalToConstant: 30),
            minusButton.widthAnchor.constraint(equalToConstant: 30),
            minusButton.centerYAnchor.constraint(equalTo: centerYAnchor),
            minusButton.leftAnchor.constraint(equalTo: leftAnchor, constant: 10),
            
            plusButton.heightAnchor.constraint(equalToConstant: 30),
            plusButton.widthAnchor.constraint(equalToConstant: 30),
            plusButton.centerYAnchor.constraint(equalTo: centerYAnchor),
            plusButton.rightAnchor.constraint(equalTo: rightAnchor, constant: -10),
            
            
            ])
    }
    
    
    
    @objc func didPressPlusButton() {
    
    }
    
    @objc func didPressMinusButton() {
        
    }
    
    
}

extension scaleView: HorizontalDialDelegate {
    func horizontalDialDidValueChanged(_ horizontalDial: HorizontalDial) {
        let degrees = horizontalDial.value
        self.Delegate?.scaleChanged(value: degrees)
        
        
    }
}
