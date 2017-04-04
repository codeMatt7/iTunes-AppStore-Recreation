//
//  Cell.swift
//  App Store
//
//  Created by Matt Houston on 1/18/17.
//  Copyright © 2017 App Store. All rights reserved.
//

import UIKit

class CategoryCell: UICollectionViewCell, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {

    
    var featuredAppsController = FeaturedAppsController()
    
    //define property //when you set the property of 'appCategory' for this custom cell
    var appCategory: AppCategory? {
        didSet {
            if let name = appCategory?.name {
                nameLabel.text = name
            }
            appsCollectionView.reloadData()
        }
    }
    
    //initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //Best New Apps Label
    let nameLabel: UILabel = {
        let label = UILabel()
        label.text = "Best New Apps"
        label.font = UIFont.systemFont(ofSize: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    //Separator line
    let dividerLineView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(white: 0.4, alpha: 0.4)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    //We added a collection view inside of the vertical cells of the main collection view. this collection view represents the apps images
    let appsCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = UIColor.clear
        collectionView.translatesAutoresizingMaskIntoConstraints = false //make sure to call this when using constraints
        
        return collectionView
    }()
    
    func setupViews() {
        backgroundColor = UIColor.clear
        
        addSubview(appsCollectionView)
        addSubview(dividerLineView)
        addSubview(nameLabel)
        
        appsCollectionView.dataSource = self
        appsCollectionView.delegate = self
        
        appsCollectionView.register(AppCell.self, forCellWithReuseIdentifier: cellId)
        
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-14-[v0]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": nameLabel]))
        
        //this means expand horizontally from the left to the right edge. padding of 14 on left
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-14-[v0]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":dividerLineView]))
        
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[v0]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":appsCollectionView]))
        
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[nameLabel(30)][v0][v1(0.5)]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": appsCollectionView, "v1": dividerLineView, "nameLabel": nameLabel]))
    }
    
    private let cellId = "cellId"
    
    //MARK: UICollectionView Delegate Methods
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
         if let appCategoryCount = appCategory?.apps?.count {
            return appCategoryCount
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! AppCell
        cell.app = appCategory?.apps?[indexPath.item]  //this is getting whats inside of AppCell's class didSet property
        
        return cell
    }
    
    //MARK: UICollectionViewDataSource Methods
    
    //margin from edge for collection view.. 14 margin from left and right
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsetsMake(0, 14, 0, 14)
    }
    
    //MARK: UICollectionViewDelegateFlowLayout Methods
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize.init(width: 100, height: frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("app selected")
        if let app = appCategory?.apps?[indexPath.item] {
            featuredAppsController.showAppDetailForApp(app: app)
        }
        
    }
    
    
}

//Custom cell that represents each cell inside of the second collection view
class AppCell: UICollectionViewCell {
    
    //when this property is set.....
    var app:App? {
        didSet {
            
            if let name = app?.name {
                nameLabel.text = name
                
                let rect = NSString(string: name).boundingRect(with: CGSize.init(width: frame.width, height: 1000), options: NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin), attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 14)], context: nil)
                
                //2 line name label
                if rect.height > 20 {
                    categoryLabel.frame = CGRect.init(x: 0, y: frame.width + 38, width: frame.width, height: 20)
                    priceLabel.frame = CGRect.init(x: 0, y: frame.width + 56, width: frame.width, height: 20)
                } else {
                    //1 line name label
                    categoryLabel.frame = CGRect.init(x: 0, y: frame.width + 20, width: frame.width, height: 20)
                    priceLabel.frame = CGRect.init(x: 0, y: frame.width + 40, width: frame.width, height: 20)
                }
                
                nameLabel.frame = CGRect.init(x: 0, y: frame.width + 5, width: frame.width, height: 40)
                nameLabel.sizeToFit() //called to redraw the labels
            }
            
            if let category = categoryLabel.text {
                categoryLabel.text = category
            }
            
            //unwrap to add dollar sign before price
            if let price = app?.price {
                priceLabel.text = "$\(price.stringValue)"
            } else {
                priceLabel.text = "" //some apps in the app store are completely free
            }
            
            if let imageName = app?.imageName {
                imageView.image = UIImage(named: imageName)
            }
            
            
        }
    }
    
    //initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //properties
    
    //image view inside of cell
    let imageView: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "page2")
        iv.contentMode = .scaleAspectFill //maintains aspect ratio of the image
        iv.layer.cornerRadius = 16
        iv.layer.masksToBounds = true
        return iv
    }()
    
    // name of app inside of cell
    let nameLabel: UILabel = {
        let label = UILabel()
        label.text = "Disney Build It: Frozen"
        label.font = UIFont.systemFont(ofSize: 13)
        label.numberOfLines = 2
        return label
    }()
    
    //app category inside of cell
    let categoryLabel: UILabel = {
        let label = UILabel()
        label.text = "Entertainment"
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = UIColor.gray
        label.numberOfLines = 1
        return label
    }()
    
    //app price inside of cell
    let priceLabel: UILabel = {
        let label = UILabel()
        label.text = "$3.99"
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = UIColor.gray
        label.numberOfLines = 1
        return label
    }()
    
    

    func setupViews() {
        
        addSubview(imageView)
        addSubview(nameLabel)
        addSubview(categoryLabel)
        addSubview(priceLabel)
        
        imageView.frame = CGRect.init(x: 0, y: 0, width: frame.width, height: frame.width)
        nameLabel.frame = CGRect.init(x: 0, y: frame.width + 2, width: frame.width, height: 40)
        categoryLabel.frame = CGRect.init(x: 0, y: frame.width + 38, width: frame.width, height: 20)
        priceLabel.frame = CGRect.init(x: 0, y: frame.width + 56, width: frame.width, height: 20)
        //backgroundColor = UIColor.black

    }
}
































