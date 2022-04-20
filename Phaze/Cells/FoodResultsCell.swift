//
//  FoodResultsCell.swift
//  Phaze
//
//  Created by Kevin Bortas on 23/01/2022.
//  Copyright © 2022 UnKnown. All rights reserved.
//

import UIKit
import Charts

class BaseCell: UICollectionViewCell {
    override init(frame: CGRect){
        super.init(frame: frame)
        setupViews()
    }
    
    func setupViews(){
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class FoodResultsCell: BaseCell, ChartViewDelegate {
    
    override var isHighlighted: Bool {
        didSet {
            backgroundColor = isHighlighted ? UIColor.darkGray : UIColor.white
            
            name.textColor = isHighlighted ? UIColor.white : UIColor.black
        }
    }
    
    var foodResults: FoodResults? {
        didSet {
            name.text = foodResults?.name
        }
    }
    
    var name: UILabel = {
        var label = UILabel()
        return label
    }()
    
    func addConstraintsWithFormat(_ format: String, views: UIView...) {
        var viewsDictionary = [String: UIView]()
        for (index, view) in views.enumerated() {
            let key = "v\(index)"
            view.translatesAutoresizingMaskIntoConstraints = false
            viewsDictionary[key] = view
        }
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: format, options: NSLayoutConstraint.FormatOptions(), metrics: nil, views: viewsDictionary))
    }
    
    override func setupViews() {
        super.setupViews()
        
        addSubview(name)
        
        addConstraintsWithFormat("H:|[v0]|", views: name)
        addConstraintsWithFormat("V:|[v0]|", views: name)
    }
}
