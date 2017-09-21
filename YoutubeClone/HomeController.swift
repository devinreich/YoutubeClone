//
//  ViewController.swift
//  YoutubeClone
//
//  Created by Devin Reich on 9/14/17.
//  Copyright © 2017 Devin Reich. All rights reserved.
//

import UIKit

class HomeController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    let cellID = "cellID"
    let trendingID = "trendingCell"
    let subscriptionID = "subscriptionCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.isTranslucent = false
        
        let titleLabel = UILabel(frame: CGRect(x: 0, y: 0, width: view.frame.width - 32, height: view.frame.height))
        titleLabel.text = "  Home"
        titleLabel.textColor = UIColor.white
        titleLabel.font = UIFont.systemFont(ofSize: 20)
        navigationItem.titleView = titleLabel
        
        
        
        setupCollectionView()
        setupMenuBar()
        setupNavBarButtons()
    }
    
    func setupCollectionView() {
        if let flowlayout = collectionView?.collectionViewLayout as? UICollectionViewFlowLayout {
            flowlayout.scrollDirection = .horizontal
            flowlayout.minimumLineSpacing = 0
        }
        
        collectionView?.backgroundColor = UIColor.white
        
        collectionView?.isPagingEnabled = true

        collectionView?.register(FeedCell.self, forCellWithReuseIdentifier: cellID)
        collectionView?.register(TrendingCell.self, forCellWithReuseIdentifier: trendingID)
        collectionView?.register(SubscriptionCell.self, forCellWithReuseIdentifier: subscriptionID)
    
        collectionView?.contentInset = UIEdgeInsetsMake(50, 0, 0, 0)
        collectionView?.scrollIndicatorInsets = UIEdgeInsetsMake(50, 0, 0, 0)
    }
    
    lazy var menuBar: MenuBar = {
        let mb = MenuBar()
        mb.homeController = self
        return mb
    }()
    
    func setupNavBarButtons() {
        let searchImage = UIImage(named: "search_icon")?.withRenderingMode(.alwaysOriginal)
        let searchBarButtonItem = UIBarButtonItem(image: searchImage, style: .plain, target: self, action: #selector(handleSearch))
        
        let moreButtonImage = UIImage(named: "nav_more_icon")?.withRenderingMode(.alwaysOriginal)
        let moreButton = UIBarButtonItem(image: moreButtonImage, style: .plain, target: self, action: #selector(handleMore))
        
        navigationItem.rightBarButtonItems = [moreButton, searchBarButtonItem]
    }
    
    private func setupMenuBar() {
        navigationController?.hidesBarsOnSwipe = true
        
        let redView = UIView()
        redView.backgroundColor = UIColor.rgb(red: 230, green: 32, blue: 31, alpha: 1)
        view.addSubview(redView)
        view.addConstraintsWithFormat(format: "H:|[v0]|", views: redView)
        view.addConstraintsWithFormat(format: "V:[v0(50)]", views: redView)
        
        view.addSubview(menuBar)
        view.addConstraintsWithFormat(format: "H:|[v0]|", views: menuBar)
        view.addConstraintsWithFormat(format: "V:[v0(50)]", views: menuBar)
        
        menuBar.topAnchor.constraint(equalTo: topLayoutGuide.bottomAnchor).isActive = true
    }
    
    private func setTitleForIndex(index: Int) {
        if let titleLable = navigationItem.titleView as? UILabel {
            titleLable.text = "  \(titles[index])"
        }
    }
    
    func handleSearch() {
        print("123")
    }
    
    func scrollToMenuIndexPath(menuIndex: Int) {
        let indexPath = IndexPath(item: menuIndex, section: 0)
        collectionView?.scrollToItem(at: indexPath, at: [], animated: true)
        
        setTitleForIndex(index: menuIndex)
    }
    
    lazy var settingsLauncher: SettingsLauncher = {
        let launcher = SettingsLauncher()
        launcher.homeController = self
        return launcher
    }()
    
    func handleMore() {
        // show menu
        settingsLauncher.showSettings()
    }
    
    func showControllerForSetting(setting: Setting) {
        let settingViewController = UIViewController()
        settingViewController.view.backgroundColor = UIColor.white
        settingViewController.navigationItem.title = setting.name.rawValue
        navigationController?.navigationBar.tintColor = UIColor.white
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
        navigationController?.pushViewController(settingViewController, animated: true)
    }
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        menuBar.horizontalBarLeftAnchorConstraint?.constant = scrollView.contentOffset.x / 4
    }
    
    let titles = ["Home", "Trending", "Subscriptions", "Account"]
    
    override func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let index = targetContentOffset.pointee.x / view.frame.width
        let indexPath = IndexPath(item: Int(index), section: 0)
        menuBar.collectionView.selectItem(at: indexPath, animated: true, scrollPosition: [])
        
        setTitleForIndex(index: Int(index))
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if indexPath.item == 1 {
             return collectionView.dequeueReusableCell(withReuseIdentifier: trendingID, for: indexPath)
        }
        
        if indexPath.item == 2 {
            return collectionView.dequeueReusableCell(withReuseIdentifier: subscriptionID, for: indexPath)
        }
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: view.frame.height - 50)
    }
}
