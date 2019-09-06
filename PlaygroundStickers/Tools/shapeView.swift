//
//  shapeView.swift
//  PlaygroundStickers
//
//  Created by Faris Albalawi on 8/11/19.
//  Copyright © 2019 Faris Albalawi. All rights reserved.
//




import UIKit


protocol shapeDelegate {
    func shapeTapped(image: UIImage)
}

class shapeView: UIViewController, UIGestureRecognizerDelegate{
    
    
    
    var shapesDelegate : shapeDelegate?
    
    var collectionView: UICollectionView!
    
    
    var array =  Array(1...45)
    var headerView = UIView()
    var holdView = UIView()
    var scrollView = UIScrollView()
    
    let screenSize = UIScreen.main.bounds.size
    
    let fullView: CGFloat = 95 // remainder of screen height
    var partialView: CGFloat {
        return 95
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    
    func configureCollectionViews() {
        
        let frame = CGRect(x: 0,
                           y: 0,
                           width: UIScreen.main.bounds.width,
                           height: view.frame.height - 40)
        
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
     
        let width = (CGFloat) ((screenSize.width - 30) / 3.0)
        layout.itemSize = CGSize(width: width, height: 100)
        
        collectionView = UICollectionView(frame: frame, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        scrollView.addSubview(collectionView)
       
        collectionView.delegate = self
        collectionView.dataSource = self
        
        
        self.collectionView.register(shapeCell.self, forCellWithReuseIdentifier: "Cell")
        
        
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
    
    
    
    
    

    
}



extension shapeView {
    

    
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


// MARK: - UICollectionViewDataSource
extension shapeView: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return array.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! shapeCell
        
        cell.img.image = UIImage(named: "\(array[indexPath.row])")
        cell.img.image = cell.img.image?.withRenderingMode(.alwaysTemplate)
        cell.img.tintColor = ButtonColor
        
        cell.backgroundColor = topColor
        cell.layer.cornerRadius = 4
      
        return cell
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let image = UIImage(named: "\(array[indexPath.row])")
     
        self.shapesDelegate?.shapeTapped(image: image!)
     
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = self.view.frame.width * 0.32
        return CGSize(width: width, height: 120)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 2.5
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
}



class shapeCell: UICollectionViewCell {
    
    
    let img: UIImageView = {
        let img = UIImageView()
        img.contentMode = .scaleAspectFit
        img.backgroundColor = .clear
        img.clipsToBounds=true
        img.translatesAutoresizingMaskIntoConstraints = false
        return img
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        img.contentMode = .scaleAspectFit
        
        self.addSubview(img)
        img.widthAnchor.constraint(equalToConstant: 80).isActive = true
        img.heightAnchor.constraint(equalToConstant: 80).isActive = true
        img.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        img.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
