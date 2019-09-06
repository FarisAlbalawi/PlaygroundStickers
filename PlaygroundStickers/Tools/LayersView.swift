//
//  LayersView.swift
//  PlaygroundStickers
//
//  Created by Faris Albalawi on 8/16/19.
//  Copyright © 2019 Faris Albalawi. All rights reserved.
//

import UIKit

protocol LayersViewDelegate {
    func LayerTapped(index: Int)
    func LayerRemoved(index: Int)
    func LayerMoved(view: [UIView])
    func HideView(hide: Bool)
}



class LayersView: UIView {
    
    var collectionView: UICollectionView!
    var LayersViewDelegate : LayersViewDelegate?
    var longPressedEnabled = Bool()
    
    var LayersArray = [UIView]()
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    private let headerView: UIView = {
        let headerView = UIView()
        headerView.backgroundColor = topColor
        headerView.translatesAutoresizingMaskIntoConstraints = false
        return headerView
    }()
    
    
     let HideButton: UIButton = {
        let HideButton = UIButton()
        HideButton.setTitle("▲ Show Layers", for: .normal)
        HideButton.setTitleColor(blueColor, for: .normal)
        HideButton.addTarget(self, action: #selector(didPressButton(_:)), for: .touchUpInside)
        HideButton.translatesAutoresizingMaskIntoConstraints = false
        
        return HideButton
    }()
    
    
    private let DoneButton: UIButton = {
        let DoneButton = UIButton()
        DoneButton.setTitle("Done", for: .normal)
        DoneButton.setTitleColor(.white, for: .normal)
        DoneButton.backgroundColor = redColor
        DoneButton.layer.cornerRadius = 25 / 2
        DoneButton.addTarget(self, action: #selector(ddidPresDone(_:)), for: .touchUpInside)
        DoneButton.translatesAutoresizingMaskIntoConstraints = false
        
        return DoneButton
    }()
    
    
    
    
    var isHiddenOrShowing = false
    
    private let screenSize = UIScreen.main.bounds.size
    
    
    var DoneButtonRight = NSLayoutConstraint()
    //initWithCode to init view from xib or storyboard
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
        
    }
    
    private func setupView() {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 80, height: 80)
        layout.minimumLineSpacing = 10
        layout.scrollDirection = .horizontal
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        
        self.addSubview(headerView)
        self.headerView.addSubview(HideButton)
         self.headerView.addSubview(DoneButton)
        self.addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        DoneButton.isHidden = true
        
      
        self.DoneButtonRight = DoneButton.rightAnchor.constraint(equalTo: headerView.rightAnchor, constant: 80)
        NSLayoutConstraint.activate([
            headerView.heightAnchor.constraint(equalToConstant: 35),
            headerView.topAnchor.constraint(equalTo: topAnchor),
            headerView.leftAnchor.constraint(equalTo: leftAnchor),
            headerView.rightAnchor.constraint(equalTo: rightAnchor),
            
            HideButton.heightAnchor.constraint(equalToConstant: 20),
            HideButton.widthAnchor.constraint(equalToConstant: 200),
            HideButton.centerYAnchor.constraint(equalTo: headerView.centerYAnchor),
            HideButton.centerXAnchor.constraint(equalTo: headerView.centerXAnchor),
            
            DoneButton.heightAnchor.constraint(equalToConstant: 25),
            DoneButton.widthAnchor.constraint(equalToConstant: 60),
            DoneButton.centerYAnchor.constraint(equalTo: headerView.centerYAnchor),
            DoneButtonRight,
            
            
            collectionView.topAnchor.constraint(equalTo: headerView.bottomAnchor),
            collectionView.leftAnchor.constraint(equalTo: leftAnchor),
            collectionView.rightAnchor.constraint(equalTo: rightAnchor),
            collectionView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
              ])
            
      
        
        collectionView.register(LayersCell.self, forCellWithReuseIdentifier: "LayersCell")
        collectionView.backgroundColor = barColor
        
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.dragInteractionEnabled = true
        
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.contentInset = UIEdgeInsets(top: 0,left: 14,bottom: 0,right: 14)
        collectionView.reloadData()
        
        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(self.longTap(_:)))
        collectionView.addGestureRecognizer(longPressGesture)
        
        
        
        
    }
    
    @objc func longTap(_ gesture: UIGestureRecognizer){
        
        switch(gesture.state) {
        case .began:
            guard let selectedIndexPath = collectionView.indexPathForItem(at: gesture.location(in: collectionView)) else {
                return
            }
            collectionView.beginInteractiveMovementForItem(at: selectedIndexPath)
        case .changed:
            collectionView.updateInteractiveMovementTargetPosition(gesture.location(in: gesture.view!))
        case .ended:
            collectionView.endInteractiveMovement()
            // doneBtn.isHidden = false
            longPressedEnabled = true
            self.collectionView.reloadData()
        default:
            collectionView.cancelInteractiveMovement()
        }
    }
    
    
    @objc func didPressButton(_ sender: UIButton) {
        if #available(iOS 10.0, *) {
            let generator = UIImpactFeedbackGenerator(style: .medium)
            generator.impactOccurred()
        }
        
        
        longPressedEnabled = false
        self.collectionView.reloadData()
        self.DoneButtonRight.constant = 80
        UIView.animate(withDuration: 0.5, animations: {
            self.headerView.layoutIfNeeded()
        }, completion: {finished in
            self.DoneButton.isHidden = true
        })
        
        
        if isHiddenOrShowing == false {
             HideButton.setTitle("▼ Hide Layers", for: .normal)
             self.isHiddenOrShowing = true
             self.LayersViewDelegate?.HideView(hide: true)
        } else {
             HideButton.setTitle("▲ Show Layers", for: .normal)
            self.isHiddenOrShowing = false
            self.LayersViewDelegate?.HideView(hide: false)
            
        }
       
    
    }
    
    @objc func ddidPresDone(_ sender: UIButton) {
        //disable the shake and hide done button
        longPressedEnabled = false
        self.collectionView.reloadData()
    }

    
    
}

extension LayersView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if LayersArray.count == 0 {
            return 1
        } else {
            return LayersArray.count
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "LayersCell", for: indexPath) as? LayersCell
            else { return UICollectionViewCell() }
        
        if LayersArray.count == 0 {
        
            longPressedEnabled = false
            cell.lab.isHidden = true
            cell.img.isHidden = true
            cell.removeBtn.isHidden = true
            self.DoneButtonRight.constant = 80
            UIView.animate(withDuration: 0.5, animations: {
                self.headerView.layoutIfNeeded()
            }, completion: {finished in
                self.DoneButton.isHidden = true
            })
            
        } else {
            cell.img.isHidden = false
            cell.removeBtn.isHidden = false
            let array = LayersArray[indexPath.row]
            if array is UIImageView {
                if let views = LayersArray[indexPath.row] as? UIImageView {
                    
                    cell.img.image = views.image
                    cell.img.isHidden = false
                    cell.lab.isHidden = true
                }
            } else {
                if let textview = LayersArray[indexPath.row] as? UITextView {
                    
                    cell.lab.text = textview.text
                    cell.lab.isHidden = false
                    cell.img.isHidden = true
                }
            }
            
            cell.removeBtn.tag = indexPath.row
            cell.removeBtn.addTarget(self, action: #selector(removeBtnClick(_:)), for: .touchUpInside)
            
            if longPressedEnabled {
                cell.startAnimate()
               self.DoneButton.isHidden = false
               self.DoneButtonRight.constant = -10
                UIView.animate(withDuration: 0.5, animations: {
                    self.headerView.layoutIfNeeded()
                }, completion: {finished in
                    
                })
                
            }else{
                cell.stopAnimate()
                
                 self.DoneButtonRight.constant = 80
                UIView.animate(withDuration: 0.5, animations: {
                    self.headerView.layoutIfNeeded()
                }, completion: {finished in
                    self.DoneButton.isHidden = true
                })
                
                
               
            }
            
         
           
        }
        
        cell.layer.cornerRadius = 4
        cell.backgroundColor = topColor
    
         return cell
    }
    
    @IBAction func removeBtnClick(_ sender: UIButton)   {
     
        self.LayersArray.remove(at: sender.tag)
        self.LayersViewDelegate?.LayerRemoved(index: sender.tag)
        self.collectionView.reloadData()
    }
    
}
extension LayersView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if LayersArray.count != 0 {
             self.LayersViewDelegate?.LayerTapped(index: indexPath.row)
        }
      
        
        
    }
    
    func collectionView(_ collectionView: UICollectionView, canMoveItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func collectionView(_ collectionView: UICollectionView, moveItemAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        print("From :- \(sourceIndexPath.item)")
        print("to :- \(destinationIndexPath.item)")
        
        
        let item = LayersArray.remove(at: sourceIndexPath.item)
        LayersArray.insert(item, at: destinationIndexPath.item)

        
        
        self.LayersViewDelegate?.LayerMoved(view: LayersArray)
        
    }
    
}




class LayersCell: UICollectionViewCell {
    let img: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let lab: UILabel = {
        let lab = UILabel()
        lab.sizeToFit()
        lab.textAlignment = .center
        lab.textColor = ButtonColor
        lab.translatesAutoresizingMaskIntoConstraints = false
        return lab
    }()
    
    
    override var isSelected: Bool{
        didSet{
            if self.isSelected
            {
                self.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
                
                
            }
            else
            {
                self.transform = CGAffineTransform.identity
                
            }
        }
    }
    
    
    
    let removeBtn: UIButton = {
        let removeBtn = UIButton()
        let image = UIImage(named: "remove")
        removeBtn.setImage(image, for: .normal)
        removeBtn.imageView?.contentMode = .scaleAspectFit
        removeBtn.translatesAutoresizingMaskIntoConstraints = false
        return removeBtn
    }()
    
    
    
    var isAnimate: Bool! = true
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(img)
        addSubview(lab)
        
        addSubview(removeBtn)
        
        
        NSLayoutConstraint.activate([
            img.widthAnchor.constraint(equalToConstant: 40),
            img.heightAnchor.constraint(equalToConstant: 40),
            img.centerXAnchor.constraint(equalTo: centerXAnchor),
            img.centerYAnchor.constraint(equalTo: centerYAnchor),
            
            lab.widthAnchor.constraint(equalToConstant: 40),
            lab.heightAnchor.constraint(equalToConstant: 40),
            lab.centerXAnchor.constraint(equalTo: centerXAnchor),
            lab.centerYAnchor.constraint(equalTo: centerYAnchor),
            
            
            removeBtn.heightAnchor.constraint(equalToConstant: 20),
            removeBtn.widthAnchor.constraint(equalToConstant: 20),
            removeBtn.topAnchor.constraint(equalTo: topAnchor,constant: 0),
            removeBtn.rightAnchor.constraint(equalTo: rightAnchor, constant: 0),
            
            
            
            ])
        
    }
    
    
    //Animation of image
    func startAnimate() {
        isSelected = false
        let shakeAnimation = CABasicAnimation(keyPath: "transform.rotation")
        shakeAnimation.duration = 0.05
        shakeAnimation.repeatCount = 4
        shakeAnimation.autoreverses = true
        shakeAnimation.duration = 0.2
        shakeAnimation.repeatCount = 99999
        
        let startAngle: Float = (-2) * 3.14159/180
        let stopAngle = -startAngle
        
        shakeAnimation.fromValue = NSNumber(value: startAngle as Float)
        shakeAnimation.toValue = NSNumber(value: 3 * stopAngle as Float)
        shakeAnimation.autoreverses = true
        shakeAnimation.timeOffset = 290 * drand48()
        
        let layer: CALayer = self.layer
        layer.add(shakeAnimation, forKey:"animate")
        removeBtn.isHidden = false
        isAnimate = true
    }
    
    func stopAnimate() {
        let layer: CALayer = self.layer
        layer.removeAnimation(forKey: "animate")
        isAnimate = false
        self.removeBtn.isHidden = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
