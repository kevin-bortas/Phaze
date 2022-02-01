//
//  MainActivityDisplayController.swift
//  Phaze
//
//  Created by Kevin Bortas on 27/01/2022.
//  Copyright © 2022 UnKnown. All rights reserved.
//

import UIKit

class MainActivityDisplayController: UIViewController {
    // PAGE CONTROLLER CODE
    @IBOutlet weak var contentView: UIView!
    
    let dataSource = ["View Controller One", "View Controller Two", "View Controller Three"]
    
    var currentViewControllerIndex = 1
    
    func configurePageViewController () {
        
        guard let pageViewController = storyboard?.instantiateViewController(withIdentifier: "CustomPageViewController") as?
                CustomPageViewController else {
                    return
                }
        
        pageViewController.delegate = self
        pageViewController.dataSource = self
        
        addChild(pageViewController)
        pageViewController.didMove(toParent: self)
        
        pageViewController.view.translatesAutoresizingMaskIntoConstraints = false
        
        let screenWidth = self.view.frame.size.width
        let screenHeight = self.view.frame.size.height
        contentView.frame = CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight)
        contentView.addSubview(pageViewController.view)
        
        let views: [String: Any] = ["pageView": pageViewController.view]
        
        contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[pageView]-0-|",
                                                                 options: NSLayoutConstraint.FormatOptions(rawValue: 0),
                                                                 metrics: nil,
                                                                 views: views))
        
        contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[pageView]-0-|",
                                                                 options: NSLayoutConstraint.FormatOptions(rawValue: 0),
                                                                 metrics: nil,
                                                                 views: views))
        
        guard let startingViewController = detailViewControllerAt(index: currentViewControllerIndex) else {
            return
        }
        
        pageViewController.setViewControllers([startingViewController], direction: .forward, animated: true)
    }
    
    func detailViewControllerAt(index: Int) -> UIViewController? {
        
        if index >= dataSource.count || dataSource.count == 0{
            return nil
        }
        
        if index == 0 {
            guard let dataViewController = storyboard?.instantiateViewController(withIdentifier: String(describing: SettingsViewController.self)) as? SettingsViewController else {
                return nil
            }
            
            // Change this to change details of displayed view controller
            dataViewController.index = index
            
//            dataViewController.displayText = dataSource[index]
            
            
            return dataViewController
        }

        else if index == 1 {
            guard let dataViewController = storyboard?.instantiateViewController(withIdentifier: String(describing: MainActivityViewController.self)) as? MainActivityViewController else {
                return nil
            }
            
            // Change this to change details of displayed view controller
            dataViewController.index = index
//            dataViewController.displayText = dataSource[index]
            
            
            return dataViewController
        }

        else {
//            guard let dataViewController = storyboard?.instantiateViewController(withIdentifier: String(describing: DiaryViewController) as? DataViewController else {
//                return nil
//            }
                guard let dataViewController = storyboard?.instantiateViewController(withIdentifier: String(describing: DiaryViewController.self)) as? DiaryViewController else {
                return nil
            }
            
            // Change this to change details of displayed view controller
            dataViewController.index = index
//            dataViewController.displayText = dataSource[index]
            
            
            return dataViewController
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configurePageViewController()
    }
}

extension MainActivityDisplayController: UIPageViewControllerDelegate, UIPageViewControllerDataSource {
    
    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        return currentViewControllerIndex
    }
    
    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        return dataSource.count
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
//        let dataViewController = viewController as? DataViewController
//        print(dataViewController)
        
        let dataViewController = viewController as? MainActivityViewController
        
//        var currentIndex = viewController.index
        
        guard var currentIndex = dataViewController?.index else {
            return nil
        }
        
        currentViewControllerIndex = currentIndex
        
        if currentIndex == 0 {
            return nil
        }
        
        currentIndex -= 1
        
        return detailViewControllerAt(index: currentIndex)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        print(viewController)
        let dataViewController = viewController as? MainActivityViewController
        
        guard var currentIndex = dataViewController?.index else {
            return nil
        }
        
        if currentIndex == dataSource.count {
            return nil
        }
        
        currentIndex += 1
        currentViewControllerIndex = currentIndex
        
        return detailViewControllerAt(index: currentIndex)
    }
    
}
