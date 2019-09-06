//
//  CropViewController.swift
//  PlaygroundStickers
//
//  Created by Faris Albalawi on 8/29/19.
//  Copyright © 2019 Faris Albalawi. All rights reserved.
//

import UIKit

protocol PhotosDelegate {
    func photoTapped(image: UIImage)
}

class CropViewController: UIViewController {

    
    
    
    let cropPickerViews: CropPickerView = {
        let cropPickerViews = CropPickerView()
        cropPickerViews.translatesAutoresizingMaskIntoConstraints = false
        cropPickerViews.backgroundColor = topColor
        cropPickerViews.cropLineColor = UIColor.gray
        cropPickerViews.scrollBackgroundColor = topColor
        cropPickerViews.imageBackgroundColor = topColor
        cropPickerViews.dimBackgroundColor = UIColor(white: 0, alpha: 0.5)
        cropPickerViews.scrollMinimumZoomScale = 1
        cropPickerViews.scrollMaximumZoomScale = 2
        return cropPickerViews
    }()
    
    
    let BottomView: UIView = {
        let BottomView = UIView()
        BottomView.translatesAutoresizingMaskIntoConstraints = false
        BottomView.backgroundColor = backgroundColor
       
        return BottomView
    }()
    
    private let DoneButton: UIButton = {
        let DoneButton = UIButton()
        DoneButton.setTitle("Next", for: .normal)
        DoneButton.setTitleColor(.white, for: .normal)
        DoneButton.backgroundColor = blueColor
        DoneButton.layer.cornerRadius = 28 / 2
        DoneButton.addTarget(self, action: #selector(CropViewController.didPressDone), for: UIControl.Event.touchUpInside)
        DoneButton.translatesAutoresizingMaskIntoConstraints = false
        
        return DoneButton
    }()
    
    private let cancelButton: UIButton = {
        let cancel = UIButton()
        cancel.setTitle("Cancel", for: .normal)
        cancel.setTitleColor(.white, for: .normal)
        cancel.backgroundColor = redColor
        cancel.layer.cornerRadius = 28 / 2
        cancel.addTarget(self, action: #selector(CropViewController.didPressCancel), for: UIControl.Event.touchUpInside)
        cancel.translatesAutoresizingMaskIntoConstraints = false
        return cancel
    }()
    
    private let Titlelab: UILabel = {
        let Titlelab = UILabel()
        Titlelab.font = UIFont(name: "Futura-Medium", size: 20)!
        Titlelab.text = "Crop Image"
        Titlelab.textColor = ButtonColor
        Titlelab.translatesAutoresizingMaskIntoConstraints = false
        return Titlelab
    }()
    
    
    var imageForCrop = UIImage()
     var photoDelegate : PhotosDelegate?
    
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return .lightContent
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.cropPickerViews.image = imageForCrop
        self.cropPickerViews.delegate = self
        view.addSubview(cropPickerViews)
        view.addSubview(BottomView)
        BottomView.addSubview(cancelButton)
        BottomView.addSubview(DoneButton)
        BottomView.addSubview(Titlelab)
        NSLayoutConstraint.activate([
            
            // layout
            BottomView.heightAnchor.constraint(equalToConstant: 50),
            BottomView.widthAnchor.constraint(equalToConstant: self.view.frame.size.width),
            BottomView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            
            cropPickerViews.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            cropPickerViews.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            cropPickerViews.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            cropPickerViews.bottomAnchor.constraint(equalTo: BottomView.topAnchor),
            
            cancelButton.heightAnchor.constraint(equalToConstant: 28),
            cancelButton.widthAnchor.constraint(equalToConstant: 75),
            cancelButton.centerYAnchor.constraint(equalTo: BottomView.centerYAnchor),
            cancelButton.leftAnchor.constraint(equalTo: BottomView.leftAnchor, constant: 10),
            
            DoneButton.heightAnchor.constraint(equalToConstant: 28),
            DoneButton.widthAnchor.constraint(equalToConstant: 75),
            DoneButton.centerYAnchor.constraint(equalTo: BottomView.centerYAnchor),
            DoneButton.rightAnchor.constraint(equalTo: BottomView.rightAnchor, constant: -10),
            
            Titlelab.centerYAnchor.constraint(equalTo: BottomView.centerYAnchor),
            Titlelab.centerXAnchor.constraint(equalTo: BottomView.centerXAnchor),
           
            ])
      
        
       self.view.backgroundColor = backgroundColor
        
    }
    
    
    @objc func didPressDone() {
        self.cropPickerViews.crop { (error, image) in
            if let error = (error as NSError?) {
                let alertController = UIAlertController(title: "Error", message: error.domain, preferredStyle: .alert)
                alertController.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
                self.present(alertController, animated: true, completion: nil)
                return
            }
            self.view.window!.rootViewController?.dismiss(animated: true, completion: nil)
           self.photoDelegate?.photoTapped(image: image!)
        }
        
    }
    
    @objc func didPressCancel() {
      self.dismiss(animated: true, completion: nil)
        
    }

}

// MARK: CropPickerViewDelegate
extension CropViewController: CropPickerViewDelegate {
    func cropPickerView(_ cropPickerView: CropPickerView, error: Error) {
        
    }
    func cropPickerView(_ cropPickerView: CropPickerView, image: UIImage) {
        
    }
}
