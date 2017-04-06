//
//  AppDetailController.swift
//  App Store
//
//  Created by Matt Houston on 4/3/17.
//  Copyright © 2017 App Store. All rights reserved.
//

import UIKit

class AppDetailController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    
    private let cellId = "cellId"
    private let descriptionCellID = "descriptionCellId"
    
    //can be used to segue information
    var app: App? {
        didSet {
            
            if app?.screenshots != nil {
                return
            }
            
            navigationItem.title = app?.name
            
            if let id = app?.id {
                let urlString = "http://www.statsallday.com/appstore/appdetail?id=\(id)"
                URLSession.shared.dataTask(with: URL(string:urlString)!, completionHandler: { (data, response, error) in
                    
                    if error != nil {
                        print("error accessing url")
                    } else {
                        do {
                           let json = try(JSONSerialization.jsonObject(with: data!, options: .mutableContainers))
                            
                            let appDetail = App()
                            appDetail.setValuesForKeys(json as! [String: AnyObject])
                            
                            self.app = appDetail
                            
                            DispatchQueue.main.async(execute: {
                                self.collectionView?.reloadData()
                            })
                            
                        } catch {
                            print("error loading json data")
                        }
                    }
                    
                    
                }).resume()
            }
            
        }
    }
    
   private let headerId = "headerId"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView?.alwaysBounceVertical = true //scroll
        
        collectionView?.backgroundColor = UIColor.white
        
        //register header
        collectionView?.register(AppDetailHeader.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: headerId)
        
        //register cell
        collectionView?.register(ScreenshotsCell.self, forCellWithReuseIdentifier: cellId)
        
        //regidter description cell
        collectionView?.register(AppDetailDescriptionCell.self, forCellWithReuseIdentifier: descriptionCellID)
    }
    
     func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize.init(width: view.frame.width, height: 170)
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        
        //index 1 cell
        if indexPath.item == 1 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: descriptionCellID, for: indexPath) as! AppDetailDescriptionCell
            
            return cell
        }

        
        //index 0 cell
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! ScreenshotsCell
        cell.app = app
        
        return cell
    }
    
    
    //supplementary view for collectionView
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerId, for: indexPath) as! AppDetailHeader
        header.app = app
        
        return header
    }
    
    //size for header
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize.init(width: view.frame.width, height: 170)
    }
    
}

class AppDetailDescriptionCell: BaseCell {
    
    let descriptionTextView: UITextView = {
        let textView = UITextView()
        textView.text = "Sample Description"
        return textView
    }()
    
    override func setupViews() {
        super.setupViews()
        
        //add subviews
        addSubview(descriptionTextView)
        
        //add constraints to description text view
        addConstraintsWithFormat(format: "H:|-8-[v0]-8-|", views: descriptionTextView)
        addConstraintsWithFormat(format: "V:|-4-[v0]-4-|", views: descriptionTextView)
        
    }
}

//top header cell of collection view
class AppDetailHeader: BaseCell {
    
    var app: App? {
        didSet {
            
            if let imageName = app?.imageName {
                imageView.image = UIImage(named: imageName)
            }
            
            if let appTitle = app?.name {
                nameLabel.text = appTitle
            }
            
            if let price = app?.price {
                buyButton.setTitle("$\(price.stringValue)", for: .normal)
            } else {
                buyButton.setTitle("Buy", for: .normal)
            }
        }
    }
    
    //top header imageview
    let imageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.layer.cornerRadius = 16
        iv.layer.masksToBounds = true
        return iv
    }()
    
    //header segmented control
    let segmentedControl: UISegmentedControl = {
        let sc = UISegmentedControl(items: ["Details", "Reviews", "Related"])
        sc.tintColor = UIColor.darkGray
        sc.selectedSegmentIndex = 0
        return sc
    }()
    
    //app name label
    let nameLabel: UILabel = {
        let label = UILabel()
        label.text = "Test"
        return label
    }()
    
    //buy button
    let buyButton: UIButton = {
       let button = UIButton(type: .system)
       button.setTitle("Buy", for: .normal)
        button.layer.borderColor = UIColor(red: 0, green: 129/155, blue: 250/155, alpha: 1).cgColor
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 5
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        return button
    }()
    
    //divider line
    let dividerLineView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(white: 0.4, alpha: 0.4)
        return view
    }()
    
    override func setupViews() {
        super.setupViews()
        
        //add header cell subviews
        addSubview(imageView)
        addSubview(segmentedControl)
        addSubview(nameLabel)
        addSubview(buyButton)
        addSubview(dividerLineView)
        
        //top left image view constraints
        addConstraintsWithFormat(format: "H:|-14-[v0(100)]-8-[v1]|", views: imageView, nameLabel)
        addConstraintsWithFormat(format: "V:|-14-[v0(100)]", views: imageView)
        
        addConstraintsWithFormat(format: "V:|-14-[v0(20)]", views: nameLabel)
        
        //segmented control constraints
        addConstraintsWithFormat(format: "H:|-40-[v0]-40-|", views: segmentedControl)
        addConstraintsWithFormat(format: "V:[v0(34)]-8-|", views: segmentedControl)
        
        //buyButton constraints 
        addConstraintsWithFormat(format: "H:[v0(60)]-14-|", views: buyButton)
        addConstraintsWithFormat(format: "V:[v0(32)]-56-|", views: buyButton)
        
        //divider line constraints
        addConstraintsWithFormat(format: "H:|[v0]|", views: dividerLineView)
        addConstraintsWithFormat(format: "V:[v0(0.5)]|", views: dividerLineView)
  
    }
    
}

//BaseCell for all custom cells
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

// Constraint Helper Function
extension UIView {
    
    func addConstraintsWithFormat(format: String, views: UIView...) //views = array
    {
        var viewsDictionary = [String: UIView]()
        for (index, view) in views.enumerated() {
            let key = "v\(index)"
            viewsDictionary[key] = view
            view.translatesAutoresizingMaskIntoConstraints = false
        }
        
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: format, options: NSLayoutFormatOptions(), metrics: nil, views: viewsDictionary))
    }
}





















