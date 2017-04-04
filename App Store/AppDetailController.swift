//
//  AppDetailController.swift
//  App Store
//
//  Created by Matt Houston on 4/3/17.
//  Copyright © 2017 App Store. All rights reserved.
//

import UIKit

class AppDetailController: UICollectionViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView?.backgroundColor = UIColor.white
    }
}

class AppDetailHeader: BaseCell {
    
    let imageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        return iv
    }
    
    
    override func setupViews() {
        addSubview(imageView)
    }
    
}

class BaseCell: UICollectionViewCell {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    func setupViews() {
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init coder has not been implemented")
    }
    
}
