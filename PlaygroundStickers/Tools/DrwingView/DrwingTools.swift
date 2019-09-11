//
//  DrwingTools.swift
//  PlaygroundStickers
//
//  Created by Faris Albalawi on 9/9/19.
//  Copyright © 2019 Faris Albalawi. All rights reserved.
//


import UIKit



class DrwingTools: UIView, TouchDrawViewDelegate {
    
    var collectionView: UICollectionView!
  
    var drawView: TouchDrawView?

    private static let deltaWidth = CGFloat(5.0)

    
    private let headerView: UIView = {
        let headerView = UIView()
        headerView.backgroundColor = UIColor.clear
        headerView.translatesAutoresizingMaskIntoConstraints = false
        return headerView
    }()
    
     let UndoButton: UIButton = {
        let UndoButton = UIButton()
        let image = UIImage(named: "Undo")?.withRenderingMode(.alwaysTemplate)
        UndoButton.setImage(image, for: .normal)
        UndoButton.imageView?.tintColor = ButtonColor
        UndoButton.imageView?.contentMode = .scaleAspectFit
        UndoButton.addTarget(self, action: #selector(DrwingTools.didPressUndoButton), for: UIControl.Event.touchUpInside)
        UndoButton.translatesAutoresizingMaskIntoConstraints = false
        
        return UndoButton
    }()
    

    
     let RedoButton: UIButton = {
        let RedoButton = UIButton()
        let image = UIImage(named: "Redo")?.withRenderingMode(.alwaysTemplate)
        RedoButton.setImage(image, for: .normal)
        RedoButton.imageView?.tintColor = ButtonColor
        
        RedoButton.layer.cornerRadius = 30 / 2
        RedoButton.addTarget(self, action: #selector(DrwingTools.didPressRedoButton), for: UIControl.Event.touchUpInside)
        RedoButton.translatesAutoresizingMaskIntoConstraints = false
        return RedoButton
    }()
    
    
     let eraserButton: UIButton = {
        let eraserButton = UIButton()
        let image = UIImage(named: "eraser")?.withRenderingMode(.alwaysTemplate)
        eraserButton.setImage(image, for: .normal)
        eraserButton.imageView?.tintColor = redColor
        
        eraserButton.layer.cornerRadius = 30 / 2
        eraserButton.addTarget(self, action: #selector(DrwingTools.didPressEraserButton), for: UIControl.Event.touchUpInside)
        eraserButton.translatesAutoresizingMaskIntoConstraints = false
        return eraserButton
    }()
    
     let cleaningButton: UIButton = {
        let cleaningButton = UIButton()
        cleaningButton.setTitle("Clear", for: .normal)
        cleaningButton.setTitleColor(.white, for: .normal)
        cleaningButton.backgroundColor = blueColor
        cleaningButton.layer.cornerRadius = 28 / 2
        cleaningButton.addTarget(self, action: #selector(DrwingTools.didPressCleaningButton), for: UIControl.Event.touchUpInside)
        cleaningButton.translatesAutoresizingMaskIntoConstraints = false
        return cleaningButton
    }()
    
    
     let sizeSlider: CustomSlider = {
        let sizeSlider = CustomSlider()
        sizeSlider.maximumValue = 30
        sizeSlider.minimumValue = 1
        sizeSlider.thumbTintColor = UIColor.black
        
        sizeSlider.setValue(5.0, animated:true)
        sizeSlider.minimumTrackTintColor = topColor
        sizeSlider.maximumTrackTintColor = topColor
      
        
        sizeSlider.translatesAutoresizingMaskIntoConstraints = false
        sizeSlider.addTarget(self, action: #selector(DrwingTools.changeSizeSliderVlaue(_:)), for: .valueChanged)
        return sizeSlider
    }()
    
    
    
    private let screenSize = UIScreen.main.bounds.size
    
    
    
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
          
            
            self.sizeSlider.thumbTintColor = colorsArray[currentPage]
            if drawView != nil {
                drawView!.setColor(colorsArray[currentPage])
                eraserButton.isEnabled = true
            }
         
            
        }
    }
    
    fileprivate var orientation: UIDeviceOrientation {
        return UIDevice.current.orientation
    }
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        if drawView != nil {
             drawView!.delegate = self
            drawView!.setWidth(DrwingTools.deltaWidth)
        }
    }
    
    func drawViewdelegate() {
        if drawView != nil {
            drawView!.delegate = self
            drawView!.setWidth(DrwingTools.deltaWidth)
        }
        
        sizeSlider.setValue(5.0, animated:true)
        self.collectionView.reloadData()
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
        
        
        self.addSubview(headerView)
        self.headerView.addSubview(cleaningButton)
        self.headerView.addSubview(RedoButton)
        self.headerView.addSubview(UndoButton)
        self.headerView.addSubview(eraserButton)
        self.addSubview(collectionView)
        self.addSubview(sizeSlider)
        let screenWidth = screenSize.width
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
         NSLayoutConstraint.activate([
            
            
            cleaningButton.heightAnchor.constraint(equalToConstant: 28),
            cleaningButton.widthAnchor.constraint(equalToConstant: 75),
            cleaningButton.centerYAnchor.constraint(equalTo: headerView.centerYAnchor),
            cleaningButton.centerXAnchor.constraint(equalTo: headerView.centerXAnchor),
            
            
            eraserButton.heightAnchor.constraint(equalToConstant: 30),
            eraserButton.widthAnchor.constraint(equalToConstant: 30),
            eraserButton.centerYAnchor.constraint(equalTo: headerView.centerYAnchor),
            eraserButton.rightAnchor.constraint(equalTo: headerView.rightAnchor, constant: -10),
            
            
            UndoButton.heightAnchor.constraint(equalToConstant: 30),
            UndoButton.widthAnchor.constraint(equalToConstant: 30),
            UndoButton.centerYAnchor.constraint(equalTo: headerView.centerYAnchor),
            UndoButton.leftAnchor.constraint(equalTo: headerView.leftAnchor, constant: 10),
            
            RedoButton.heightAnchor.constraint(equalToConstant: 30),
            RedoButton.widthAnchor.constraint(equalToConstant: 30),
            RedoButton.centerYAnchor.constraint(equalTo: headerView.centerYAnchor),
            RedoButton.leftAnchor.constraint(equalTo: headerView.leftAnchor, constant: 50),
            
            
            headerView.heightAnchor.constraint(equalToConstant: 50),
            headerView.widthAnchor.constraint(equalToConstant: screenWidth),
            headerView.topAnchor.constraint(equalTo: topAnchor),
            headerView.trailingAnchor.constraint(equalTo: trailingAnchor),
            
            collectionView.topAnchor.constraint(equalTo: headerView.bottomAnchor),
            collectionView.leftAnchor.constraint(equalTo: leftAnchor),
            collectionView.rightAnchor.constraint(equalTo: rightAnchor),
            collectionView.bottomAnchor.constraint(equalTo: sizeSlider.topAnchor),
            
            sizeSlider.widthAnchor.constraint(equalToConstant: screenWidth / 1.1),
            sizeSlider.topAnchor.constraint(equalTo: collectionView.bottomAnchor,constant: 0),
            sizeSlider.bottomAnchor.constraint(equalTo: bottomAnchor,constant: -8),
            sizeSlider.centerXAnchor.constraint(equalTo: centerXAnchor),
            
            
            
            
            ])
        
        
       
        
        collectionView.register(DrwingToolsCell.self, forCellWithReuseIdentifier: "DrwingToolsCell")
        collectionView.backgroundColor = barColor
        
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.panGestureRecognizer.isEnabled = false
        
        collectionView.reloadData()
        
        
        
    }
    
    
    @objc func didPressUndoButton() {
        if drawView != nil {
            drawView!.undo()
        }
   
    }
    
    @objc func didPressRedoButton() {
        if drawView != nil {
            drawView!.redo()
        }
     
    }
    
    @objc func didPressCleaningButton() {
        if drawView != nil {
             drawView!.clearDrawing()
        }
       
        
    }
    
    @objc func didPressEraserButton() {
        if drawView != nil {
            drawView!.setColor(nil)
            eraserButton.isEnabled = false
        }
 
    }
    
    
    
    
    
    @objc func changeSizeSliderVlaue(_ sender: UISlider) {
        let newWidth = CGFloat(sender.value) * DrwingTools.deltaWidth
        if drawView != nil {
             drawView!.setWidth(newWidth)
        }
       
    }
    
    
    func undoEnabled() {
        self.UndoButton.isEnabled = true
    }
    
    func undoDisabled() {
        self.UndoButton.isEnabled = false
    }
    
    func redoEnabled() {
        self.RedoButton.isEnabled = true
    }
    
    func redoDisabled() {
        self.RedoButton.isEnabled = false
    }
    
    func clearEnabled() {
        self.cleaningButton.isEnabled = true
    }
    
    func clearDisabled() {
        self.cleaningButton.isEnabled = false
    }
    
}

extension DrwingTools: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return colorsArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DrwingToolsCell", for: indexPath) as? DrwingToolsCell
            else { return UICollectionViewCell() }
        
        cell.isSelected = false
        cell.lab.isHidden = true
        cell.moreColor.isHidden = true
        cell.backgroundColor = colorsArray[indexPath.row]
        cell.layer.cornerRadius = 20
        
        
        return cell
    }
    
    
    
    
}
extension DrwingTools: UICollectionViewDelegate {
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



class DrwingToolsCell: UICollectionViewCell {
    
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
