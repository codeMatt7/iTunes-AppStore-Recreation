//
//  ScreenshotsCell.swift
//  App Store
//
//  Created by Matt Houston on 4/4/17.
//  Copyright © 2017 App Store. All rights reserved.
//

import UIKit

//container for screenshot cells
class ScreenshotsCell: BaseCell, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    var app: App? {
        didSet {
            collectionView.reloadData()
        }
    }
    
    //collectionView for screenshot image cells
    let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collection.backgroundColor = UIColor.clear
        return collection
    }()
    
    //divider line
    let dividerLineView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(white: 0.4, alpha: 0.4)
        return view
    }()
    
    private let cellId = "cellId"
    
    override func setupViews() {
        super.setupViews()
        
        //collectionView Protocol
        collectionView.delegate = self
        collectionView.dataSource = self
        
        //register collection view cell
        collectionView.register(ScreenshotImageCell.self, forCellWithReuseIdentifier: cellId)
        
        //add subviews
        addSubview(collectionView)
        addSubview(dividerLineView)
        
        //constraints for collectionView
        addConstraintsWithFormat(format: "H:|[v0]|", views: collectionView)
        
        addConstraintsWithFormat(format: "H:|-14-[v0]|", views: dividerLineView)
        
        addConstraintsWithFormat(format: "V:|[v0][v1(1)]|", views: collectionView, dividerLineView)
        
        

    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //unwrap 
        if let count = app?.screenshots?.count {
            return count
        }
        return 0
    
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! ScreenshotImageCell
        
        if let imageName = app?.screenshots?[indexPath.item] {
            cell.imageView.image = UIImage(named: imageName)
        }
        
        return cell
    }
    
    //height and width of cell
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize.init(width: 240, height: frame.height - 28)
    }
    
    //padding left and right of cell
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 14, bottom: 0, right: 14)
    }
}

class ScreenshotImageCell: BaseCell {
    
    //screenshot imageView
    let imageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.backgroundColor = UIColor.green
        return iv
    }()
    
    override func setupViews() {
        super.setupViews()
        
        layer.masksToBounds = true
        
        //add subviews
        addSubview(imageView)
        
        //constraints for screenshot imageview
        addConstraintsWithFormat(format: "H:|[v0]|", views: imageView)
        addConstraintsWithFormat(format: "V:|[v0]|", views: imageView)
        
        
    }
}
















