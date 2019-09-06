//
//  EmojisVC.swift
//  PlaygroundStickers
//
//  Created by Faris Albalawi on 8/30/19.
//  Copyright © 2019 Faris Albalawi. All rights reserved.
//

import UIKit

 protocol EmojiDelegate {
    func EmojiTapped(EmojiName: String)
}

class EmojisVC: UIViewController, UIGestureRecognizerDelegate {

    var collectionView: UICollectionView!
    var headerView = UIView()
    var holdView = UIView()
    var scrollView = UIScrollView()
    
    var delegate : EmojiDelegate?
    
    let emojiRanges = [
        0x1F601...0x1F64F,
        0x1F30D...0x1F567,
        0x1F680...0x1F6C0,
        0x1F681...0x1F6C5
    ]
    
    var emojis: [String] = []
    

    
    let screenSize = UIScreen.main.bounds.size
    
    let fullView: CGFloat = 100 // remainder of screen height
    var partialView: CGFloat {
        return UIScreen.main.bounds.height - 380
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        for range in emojiRanges {
            for i in range {
                let c = String(describing: UnicodeScalar(i)!)
                emojis.append(c)
            }
        }
        
        
        configureCollectionViews()
        
        self.scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.isPagingEnabled = true
        scrollView.delegate = self
        self.view.addSubview(scrollView)
        
        
        // headerView
        self.view.backgroundColor = barColor
        self.headerView.backgroundColor = .clear
        self.holdView.backgroundColor = blueColor
        holdView.layer.cornerRadius = 3
        
        
        self.headerView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(headerView)
        self.headerView.addSubview(holdView)
        self.holdView.translatesAutoresizingMaskIntoConstraints = false
        
        
        // *** Autolayout header View / hold View / pageControl
        NSLayoutConstraint.activate([
            
            headerView.heightAnchor.constraint(equalToConstant: 20),
            headerView.widthAnchor.constraint(equalToConstant: self.view.frame.width),
            
            holdView.heightAnchor.constraint(equalToConstant: 5),
            holdView.widthAnchor.constraint(equalToConstant: 50),
            
            holdView.centerXAnchor.constraint(equalTo: self.headerView.centerXAnchor),
            holdView.centerYAnchor.constraint(equalTo: self.headerView.centerYAnchor),
            
            ])
        
        // *** Autolayout scrollView
        NSLayoutConstraint.activate([
            self.scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            self.scrollView.topAnchor.constraint(equalTo: view.topAnchor, constant: 30),
            self.scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            self.scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
            ])
        
        
        scrollView.contentSize = CGSize(width: screenSize.width,
                                        height: scrollView.frame.size.height)
        
        let gesture = UIPanGestureRecognizer.init(target: self, action: #selector(shapeView.panGesture))
        gesture.delegate = self
        view.addGestureRecognizer(gesture)
        
        
        
    
        // Do any additional setup after loading the view.
    }
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionView.frame = CGRect(x: 0,
                                      y: 0,
                                      width: UIScreen.main.bounds.width,
                                      height: view.frame.height - 40)
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        UIView.animate(withDuration: 0.6) { [weak self] in
            guard let `self` = self else { return }
            let frame = self.view.frame
            let yComponent = self.partialView
            self.view.frame = CGRect(x: 0,
                                     y: yComponent,
                                     width: frame.width,
                                     height: UIScreen.main.bounds.height - self.partialView)
        }
    }
    
    override open func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    func configureCollectionViews() {
        
        
        let emojisFrame = CGRect(x: scrollView.frame.size.width,
                                 y: 0,
                                 width: UIScreen.main.bounds.width,
                                 height: view.frame.height - 40)
        
        let emojislayout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        emojislayout.sectionInset = UIEdgeInsets(top: 20, left: 10, bottom: 10, right: 10)
        emojislayout.itemSize = CGSize(width: 60, height: 60)
        
        collectionView = UICollectionView(frame: emojisFrame, collectionViewLayout: emojislayout)
        collectionView.backgroundColor = .clear
        scrollView.addSubview(collectionView)
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView?.register(EmojiCell.self, forCellWithReuseIdentifier: "cell")

        
     
        
        
    }
    

    
    //MARK: Pan Gesture
    
    @objc func panGesture(_ recognizer: UIPanGestureRecognizer) {
        
        let translation = recognizer.translation(in: self.view)
        let velocity = recognizer.velocity(in: self.view)
        
        let y = self.view.frame.minY
        if y + translation.y >= fullView {
            let newMinY = y + translation.y
            self.view.frame = CGRect(x: 0, y: newMinY, width: view.frame.width, height: UIScreen.main.bounds.height - newMinY )
            self.view.layoutIfNeeded()
            recognizer.setTranslation(CGPoint.zero, in: self.view)
        }
        
        if recognizer.state == .ended {
            var duration =  velocity.y < 0 ? Double((y - fullView) / -velocity.y) : Double((partialView - y) / velocity.y )
            duration = duration > 1.3 ? 1 : duration
            //velocity is direction of gesture
            UIView.animate(withDuration: duration, delay: 0.0, options: [.allowUserInteraction], animations: {
                if  velocity.y >= 0 {
                    if y + translation.y >= self.partialView  {
                        self.removeBottomSheetView()
                    } else {
                        self.view.frame = CGRect(x: 0, y: self.partialView, width: self.view.frame.width, height: UIScreen.main.bounds.height - self.partialView)
                        self.view.layoutIfNeeded()
                    }
                } else {
                    if y + translation.y >= self.partialView  {
                        self.view.frame = CGRect(x: 0, y: self.partialView, width: self.view.frame.width, height: UIScreen.main.bounds.height - self.partialView)
                        self.view.layoutIfNeeded()
                    } else {
                        self.view.frame = CGRect(x: 0, y: self.fullView, width: self.view.frame.width, height: UIScreen.main.bounds.height - self.fullView)
                        self.view.layoutIfNeeded()
                    }
                }
                
            }, completion: nil)
        }
    }
    
    func removeBottomSheetView() {
        UIView.animate(withDuration: 0.3,
                       delay: 0,
                       options: UIView.AnimationOptions.curveEaseIn,
                       animations: { () -> Void in
                        var frame = self.view.frame
                        frame.origin.y = UIScreen.main.bounds.maxY
                        self.view.frame = frame
                        
        }, completion: { (finished) -> Void in
            self.view.removeFromSuperview()
            self.removeFromParent()
        })
    }



}


extension EmojisVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return emojis.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
         let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! EmojiCell
        
        cell.emojiLabel.text = emojis[indexPath.row]
        
        
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate!.EmojiTapped(EmojiName: emojis[indexPath.row])
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
}



class EmojiCell: UICollectionViewCell {
    var emojiLabel = UILabel()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.emojiLabel.sizeToFit()
        self.emojiLabel.font = emojiLabel.font.withSize(50)
        self.emojiLabel.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(self.emojiLabel)
        
        let constraints = [
            
            emojiLabel.topAnchor.constraint(equalTo: topAnchor, constant: 1),
            emojiLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -1),
            emojiLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: -1),
            emojiLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 1),
            
            ]
        
        NSLayoutConstraint.activate(constraints)
        
    }
    
    
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        //        fatalError("init(coder:) has not been implemented")
    }
}


