//
//  shadowTools.swift
//  PlaygroundStickers
//
//  Created by Faris Albalawi on 8/26/19.
//  Copyright © 2019 Faris Albalawi. All rights reserved.
//


import UIKit

protocol shadowToolsDelegate {
    func shadowToolsTapped(Index: Int)
    
}

class shadowTools: UIView {
    
    var collectionView: UICollectionView!
    var Delegate : shadowToolsDelegate?
    
    fileprivate var pageSize: CGSize {
        let layout =  UPCarouselFlowLayout()
        layout.sideItemAlpha = 0.3
        layout.sideItemScale = 0.7
        layout.itemSize = CGSize(width: 80, height: 40)
        layout.spacingMode = UPCarouselFlowLayoutSpacingMode.fixed(spacing: 10)
        layout.spacingMode = UPCarouselFlowLayoutSpacingMode.overlap(visibleOffset: 130)
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
            self.Delegate?.shadowToolsTapped(Index: currentPage)
        }
    }
    
    fileprivate var orientation: UIDeviceOrientation {
        return UIDevice.current.orientation
    }
    
    var shadowArray = ["Off","Color","Angle","Opacity","Blur"]
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.currentPage = 0
        setupView()
     
    }
    

    
    
    //initWithCode to init view from xib or storyboard
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.currentPage = 0
        setupView()
        
    }
    
    private func setupView() {
      
        let layout = UPCarouselFlowLayout()
        layout.sideItemAlpha = 0.3
        layout.sideItemScale = 0.7
        layout.itemSize = CGSize(width: 80, height: 40)
        layout.scrollDirection = .horizontal
        layout.spacingMode = UPCarouselFlowLayoutSpacingMode.fixed(spacing: 10)
        layout.spacingMode = UPCarouselFlowLayoutSpacingMode.overlap(visibleOffset: 130)
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
      
        
        
        self.addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        collectionView.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        collectionView.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        
        collectionView.register(shadowToolsCell.self, forCellWithReuseIdentifier: "shadowToolsCell")
        collectionView.backgroundColor = barColor
        
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.panGestureRecognizer.isEnabled = false
        
        collectionView.reloadData()
        
    }
    
 
    
    
    
}

extension shadowTools: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
       return shadowArray.count
    }
    
 
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "shadowToolsCell", for: indexPath) as? shadowToolsCell
            else { return UICollectionViewCell() }
        
        
      
        cell.lab.text = shadowArray[indexPath.row]
        cell.lab.textColor = ButtonColor
        cell.isSelected = false
        
        
        cell.layer.cornerRadius = 2
        cell.backgroundColor = topColor
        return cell
    }
    
    
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let layout = self.collectionView.collectionViewLayout as! UPCarouselFlowLayout
        let pageSide = (layout.scrollDirection == .horizontal) ? self.pageSize.width : self.pageSize.height
        let offset = (layout.scrollDirection == .horizontal) ? scrollView.contentOffset.x : scrollView.contentOffset.y
        currentPage = Int(floor((offset - pageSide / 2) / pageSide) + 1)
        let indexPath = IndexPath(item: currentPage, section: 0)
        
        let scrollPosition: UICollectionView.ScrollPosition = orientation.isPortrait ? .centeredHorizontally : .centeredVertically
        self.collectionView.scrollToItem(at: indexPath, at: scrollPosition, animated: false)
        
        collectionView.reloadData()
        
        self.collectionView.performBatchUpdates(nil, completion: {
            (result) in
            let cell = self.collectionView.cellForItem(at: indexPath)
            cell?.isSelected = true
        })
    }

}
extension shadowTools: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    
      self.collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        self.currentPage = indexPath.row
        collectionView.reloadData()
        self.collectionView.performBatchUpdates(nil, completion: {
            (result) in
            let cell = self.collectionView.cellForItem(at: indexPath)
            cell?.isSelected = true
        })
        
       
        
    }
    
}



class shadowToolsCell: UICollectionViewCell {

    let lab: UILabel = {
        let lab = UILabel()
        lab.font = UIFont.systemFont(ofSize: 14, weight: UIFont.Weight.bold)
        lab.textColor = ButtonColor
        lab.textAlignment = .center
        lab.sizeToFit()
        lab.translatesAutoresizingMaskIntoConstraints = false
        return lab
    }()
    
    
    override var isSelected: Bool{
        didSet{
            if self.isSelected
            {
               
                lab.textColor = yellowColor
                
            }
            else
            {
          
                lab.textColor = ButtonColor
            }
        }
    }
    
 
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(lab)
        
        NSLayoutConstraint.activate([
            lab.leadingAnchor.constraint(equalTo: leadingAnchor),
            lab.trailingAnchor.constraint(equalTo: trailingAnchor),
            lab.topAnchor.constraint(equalTo: topAnchor),
            lab.bottomAnchor.constraint(equalTo: bottomAnchor),
            ])
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
