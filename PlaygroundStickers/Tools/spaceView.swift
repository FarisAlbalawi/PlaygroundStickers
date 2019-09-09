//
//  spaceView.swift
//  PlaygroundStickers
//
//  Created by Faris Albalawi on 9/8/19.
//  Copyright © 2019 Faris Albalawi. All rights reserved.
//

import UIKit


enum SpacingType {
    case lineSpacing
    case CharacterSpacing
}

protocol spaceViewDelegate {
    func spaceValueChanged(value: CGFloat, type: Bool)
}

class spaceView: UIView {
    
    var Delegate : spaceViewDelegate?
    var collectionView: UICollectionView!
    
    
    
    private let SpacingLine: UIButton = {
        let SpacingLine = UIButton()
        let image = UIImage(named: "spacing_Line")?.withRenderingMode(.alwaysTemplate)
        SpacingLine.setImage(image, for: .normal)
        SpacingLine.imageView?.contentMode = .scaleAspectFit
        SpacingLine.tintColor = ButtonColor
        SpacingLine.backgroundColor = barColor
        SpacingLine.layer.cornerRadius = 2
        SpacingLine.addTarget(self, action: #selector(spaceView.didPressSpacingLine), for: UIControl.Event.touchUpInside)
        SpacingLine.translatesAutoresizingMaskIntoConstraints = false
        
        return SpacingLine
    }()
    
    private let SpacingBetween: UIButton = {
        let SpacingBetween = UIButton()
        let image = UIImage(named: "spacing_between")?.withRenderingMode(.alwaysTemplate)
        SpacingBetween.setImage(image, for: .normal)
        SpacingBetween.imageView?.contentMode = .scaleAspectFit
        SpacingBetween.tintColor = yellowColor
        SpacingBetween.backgroundColor = barColor
        SpacingBetween.layer.cornerRadius = 2
        SpacingBetween.addTarget(self, action: #selector(spaceView.didPressSpacingBetween), for: UIControl.Event.touchUpInside)
        SpacingBetween.translatesAutoresizingMaskIntoConstraints = false
        return SpacingBetween
    }()
    
    
    fileprivate var orientation: UIDeviceOrientation {
        return UIDevice.current.orientation
    }
    
    
    private let screenSize = UIScreen.main.bounds.size

    var SpacingTypes = true
    var lastIndexOfBetween = 0
    var lastIndexOfLine = 0

    fileprivate var pageSize: CGSize {
        let layout =  UPCarouselFlowLayout()
        layout.sideItemAlpha = 0.3
        layout.sideItemScale = 0.7
        layout.itemSize = CGSize(width: 40, height: 40)
        layout.spacingMode = UPCarouselFlowLayoutSpacingMode.fixed(spacing: 10)
        layout.spacingMode = UPCarouselFlowLayoutSpacingMode.overlap(visibleOffset: 180)
        layout.scrollDirection = .horizontal
        self.collectionView!.collectionViewLayout = layout
        
        var pageSize = layout.itemSize
        if layout.scrollDirection == .horizontal {
            pageSize.width += layout.minimumLineSpacing
        } else {
            pageSize.height += layout.minimumLineSpacing
        }
        return pageSize
    }
    
    
    
    fileprivate var currentPage: Int = 0 {
        didSet {
            let indexPath = IndexPath(item: currentPage, section: 0)
            let scrollPosition: UICollectionView.ScrollPosition = orientation.isPortrait ? .centeredHorizontally : .centeredVertically
            self.collectionView.scrollToItem(at: indexPath, at: scrollPosition, animated: true)
            if SpacingTypes {
                lastIndexOfBetween = currentPage
                self.Delegate?.spaceValueChanged(value: CGFloat(currentPage), type: true)
            } else {
                
                 lastIndexOfLine = currentPage
                self.Delegate?.spaceValueChanged(value: CGFloat(currentPage), type: false)
            }
           
        }
    }
    
    

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    
    
    
    
    //initWithCode to init view from xib or storyboard
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }
    
    
    private func setupView() {
        
        
        let layout = UPCarouselFlowLayout()
        layout.sideItemAlpha = 0.3
        layout.sideItemScale = 0.7
        layout.itemSize = CGSize(width: 40, height: 40)
        layout.scrollDirection = .horizontal
        layout.spacingMode = UPCarouselFlowLayoutSpacingMode.fixed(spacing: 10)
        layout.spacingMode = UPCarouselFlowLayoutSpacingMode.overlap(visibleOffset: 180)
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        
        
        
        self.addSubview(collectionView)
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(spaceViewCell.self, forCellWithReuseIdentifier: "spaceViewCell")
        collectionView.backgroundColor = topColor
        
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.panGestureRecognizer.isEnabled = false
        
        
        
        
        self.addSubview(SpacingLine)
        self.addSubview(SpacingBetween)
        // let screenWidth = screenSize.width
        NSLayoutConstraint.activate([
            
            collectionView.topAnchor.constraint(equalTo: topAnchor),
            collectionView.leftAnchor.constraint(equalTo: leftAnchor),
            collectionView.rightAnchor.constraint(equalTo: rightAnchor),
            collectionView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            
            SpacingLine.heightAnchor.constraint(equalToConstant: 35),
            SpacingLine.widthAnchor.constraint(equalToConstant: 35),
            SpacingLine.centerYAnchor.constraint(equalTo: centerYAnchor),
            SpacingLine.leftAnchor.constraint(equalTo: leftAnchor, constant: 10),
            
            SpacingBetween.heightAnchor.constraint(equalToConstant: 35),
            SpacingBetween.widthAnchor.constraint(equalToConstant: 35),
            SpacingBetween.centerYAnchor.constraint(equalTo: centerYAnchor),
            SpacingBetween.leftAnchor.constraint(equalTo: leftAnchor, constant: 50),
            
            
            ])
    }
    
    
    
    @objc func didPressSpacingBetween() {
        SpacingBetween.tintColor = yellowColor
        SpacingLine.tintColor = ButtonColor
        SpacingTypes = true
        self.collectionView.scrollToItem(at:IndexPath(item: lastIndexOfBetween, section: 0), at: .right, animated: false)
        currentPage = lastIndexOfBetween
        self.collectionView.layoutIfNeeded()
    }
    
    @objc func didPressSpacingLine() {
        SpacingBetween.tintColor = ButtonColor
        SpacingLine.tintColor = yellowColor
        SpacingTypes = false
        currentPage = lastIndexOfLine
        self.collectionView.scrollToItem(at:IndexPath(item: lastIndexOfLine, section: 0), at: .right, animated: false)
        self.collectionView.layoutIfNeeded()
    }
    
    
}


extension spaceView: UICollectionViewDataSource {
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 100
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "spaceViewCell", for: indexPath) as? spaceViewCell
            else { return UICollectionViewCell() }
        
        
        cell.layer.backgroundColor = UIColor.clear.cgColor
        return cell
    }
    
    
}
extension spaceView: UICollectionViewDelegate {

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let layout = self.collectionView.collectionViewLayout as! UPCarouselFlowLayout
        let pageSide = (layout.scrollDirection == .horizontal) ? self.pageSize.width : self.pageSize.height
        let offset = (layout.scrollDirection == .horizontal) ? scrollView.contentOffset.x : scrollView.contentOffset.y
        currentPage = Int(floor((offset - pageSide / 2) / pageSide) + 1)
        let indexPath = IndexPath(item: currentPage, section: 0)
        
        
        let scrollPosition: UICollectionView.ScrollPosition = orientation.isPortrait ? .centeredHorizontally : .centeredVertically
        self.collectionView.scrollToItem(at: indexPath, at: scrollPosition, animated: false)
        self.collectionView.performBatchUpdates(nil, completion: {
            (result) in
            let cell = self.collectionView.cellForItem(at: indexPath)
            cell?.isSelected = true
        })
        

        
        collectionView.reloadData()
       
        
        
    }
    
    
}




class spaceViewCell: UICollectionViewCell {
    
    let lineView: UIView = {
        let lineView = UIView()
        lineView.backgroundColor = ButtonColor
        lineView.translatesAutoresizingMaskIntoConstraints = false
        return lineView
    }()
    
    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(lineView)
        
        
        NSLayoutConstraint.activate([
            
            lineView.widthAnchor.constraint(equalToConstant: 1),
            lineView.heightAnchor.constraint(equalToConstant: 30),
            lineView.centerXAnchor.constraint(equalTo: centerXAnchor),
            lineView.centerYAnchor.constraint(equalTo: centerYAnchor),
            
            ])
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}




extension UITextView {
    func addCharacterSpacing(_ spacing: CGFloat) {
        if let Text = text, Text.count > 0 {
            let attributedString = NSMutableAttributedString(string: Text)
            attributedString.addAttribute(NSAttributedString.Key.kern, value: spacing, range: NSRange(location: 0, length: attributedString.length - 1))
            attributedText = attributedString
        }
    }
}

//extension UITextView{
//    func setCharacterSpacing(_ spacing: CGFloat){
//        let attributedStr = NSMutableAttributedString(string: self.text ?? "")
//        attributedStr.addAttribute(NSAttributedString.Key.kern, value: spacing, range: NSMakeRange(0, attributedStr.length))
//        self.attributedText = attributedStr
//    }
//}
//
//extension UITextView{
//    func addTextSpacing(_ spacing: CGFloat){
//        let attributedString = NSMutableAttributedString(string: text!)
//        attributedString.addAttribute(NSAttributedString.Key.kern, value: spacing, range: NSRange(location: 0, length: text!.count))
//        attributedString.addAttribute(NSAttributedString.Key(rawValue: "\(String(describing: self.font?.lineHeight))"), value: 50, range: NSRange(location: 0, length: text!.count))
//        attributedText = attributedString
//    }
//}
