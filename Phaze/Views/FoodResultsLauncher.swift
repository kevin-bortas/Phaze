//
//  FoodResultsLauncher.swift
//  Phaze
//
//  Created by Kevin Bortas on 23/01/2022.
//  Copyright © 2022 UnKnown. All rights reserved.
//

import Foundation
import UIKit

class FoodResults: NSObject{
    let name: String
    let imageName: String
    
    init(name: String, imageName: String){
        self.name = name
        self.imageName = imageName
    }
}

class FoodResultsLauncher: NSObject, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
        
    let blackview = UIView()
    let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = UIColor.white
        return cv
    }()
    
    let foodViewController = FoodViewController()
    
    let cellId = "cellId"
    
    let foodResults: [FoodResults] = {
        return [FoodResults(name: "FoodResults", imageName: "Name"),
                FoodResults(name: "Pie Chart", imageName: "Name"),
                FoodResults(name: "Calorie Info", imageName: "Name"),
                FoodResults(name: "Add Button", imageName: "Name"),]
    }()
    
    var mainActivity: MainActivityViewController?
    
    var imageView = UIImageView()
    
    func setImageView(image: UIImageView){
        self.imageView = image
    }
    
    func displayResults(){
        
        if let window = UIApplication.shared.keyWindow {
            blackview.backgroundColor = UIColor(white: 0, alpha: 0.5)
            
            blackview.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleDismiss)))
            
            window.addSubview(imageView)
            window.addSubview(blackview)
            window.addSubview(collectionView)
            
            let height: CGFloat = CGFloat(foodResults.count) * 100
            let y = window.frame.height - height
            collectionView.frame = CGRect(x: 0, y: window.frame.height, width: window.frame.width, height: height)
            
            blackview.frame = window.frame
            blackview.alpha = 0
            
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                self.blackview.alpha = 1
                self.collectionView.frame = CGRect(x: 0, y: y, width: self.collectionView.frame.width, height: self.collectionView.frame.height)
            }, completion: nil)
        }
    }
    
    @objc func handleDismiss() {
        UIView.animate(withDuration: 0.5, animations: {
            self.blackview.alpha = 0
            
            if let window = UIApplication.shared.keyWindow {
                self.collectionView.frame = CGRect(x: 0, y: window.frame.height, width: self.collectionView.frame.width, height: self.collectionView.frame.height)
                self.imageView.image = nil
            }
        })
    }
    
    func collectionView(_ collectionView: UICollectionView,
        numberOfItemsInSection section: Int) -> Int {
        return foodResults.count
    }
    
    func collectionView(_ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! FoodResultsCell
        
        let foodResults = foodResults[indexPath.item]
        cell.foodResults = foodResults
        return cell
    }
    
    // Controls size of collection view rows
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 50)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let foodResults = foodResults[indexPath.item]
        switch foodResults.name {
        case "Add Button":
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                self.blackview.alpha = 0
                
                if let window = UIApplication.shared.keyWindow {
                    self.collectionView.frame = CGRect(x: 0, y: window.frame.height, width: self.collectionView.frame.width, height: self.collectionView.frame.height)
                    self.imageView.image = nil
                }
            }) { (completion: Bool) in
                self.mainActivity?.goToFoodView()
            }
        default:
            break
        }
    }
    
//    func goToFoodView(){
//        let foodViewController = UIViewController()
//        UINavigationController?.pushViewController(foodViewController, animated: true)
//    }
    
    override init(){
        super.init()
        
        collectionView.dataSource = self
        collectionView.delegate = self
        
        collectionView.register(FoodResultsCell.self, forCellWithReuseIdentifier: cellId)
    }
}
