//
//  helper.swift
//  PlaygroundStickers
//
//  Created by Faris Albalawi on 8/20/19.
//  Copyright © 2019 Faris Albalawi. All rights reserved.
//

import Foundation
import UIKit


let backgroundColor = UIColor(red: 0.1569, green: 0.1725, blue: 0.2039, alpha: 1.0)
let barColor = UIColor(red: 0.1294, green: 0.1451, blue: 0.1686, alpha: 1.0)
let sideColor = UIColor(red: 0.2, green: 0.2196, blue: 0.2588, alpha: 1.0)
let pinkColor = UIColor(red: 0.5059, green: 0.3412, blue: 0.5765, alpha: 1.0)
let redColor = UIColor(red: 0.7529, green: 0.3804, blue: 0.4157, alpha: 1.0)
let greenColor = UIColor(red: 0.5961, green: 0.7647, blue: 0.4745, alpha: 1.0)
let yellowColor = UIColor(red: 0.9412, green: 0.7373, blue: 0.3686, alpha: 1.0)
let blueColor = UIColor(red: 0.3373, green: 0.5843, blue: 0.7922, alpha: 1.0)
let ButtonColor = UIColor(red: 0.5843, green: 0.6157, blue: 0.6706, alpha: 1.0)
let topColor = UIColor(red: 0.1725, green: 0.1922, blue: 0.2275, alpha: 1.0)


extension UIButton {
    open override var isEnabled: Bool{
        didSet {
            alpha = isEnabled ? 1.0 : 0.5
        }
    }
}
