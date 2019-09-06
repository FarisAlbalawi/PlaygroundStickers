//
//  TextTool.swift
//  PlaygroundStickers
//
//  Created by Faris Albalawi on 8/23/19.
//  Copyright © 2019 Faris Albalawi. All rights reserved.
//


import UIKit

protocol TextToolDelegate {
    func TextToolTapped(index: Int)
}

class TextTool: UIView {
    
    var collectionView: UICollectionView!
    var Delegate : TextToolDelegate?
    
    var ToolsArray = ["color","Tfont","textRound","TbackgroundColor","shadow","centerAlignment","rotate","size","size2"]
    
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
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 50, height: 50)
        layout.minimumLineSpacing = 20
        layout.scrollDirection = .horizontal
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        
        self.addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        collectionView.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        collectionView.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        
        collectionView.register(TextToolCell.self, forCellWithReuseIdentifier: "TextToolCell")
        collectionView.backgroundColor = barColor
        
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.contentInset = UIEdgeInsets(top: 0,left: 14,bottom: 0,right: 14)
        collectionView.reloadData()
        
        
        
    }
    
    
    
}

extension TextTool: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return ToolsArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TextToolCell", for: indexPath) as? TextToolCell
            else { return UICollectionViewCell() }
        
        cell.img.image = UIImage(named: ToolsArray[indexPath.row])
        cell.img.image = cell.img.image?.withRenderingMode(.alwaysTemplate)
        cell.img.tintColor = ButtonColor
        cell.isSelected = false
        
        cell.layer.cornerRadius = 2
        cell.backgroundColor = topColor
        return cell
    }
    
    
}
extension TextTool: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        self.Delegate?.TextToolTapped(index: indexPath.row)
        
        
    }
    
}



class TextToolCell: UICollectionViewCell {
    let img: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    override var isSelected: Bool{
        didSet{
            if self.isSelected
            {
                self.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
                img.image = img.image?.withRenderingMode(.alwaysTemplate)
                img.tintColor = yellowColor
                
                
            }
            else
            {
                self.transform = CGAffineTransform.identity
                img.image = img.image?.withRenderingMode(.alwaysTemplate)
                img.tintColor = ButtonColor
                
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(img)
        
        NSLayoutConstraint.activate([
            img.widthAnchor.constraint(equalToConstant: 25),
            img.heightAnchor.constraint(equalToConstant: 25),
            img.centerXAnchor.constraint(equalTo: centerXAnchor),
            img.centerYAnchor.constraint(equalTo: centerYAnchor),
            
            ])
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
