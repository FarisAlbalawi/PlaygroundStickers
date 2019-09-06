//
//  FontView.swift
//  PlaygroundStickers
//
//  Created by Faris Albalawi on 8/24/19.
//  Copyright © 2019 Faris Albalawi. All rights reserved.
//

import UIKit


let fontArray = [
    "Lalezar-Regular",
    "Cairo-Black",
    "Alnaqaaa-S",
    "Alnaqaaa-R",
    "Lemonada-Bold",
    "FFTaweel-Bold",
    "ElMessiri-Bold",
    "FFKhallab-Regular",
    "FFKhallab-Italic",
    "Sukar-Black",

]



import UIKit

protocol FontViewDelegate {
    func fontTapped(font: String)
}

class FontView: UIView {
    
    var collectionView: UICollectionView!
    var Delegate : FontViewDelegate?
    

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
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
            self.Delegate?.fontTapped(font: fontArray[currentPage])
        }
    }
    
    fileprivate var orientation: UIDeviceOrientation {
        return UIDevice.current.orientation
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
        
        collectionView.register(FontViewCell.self, forCellWithReuseIdentifier: "FontViewCell")
        collectionView.backgroundColor = barColor
        
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.showsHorizontalScrollIndicator = false
      //  collectionView.contentInset = UIEdgeInsets(top: 5,left: 14,bottom: 4,right: 14)
        collectionView.panGestureRecognizer.isEnabled = false
        collectionView.reloadData()
        
        
        
    }
    
    
    
}

extension FontView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return fontArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FontViewCell", for: indexPath) as? FontViewCell
            else { return UICollectionViewCell() }
        
        
        
        cell.lab.textAlignment = .center
        cell.lab.font = UIFont(name: fontArray[indexPath.row], size: 15)
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
extension FontView: UICollectionViewDelegate {
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



class FontViewCell: UICollectionViewCell {
    let lab: UILabel = {
        let lab = UILabel()
        lab.translatesAutoresizingMaskIntoConstraints = false
        return lab
    }()
    
    override var isSelected: Bool{
        didSet{
            if self.isSelected
            {

                lab.textColor = greenColor
             
                
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
        lab.text = "Text"
        NSLayoutConstraint.activate([
            lab.leadingAnchor.constraint(equalTo: leadingAnchor),
            lab.topAnchor.constraint(equalTo: topAnchor),
            lab.bottomAnchor.constraint(equalTo: bottomAnchor),
            lab.trailingAnchor.constraint(equalTo: trailingAnchor)
           
            ])
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
