//
//  PhotoGallery.swift
//  PlaygroundStickers
//
//  Created by Faris Albalawi on 8/9/19.
//  Copyright © 2019 Faris Albalawi. All rights reserved.
//


import UIKit
import Photos



func numberCols() -> Int {
    switch UIDevice.current.userInterfaceIdiom {
    case .phone:
        return 2
    case .pad:
        return 4
    case .unspecified:
        return 2
    case .tv:
        return 2
    case .carPlay:
        return 2
    @unknown default:
        fatalError()
    }
}


class PhotoGallery: UIViewController{
  
    

    var photoDelegate : PhotosDelegate?
    
    var photosCollectionView: UICollectionView!

    
    var images = [PHAsset]()
    var imagesArray = [UIImage]()
    

    override var preferredStatusBarStyle : UIStatusBarStyle {
        return .lightContent
    }
    
   
    
    let topView : UIView = {
        let views = UIView()
        views.translatesAutoresizingMaskIntoConstraints = false
        views.backgroundColor = backgroundColor
        return views
        
    }()
    
    
     let cancelButton: UIButton = {
        let cancel = UIButton()
        cancel.setTitle("Cancel", for: .normal)
        cancel.setTitleColor(.white, for: .normal)
        cancel.backgroundColor = redColor
        cancel.layer.cornerRadius = 28 / 2
        cancel.addTarget(self, action: #selector(PhotoGallery.didPressCancel), for: UIControl.Event.touchUpInside)
        cancel.translatesAutoresizingMaskIntoConstraints = false
        return cancel
    }()
    
     let Titlelab: UILabel = {
        let Titlelab = UILabel()
        Titlelab.font = UIFont(name: "Futura-Medium", size: 20)!
        Titlelab.text = "Photo Gallery"
        Titlelab.textColor = ButtonColor
        Titlelab.translatesAutoresizingMaskIntoConstraints = false
        return Titlelab
    }()
    
    
    let PhotosAccessView: UIView = {
        let PhotosAccessView = UIView()
        PhotosAccessView.backgroundColor = topColor
        PhotosAccessView.translatesAutoresizingMaskIntoConstraints = false
        let icons = UIImageView()
        icons.frame.size = CGSize(width: 80, height: 80)
        icons.image = UIImage(named: "photo")
        icons.contentMode = .scaleAspectFit
        icons.image = icons.image?.withRenderingMode(.alwaysTemplate)
        icons.tintColor = backgroundColor
        PhotosAccessView.addSubview(icons)
        icons.translatesAutoresizingMaskIntoConstraints = false

        let AccessButton = UIButton()
        AccessButton.setTitle("Allow access to photos library", for: .normal)
        AccessButton.setTitleColor(.white, for: .normal)
        AccessButton.backgroundColor = blueColor
        AccessButton.layer.cornerRadius = 50 / 2
        AccessButton.addTarget(self, action: #selector(didPresAccess(_:)), for: .touchUpInside)
        PhotosAccessView.addSubview(AccessButton)
        AccessButton.translatesAutoresizingMaskIntoConstraints = false


        NSLayoutConstraint.activate([
            icons.heightAnchor.constraint(equalToConstant: 200),
            icons.widthAnchor.constraint(equalToConstant: 200),
            icons.centerXAnchor.constraint(equalTo: PhotosAccessView.centerXAnchor),
            icons.centerYAnchor.constraint(equalTo: PhotosAccessView.centerYAnchor,constant: -150),

            AccessButton.heightAnchor.constraint(equalToConstant: 50),
            AccessButton.widthAnchor.constraint(equalToConstant: 300),
            AccessButton.centerXAnchor.constraint(equalTo: PhotosAccessView.centerXAnchor),
            AccessButton.centerYAnchor.constraint(equalTo: PhotosAccessView.centerYAnchor),


            ])


         return PhotosAccessView
    }()
//
    
    
    var AccesDenied = Bool()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        

        view.backgroundColor = backgroundColor
        
        let layout = collectionViewLayout(delegate: self)
        if #available(iOS 10.0, *) {
            layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        } else {
            // Fallback on earlier versions
        }
        
        photosCollectionView = UICollectionView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height:self.view.frame.height), collectionViewLayout: layout)

       
        photosCollectionView.backgroundColor = topColor
        photosCollectionView.dataSource = self
        photosCollectionView.delegate = self
        photosCollectionView.showsHorizontalScrollIndicator = false
        photosCollectionView.showsVerticalScrollIndicator = false
        view.addSubview(photosCollectionView)
      
        photosCollectionView.register(PhotoItemCell.self, forCellWithReuseIdentifier: "Cell")
        photosCollectionView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(topView)
        topView.addSubview(cancelButton)
        topView.addSubview(Titlelab)
        
        view.addSubview(PhotosAccessView)
        
        NSLayoutConstraint.activate([
            
            // layout
            topView.heightAnchor.constraint(equalToConstant: 50),
            topView.widthAnchor.constraint(equalToConstant: self.view.frame.size.width),
            topView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            
            photosCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            photosCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            photosCollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            photosCollectionView.topAnchor.constraint(equalTo: topView.bottomAnchor),
            
            PhotosAccessView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            PhotosAccessView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            PhotosAccessView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            PhotosAccessView.topAnchor.constraint(equalTo: topView.bottomAnchor),
            
            
            cancelButton.heightAnchor.constraint(equalToConstant: 28),
            cancelButton.widthAnchor.constraint(equalToConstant: 75),
            cancelButton.centerYAnchor.constraint(equalTo: topView.centerYAnchor),
            cancelButton.leftAnchor.constraint(equalTo: topView.leftAnchor, constant: 10),
            
            Titlelab.centerYAnchor.constraint(equalTo: topView.centerYAnchor),
            Titlelab.centerXAnchor.constraint(equalTo: topView.centerXAnchor),
            
            ])
        
        
        // Get the current authorization state.
        let status = PHPhotoLibrary.authorizationStatus()
        if (status == PHAuthorizationStatus.authorized) {
            // Access has been granted.
            DispatchQueue.main.async {
                self.getImages(forCount: 200)
                self.PhotosAccessView.isHidden = true
                self.photosCollectionView.isHidden = false
                self.AccesDenied = false
            }
          
        } else if (status == PHAuthorizationStatus.denied) {
            // Access has been denied.
            DispatchQueue.main.async {
                self.PhotosAccessView.isHidden = false
                self.photosCollectionView.isHidden = true
                self.AccesDenied = true
            }
          
        } else {
            // Access has not been determined.
            DispatchQueue.main.async {
                self.PhotosAccessView.isHidden = false
                self.photosCollectionView.isHidden = true
                self.AccesDenied = false
            }
          
        }
            
 
        

       
        
        
        // Do any additional setup after loading the view.
    }
    
    
  
    
    @objc func didPresAccess(_ sender: UIButton) {
        if #available(iOS 10.0, *) {
            let generator = UIImpactFeedbackGenerator(style: .medium)
            generator.impactOccurred()
        }
        
        if AccesDenied == true {
            let alert = UIAlertController(title: "Photos Access Denied", message: "App needs access to photos library.", preferredStyle: .alert)
            
            // Add "OK" Button to alert, pressing it will bring you to the settings app
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
                UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
            }))
            // Show the alert with animation
            self.present(alert, animated: true)
        } else {
            let photos = PHPhotoLibrary.authorizationStatus()
            if photos == .notDetermined {
                PHPhotoLibrary.requestAuthorization({status in
                    if status == .authorized{
                        DispatchQueue.main.async {
                            
                            self.PhotosAccessView.isHidden = true
                            self.photosCollectionView.isHidden = false
                            self.getImages(forCount: 200)
                        }
                        
                    }
                })
            } else if photos == .authorized {
                self.getImages(forCount: 200)
                self.PhotosAccessView.isHidden = true
                self.photosCollectionView.isHidden = false
                
            }
        }
        
        
    }
    
    @objc func didPressCancel() {
        self.dismiss(animated: true, completion: nil)
        
    }
    
    func getImages(forCount count: Int?) {
        self.images = []
        // Create fetch options.
        let options = PHFetchOptions()
        
        // If count limit is specified.
        if let count = count { options.fetchLimit = count }
        
        // Add sortDescriptor so the lastest photos will be returned.
        let sortDescriptor = NSSortDescriptor(key: "creationDate", ascending: false)
        options.sortDescriptors = [sortDescriptor]
        
        
        let assets = PHAsset.fetchAssets(with: .image, options: options)
        assets.enumerateObjects({ (object, count, stop) in
            // self.cameraAssets.add(object)
            self.images.append(object)
        })
        
     
        // To show photos, I have taken a UICollectionView
        self.photosCollectionView.reloadData()
    }
    
    // Mark: Resize Image
    func resizeImage(image: UIImage, newWidth: CGFloat) -> UIImage {
        let scale = newWidth / image.size.width
        let newHeight = image.size.height * scale
        UIGraphicsBeginImageContext(CGSize(width: newWidth, height: newHeight))
        image.draw(in: CGRect(x: 0, y: 0,width: newWidth, height: newHeight))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage!
    }
    
}




// collection View
extension PhotoGallery: collectionViewFlowDataSource {
    
    func sizeOfItemAtIndexPath(at indexPath: IndexPath) -> CGFloat {
        var height = CGFloat()
        let asset = images[indexPath.row]
        let imageManager = PHImageManager.default()
        imageManager.requestImage(for: asset,
                             targetSize: CGSize(width: 160, height: 160),
                             contentMode: .aspectFill,
                             options: nil) { (result, _) in
                                let newWidth = self.view.frame.width / 2 - 20
                                let image = self.resizeImage(image: result!, newWidth: newWidth)
                                height = image.size.height
                          
                               
        }
        
        return height
    }
    
    
    func numberOfCols(at section: Int) -> Int {
        return numberCols()
        
    }
    
    func spaceOfCells(at section: Int) -> CGFloat{
        return 12
    }
    
    func sectionInsets(at section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 10, left: 10, bottom: 50, right: 10)
    }
    
  
    
    func heightOfAdditionalContent(at indexPath : IndexPath) -> CGFloat{
        return 0
    }
}



// MARK: Data source
extension PhotoGallery: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! PhotoItemCell
       
        let asset = images[indexPath.row]
        let manager = PHImageManager.default()
        if cell.tag != 0 {
            manager.cancelImageRequest(PHImageRequestID(cell.tag))
        }
        
        cell.tag = Int(manager.requestImage(for: asset,
                                            targetSize: CGSize(width: 160, height: 160),
                                            contentMode: .aspectFill,
                                            options: nil) { (result, _) in
                                                cell.img.image = result
        })
        
    
        cell.img.layer.cornerRadius = 8
        cell.layer.masksToBounds = true
        cell.layer.cornerRadius = 8
        cell.img.layer.borderWidth = 2
        cell.img.layer.borderColor = ButtonColor.cgColor
        
        return cell
     
      
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let asset = images[indexPath.row]
        let imageManager = PHImageManager.default()
        let option = PHImageRequestOptions()
        option.isNetworkAccessAllowed = true
        
        imageManager.requestImage(for: asset, targetSize: PHImageManagerMaximumSize, contentMode: .aspectFill, options: option)
        { (image, info) in
            DispatchQueue.main.async {
//                
//                self.dismiss(animated: true, completion: nil)
                let views = CropViewController()
                views.imageForCrop = image!
                views.photoDelegate = self.photoDelegate
                self.present(views, animated: true, completion: nil)
                
            }
        }
    }
    
}






class PhotoItemCell: UICollectionViewCell {
    
    var img = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        img.contentMode = .scaleAspectFill
        img.backgroundColor = ButtonColor
        img.clipsToBounds=true
        self.addSubview(img)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        img.frame = self.bounds
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
