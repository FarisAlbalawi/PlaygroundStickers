//
//  MaskView.swift
//  PlaygroundStickers
//
//  Created by Faris Albalawi on 8/26/19.
//  Copyright © 2019 Faris Albalawi. All rights reserved.
//


import UIKit

protocol MaskViewDelegate {
    func MaskViewTapped(Image: UIImage)
     func MaskViewOff()
}

class MaskView: UIView {
    
    var collectionView: UICollectionView!
    var Delegate : MaskViewDelegate?
    
    var maskArray = Array(1...45)
    
    fileprivate var pageSize: CGSize {
        let layout =  UPCarouselFlowLayout()
        layout.sideItemAlpha = 0.3
        layout.sideItemScale = 0.7
        layout.itemSize = CGSize(width: 60, height: 60)
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
            if currentPage == 0 {
                   self.Delegate?.MaskViewOff()
            } else {
                let image = UIImage(named: "\(maskArray[currentPage - 1])")
                self.Delegate?.MaskViewTapped(Image: image!)
            }
           
        }
    }
    
    fileprivate var orientation: UIDeviceOrientation {
        return UIDevice.current.orientation
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
        layout.itemSize = CGSize(width: 60, height: 60)
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
        
        collectionView.register(MaskViewCell.self, forCellWithReuseIdentifier: "MaskViewCell")
        collectionView.backgroundColor = barColor
        
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.panGestureRecognizer.isEnabled = false

        collectionView.reloadData()
        
        
        
    }
    
    
    
}

extension MaskView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return maskArray.count + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MaskViewCell", for: indexPath) as? MaskViewCell
            else { return UICollectionViewCell() }
        
        if indexPath.row == 0 {
             cell.img.isHidden = true
            cell.lab.isHidden = false
             cell.lab.text = "Off"
        } else {
            cell.lab.isHidden = true
            cell.img.isHidden = false
            cell.img.image = UIImage(named:"\(maskArray[indexPath.row - 1])")
            cell.img.image = cell.img.image?.withRenderingMode(.alwaysTemplate)
            cell.img.tintColor = ButtonColor
            
        }
  
         cell.isSelected = false
        
        cell.layer.masksToBounds = false
        cell.layer.cornerRadius = 30
      
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
extension MaskView: UICollectionViewDelegate {
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



class MaskViewCell: UICollectionViewCell {
    let img: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let lab: UILabel = {
        let lab = UILabel()
        lab.font = UIFont.systemFont(ofSize: 15, weight: UIFont.Weight.bold)
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
        
                img.image = img.image?.withRenderingMode(.alwaysTemplate)
                img.tintColor = yellowColor
                lab.textColor = yellowColor
              
                
                
            }
            else
            {
              
                img.image = img.image?.withRenderingMode(.alwaysTemplate)
                img.tintColor = ButtonColor
                lab.textColor = ButtonColor
            
                
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(img)
        addSubview(lab)
     
        
        
        NSLayoutConstraint.activate([
            img.widthAnchor.constraint(equalToConstant: 40),
            img.heightAnchor.constraint(equalToConstant: 40),
            img.centerXAnchor.constraint(equalTo: centerXAnchor),
            img.centerYAnchor.constraint(equalTo: centerYAnchor),
         
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
