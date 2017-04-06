//
//  Models.swift
//  App Store
//
//  Created by Matt Houston on 1/19/17.
//  Copyright © 2017 App Store. All rights reserved.
//

import Foundation
import UIKit

//This is a model file instead of a models folder. all models are here

class FeaturedApps: NSObject {
    var bannerCategory: AppCategory?
    var appCategories: [AppCategory]?
    
    override func setValue(_ value: Any?, forKey key: String) {
        if key == "categories" {
            appCategories = [AppCategory]()
            for dict in value as! [[String: AnyObject]] {
                let appCategory = AppCategory()
                appCategory.setValuesForKeys(dict)
                appCategories?.append(appCategory)
            }
        } else if key == "bannerCategory" {
            bannerCategory = AppCategory()
            bannerCategory?.setValuesForKeys(value as! [String: AnyObject])
        } else {
            super.setValue(value, forKey: key)
        }
    }
}

class AppCategory: NSObject {
    
    //define properties
    var name: String?
    var type: String?
    
    var apps: [App]?
    
    //when i encounter the key "apps" in the json do some special initialization. //the value is initially an array of NSDictionaries. Change the value to the 'App' class
    override func setValue(_ value: Any?, forKey key: String) {
        if key == "apps" {
            
            apps = [App]()
            for dict in value as! [[String: AnyObject]] {
                let app = App()
                app.setValuesForKeys(dict)
                apps?.append(app)
            }
            
        } else {
            super.setValue(value, forKey: key)
        }
    }
    
    //get json data from web service
    static func fetchFeaturedApps(completionHandler:@escaping (FeaturedApps)-> ()) {
        
        let urlString = "http://www.statsallday.com/appstore/featured"
        
        URLSession.shared.dataTask(with:NSURL(string: urlString)! as URL) { (data, response, error) in
            
            //print(data ?? "default")
            
            if error != nil {
                print(error?.localizedDescription ?? "error")
                return //then return out of this block
            }
            
            //serialize the data in the json
            
            do {
                
                //cast to dictionary.. look at json so that it makes sense
                let json = try (JSONSerialization.jsonObject(with: data!, options: .mutableContainers)) as! [String:AnyObject] //comes back as one large dictionay
                
                let featuredApps = FeaturedApps()
                featuredApps.setValuesForKeys(json as [String:Any])
                
                
                
                //var appCategories = [AppCategory]() //empty array of App Categories
                
                
//                //it's an array of dictionaries //get to categories and loop over array //cast to array of dictionaries.. look at json so that it makes sense to you
//                for dict in json["categories"] as! [[String:AnyObject]]   {
//                    let appCategory = AppCategory()
//                    appCategory.setValuesForKeys(dict)  //or //appCategory.name = dict["name"] as! String? //appCategory.apps = dict["apps"] as? [App]
//                    appCategories.append(appCategory)
//                }
                
                DispatchQueue.main.async(execute: { 
                    completionHandler(featuredApps)
                })
                
                print("cccc\(featuredApps)")
                
            } catch let err {
                print(err)
            }
            
        } .resume()
    }
}

class App: NSObject {
    
    //define properties
    var id: NSNumber? //for POST request
    var name: String?
    var category: String?
    var price: NSNumber?
    var imageName: String?
    
    var screenshots: [String]?
    var desc: String?
    var appInformation: AnyObject?
    
    override func setValue(_ value: Any?, forKey key: String) {
        if key == "description" {
            self.desc = value as? String
        } else {
            super.setValue(value, forKey: key)
        }
    }
}







//    static func sampleAppCategories() -> [AppCategory] {
//        let bestNewAppsCategory = AppCategory()
//        bestNewAppsCategory.name = "Best New Apps"
//
//        var apps = [App]() //empty
//
//        let frozenApp = App()
//        frozenApp.name = "Disney build it"
//        frozenApp.imageName = "page2"
//        frozenApp.category = "Entertainment"
//        frozenApp.price = NSNumber(value: 3.99)
//        apps.append(frozenApp)
//
//
//        bestNewAppsCategory.apps = apps
//
//        let newGamesCategory = AppCategory()
//        newGamesCategory.name = "Best New Games"
//
//        var newGameApps = [App]() //empty
//
//        let telepaintApp = App()
//        telepaintApp.name = "telepaint"
//        telepaintApp.category = "category"
//        telepaintApp.price = NSNumber(value:2.99)
//        telepaintApp.imageName = "page2"
//        newGameApps.append(telepaintApp)
//
//        newGamesCategory.apps = newGameApps
//
//        return [bestNewAppsCategory, newGamesCategory]
//    }




















