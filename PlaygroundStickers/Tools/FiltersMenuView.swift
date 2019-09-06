//
//  FiltersMenuView.swift
//  PlaygroundStickers
//
//  Created by Faris Albalawi on 8/21/19.
//  Copyright © 2019 Faris Albalawi. All rights reserved.
//

import UIKit
import CoreImage

let filtersList = [
    "None",                    //0
    "CIPhotoEffectInstant",    //1
    "CIPhotoEffectProcess",    //2
    "CIPhotoEffectTransfer",   //3
    "CISepiaTone",             //4
    "CIPhotoEffectChrome",     //5
    "CIPhotoEffectFade",       //6
    "CIPhotoEffectTonal",      //7
    "CIPhotoEffectNoir",       //8
]


// ------------------------------------------------
// MARK: - ARRAY OF PHOTO FILTER NAMES
// ------------------------------------------------
let filterNamesList = [
    "None",     //0
    "Instant",  //1
    "Moon",  //2
    "Cream", //3
    "Sepia",    //4
    "Brilliant",   //5
    "Jupiter",     //6
    "Mercury",    //7
    "Darken",     //8
]



protocol FiltersMenuViewDelegate {
    func FilterTapped(string: String)
}

class FiltersMenuView: UIView {
    
    var collectionView: UICollectionView!
    var Delegate : FiltersMenuViewDelegate?
    var imageToBeEdited: UIImageView?
    
    fileprivate var pageSize: CGSize {
        let layout =  UPCarouselFlowLayout()
        layout.sideItemAlpha = 0.3
        layout.sideItemScale = 0.7
        layout.itemSize = CGSize(width: 50, height: 50)
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
             self.Delegate?.FilterTapped(string: "\(filtersList[currentPage])")
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
        layout.itemSize = CGSize(width: 50, height: 50)
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
        
        collectionView.register(FiltersMenuViewCell.self, forCellWithReuseIdentifier: "FiltersMenuViewCell")
        collectionView.backgroundColor = topColor
        
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.panGestureRecognizer.isEnabled = false
        
        collectionView.reloadData()
     
        
        
        
    }
    
    
    
}

extension FiltersMenuView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return filtersList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FiltersMenuViewCell", for: indexPath) as? FiltersMenuViewCell
            else { return UICollectionViewCell() }
        
        let CIfilterName = "\(filtersList[indexPath.row])"
        if indexPath.row != 0 {
            // Apply Filters to the image
            if imageToBeEdited != nil {
                cell.filtersImage(CIfilterName: CIfilterName, image: imageToBeEdited!)
            }
         
        } else if indexPath.row == 0 {
            cell.img.image = imageToBeEdited?.image
        }
     
    
        cell.img.layer.masksToBounds = true
        cell.img.layer.cornerRadius =  50 / 2
        cell.layer.cornerRadius = 50 / 2
        cell.backgroundColor = topColor
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
      let cell = cell as! FiltersMenuViewCell
        
        let CIfilterName = "\(filtersList[indexPath.row])"
        if indexPath.row != 0 {
            // Apply Filters to the image
            if imageToBeEdited != nil {
                cell.filtersImage(CIfilterName: CIfilterName, image: imageToBeEdited!)
            }
            
        } else if indexPath.row == 0 {
            cell.img.image = imageToBeEdited?.image
        }
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
extension FiltersMenuView: UICollectionViewDelegate {
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



class FiltersMenuViewCell: UICollectionViewCell {
    let img: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.masksToBounds = false
        imageView.clipsToBounds = true
        return imageView
    }()
    

    
    override func prepareForReuse() {
        super.prepareForReuse()
       self.img.image = nil
    }
    
    func filtersImage(CIfilterName: String, image: UIImageView) {
        let ciContext = CIContext(options: nil)
        let coreImage = CIImage(image: image.image!)
        let filter = CIFilter(name: CIfilterName)
        filter!.setDefaults()
        
        filter!.setValue(coreImage, forKey: kCIInputImageKey)
        let filteredImageData = filter!.value(forKey: kCIOutputImageKey) as! CIImage
        let filteredImageRef = ciContext.createCGImage(filteredImageData, from: filteredImageData.extent)
        self.img.image = UIImage(cgImage: filteredImageRef!)
        
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(img)
        
        NSLayoutConstraint.activate([
            
         
            img.topAnchor.constraint(equalTo: topAnchor),
            img.bottomAnchor.constraint(equalTo: bottomAnchor),
            img.leadingAnchor.constraint(equalTo: leadingAnchor),
            img.trailingAnchor.constraint(equalTo: trailingAnchor),
            
//            img.widthAnchor.constraint(equalToConstant: 30),
//            img.heightAnchor.constraint(equalToConstant: 30),
//            img.centerXAnchor.constraint(equalTo: centerXAnchor),
//            img.centerYAnchor.constraint(equalTo: centerYAnchor),
//
            ])
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

