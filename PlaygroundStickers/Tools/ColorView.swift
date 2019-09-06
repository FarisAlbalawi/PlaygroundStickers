//
//  ColorView.swift
//  PlaygroundStickers
//
//  Created by Faris Albalawi on 8/27/19.
//  Copyright © 2019 Faris Albalawi. All rights reserved.
//



import UIKit


protocol colorDelegate {
    func colorTapped(color: UIColor)
    func UISliderColorTapped()
}


class ColorView: UIView {
    
    var collectionView: UICollectionView!
    var colorDelegate : colorDelegate?
    
    
    fileprivate var pageSize: CGSize {
        let layout =  UPCarouselFlowLayout()
        layout.sideItemAlpha = 0.3
        layout.sideItemScale = 0.7
        layout.itemSize = CGSize(width: 40, height: 40)
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
               
            } else if currentPage == 1{
                 self.colorDelegate?.UISliderColorTapped()
            } else {
                self.colorDelegate?.colorTapped(color: colorsArray[currentPage - 2])
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
        layout.itemSize = CGSize(width: 40, height: 40)
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
        
        collectionView.register(colorCell.self, forCellWithReuseIdentifier: "colorCell")
        collectionView.backgroundColor = topColor
        
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.panGestureRecognizer.isEnabled = false
        
        collectionView.reloadData()
        
        
        
    }
    
    
    
}

extension ColorView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return colorsArray.count + 2
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "colorCell", for: indexPath) as? colorCell
            else { return UICollectionViewCell() }
        
        cell.isSelected = false
        
        if indexPath.row == 0 {
            cell.lab.text = "Off"
            cell.lab.isHidden = false
            cell.moreColor.isHidden = true
            cell.layer.backgroundColor = barColor.cgColor
        } else if indexPath.row == 1 {
            cell.lab.isHidden = true
            cell.moreColor.isHidden = false
            cell.backgroundColor = UIColor.clear
            
        } else {
            cell.lab.isHidden = true
            cell.moreColor.isHidden = true
            cell.backgroundColor = colorsArray[indexPath.row - 2]
            
        }
        
    
        cell.layer.cornerRadius = 20
        
        
        return cell
    }
    
    
    
    
}
extension ColorView: UICollectionViewDelegate {
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



class colorCell: UICollectionViewCell {
    
    let moreColor: UIImageView = {
        let moreColor = UIImageView()
        moreColor.backgroundColor = .clear
        moreColor.clipsToBounds = true
        moreColor.contentMode = .scaleAspectFit
        moreColor.image = UIImage(named: "colors")
        moreColor.contentMode = .scaleAspectFit
        moreColor.translatesAutoresizingMaskIntoConstraints = false
        return moreColor
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
            if self.isSelected {
                 self.layer.borderColor = ButtonColor.cgColor
                 self.layer.borderWidth = 3
            } else {
                self.layer.borderWidth = 0
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(moreColor)
        addSubview(lab)
        
        NSLayoutConstraint.activate([
            moreColor.topAnchor.constraint(equalTo: topAnchor),
            moreColor.bottomAnchor.constraint(equalTo: bottomAnchor),
            moreColor.leadingAnchor.constraint(equalTo: leadingAnchor),
            moreColor.trailingAnchor.constraint(equalTo: trailingAnchor),
            
            lab.leadingAnchor.constraint(equalTo: leadingAnchor),
            lab.trailingAnchor.constraint(equalTo: trailingAnchor),
            lab.topAnchor.constraint(equalTo: topAnchor),
            lab.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            
            ])
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}


// ARRAY OF COLORS
var colorsArray = [
    UIColor(red: 0.9059, green: 0.298, blue: 0.2353, alpha: 1.0),
    UIColor(red: 0.7529, green: 0.2235, blue: 0.1686, alpha: 1.0),
    UIColor(red: 0.902, green: 0.4941, blue: 0.1333, alpha: 1.0),
    UIColor(red: 0.8275, green: 0.3294, blue: 0, alpha: 1.0),
    UIColor(red: 1, green: 0.8039, blue: 0.0078, alpha: 1.0),
    UIColor(red: 1, green: 0.6588, blue: 0, alpha: 1.0),
    UIColor(red: 0.9412, green: 0.8706, blue: 0.7059, alpha: 1.0),
    UIColor(red: 0.8353, green: 0.7608, blue: 0.5843, alpha: 1.0),
    UIColor(red: 0.2039, green: 0.2863, blue: 0.3686, alpha: 1.0),
    UIColor(red: 0.1725, green: 0.2431, blue: 0.3137, alpha: 1.0),
    UIColor(red: 0.1686, green: 0.1686, blue: 0.1686, alpha: 1.0),
    UIColor(red: 0.149, green: 0.149, blue: 0.149, alpha: 1.0),
    UIColor(red: 0.6078, green: 0.349, blue: 0.7137, alpha: 1.0),
    UIColor(red: 0.5569, green: 0.2667, blue: 0.6784, alpha: 1.0),
    UIColor(red: 0.2275, green: 0.4353, blue: 0.5059, alpha: 1.0),
    UIColor(red: 0.2078, green: 0.3843, blue: 0.4471, alpha: 1.0),
    UIColor(red: 0.2039, green: 0.5961, blue: 0.8588, alpha: 1.0),
    UIColor(red: 0.1608, green: 0.502, blue: 0.7255, alpha: 1.0),
    UIColor(red: 0.1804, green: 0.8, blue: 0.4431, alpha: 1.0),
    UIColor(red: 0.1529, green: 0.6824, blue: 0.3765, alpha: 1.0),
    UIColor(red: 0.102, green: 0.7373, blue: 0.6118, alpha: 1.0),
    UIColor(red: 0.0863, green: 0.6275, blue: 0.5216, alpha: 1.0),
    UIColor(red: 0.9255, green: 0.9412, blue: 0.9451, alpha: 1.0),
    UIColor(red: 0.7412, green: 0.7647, blue: 0.7804, alpha: 1.0),
    UIColor(red: 0.5843, green: 0.6471, blue: 0.651, alpha: 1.0),
    UIColor(red: 0.498, green: 0.549, blue: 0.5529, alpha: 1.0),
    UIColor(red: 0.2039, green: 0.3725, blue: 0.2549, alpha: 1.0),
    UIColor(red: 0.1765, green: 0.3137, blue: 0.2118, alpha: 1.0),
    UIColor(red: 0.4549, green: 0.3686, blue: 0.7725, alpha: 1.0),
    UIColor(red: 0.3569, green: 0.2824, blue: 0.6353, alpha: 1.0),
    UIColor(red: 0.3686, green: 0.2706, blue: 0.2039, alpha: 1.0),
    UIColor(red: 0.3137, green: 0.2314, blue: 0.1725, alpha: 1.0),
    UIColor(red: 0.3686, green: 0.2039, blue: 0.3686, alpha: 1.0),
    UIColor(red: 0.3098, green: 0.1686, blue: 0.3098, alpha: 1.0),
    UIColor(red: 0.9373, green: 0.4431, blue: 0.4784, alpha: 1.0),
    UIColor(red: 0.851, green: 0.3294, blue: 0.349, alpha: 1.0),
    UIColor(red: 0.6471, green: 0.7765, blue: 0.2314, alpha: 1.0),
    UIColor(red: 0.5569, green: 0.6902, blue: 0.1294, alpha: 1.0),
    UIColor(red: 0.9569, green: 0.4863, blue: 0.7647, alpha: 1.0),
    UIColor(red: 0.8314, green: 0.3608, blue: 0.6196, alpha: 1.0),
    UIColor(red: 0.4745, green: 0.1882, blue: 0.1647, alpha: 1.0),
    UIColor(red: 0.4, green: 0.149, blue: 0.1294, alpha: 1.0),
    UIColor(red: 0.6392, green: 0.5255, blue: 0.4431, alpha: 1.0),
    UIColor(red: 0.5569, green: 0.4471, blue: 0.3686, alpha: 1.0),
    UIColor(red: 0.7216, green: 0.7882, blue: 0.9451, alpha: 1.0),
    UIColor(red: 0.6, green: 0.6706, blue: 0.8353, alpha: 1.0),
    UIColor(red: 0.3137, green: 0.3961, blue: 0.6314, alpha: 1.0),
    UIColor(red: 0.2235, green: 0.298, blue: 0.5059, alpha: 1.0)
]

