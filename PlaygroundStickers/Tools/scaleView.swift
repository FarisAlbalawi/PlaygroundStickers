//
//  scaleView.swift
//  PlaygroundStickers
//
//  Created by Faris Albalawi on 9/6/19.
//  Copyright © 2019 Faris Albalawi. All rights reserved.
//



import UIKit


protocol scaleViewDelegate {
    func scaleChanged(value: CGFloat)
}

class scaleView: UIView {
    
    var Delegate : scaleViewDelegate?
    var collectionView: UICollectionView!

    
    
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
    

    fileprivate var orientation: UIDeviceOrientation {
        return UIDevice.current.orientation
    }
    
    
    private let screenSize = UIScreen.main.bounds.size
    
    
    var numberOfScrolling: Int = 0
    var lastContentOffset: CGFloat = 0.0
    
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
        collectionView.register(scaleCell.self, forCellWithReuseIdentifier: "scaleCell")
        collectionView.backgroundColor = topColor
        
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.panGestureRecognizer.isEnabled = false
    
      
        
        
        self.addSubview(plusButton)
        self.addSubview(minusButton)
        // let screenWidth = screenSize.width
        NSLayoutConstraint.activate([
         
            collectionView.topAnchor.constraint(equalTo: topAnchor),
            collectionView.leftAnchor.constraint(equalTo: leftAnchor),
            collectionView.rightAnchor.constraint(equalTo: rightAnchor),
            collectionView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            
            minusButton.heightAnchor.constraint(equalToConstant: 35),
            minusButton.widthAnchor.constraint(equalToConstant: 35),
            minusButton.centerYAnchor.constraint(equalTo: centerYAnchor),
            minusButton.leftAnchor.constraint(equalTo: leftAnchor, constant: 10),
            
            plusButton.heightAnchor.constraint(equalToConstant: 35),
            plusButton.widthAnchor.constraint(equalToConstant: 35),
            plusButton.centerYAnchor.constraint(equalTo: centerYAnchor),
            plusButton.rightAnchor.constraint(equalTo: rightAnchor, constant: -10),
            
            
            ])
    }
    
    
    
    @objc func didPressPlusButton() {
        currentPage += 1
    
     self.Delegate?.scaleChanged(value: 1+0.01)
    }
    
    @objc func didPressMinusButton() {
        currentPage -= 1
         self.Delegate?.scaleChanged(value: 1-0.01)
    }
    
    
}


extension scaleView: UICollectionViewDataSource {

    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1000
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "scaleCell", for: indexPath) as? scaleCell
            else { return UICollectionViewCell() }
        

        cell.layer.backgroundColor = UIColor.clear.cgColor
        return cell
    }
   
    
}
extension scaleView: UICollectionViewDelegate {

    
    
  
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        print(indexPath.row)
        self.numberOfScrolling += 1
      
    }
    
    
    
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
         lastContentOffset = scrollView.contentOffset.x
    }
    
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
        
        if (self.lastContentOffset < scrollView.contentOffset.x) {
            let v = Float(numberOfScrolling) * 0.01
            self.Delegate?.scaleChanged(value: CGFloat(1+v))
        } else if (self.lastContentOffset > scrollView.contentOffset.x) {
            let v = Float(numberOfScrolling) * 0.01
            self.Delegate?.scaleChanged(value: CGFloat(1-v))
        } else {
            // didn't move
        }
    
    
        collectionView.reloadData()
        self.numberOfScrolling = 0
        
    
   
    }
    

}




class scaleCell: UICollectionViewCell {
    
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
