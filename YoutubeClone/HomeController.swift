//
//  ViewController.swift
//  YoutubeClone
//
//  Created by Devin Reich on 9/14/17.
//  Copyright © 2017 Devin Reich. All rights reserved.
//

import UIKit

class HomeController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    /* var videos: [Video] = {
        var kanyeChannel = Channel()
        kanyeChannel.name = "KanyeIsTheBestChannel"
        kanyeChannel.profileImageName = "kanye_profile"
        
        var blankSpaceVideo = Video()
        blankSpaceVideo.title = "Taylor Swift - Blank Space"
        blankSpaceVideo.thumbnailImageName = "taylor_swift_blank_space"
        blankSpaceVideo.channel = kanyeChannel
        blankSpaceVideo.numberOfViews = 1604684607
        
        
        var badBloodVideo = Video()
        badBloodVideo.title = "Taylor Swift - Bad Blood featuring Kendrick Lamar"
        badBloodVideo.thumbnailImageName = "taylor_swift_bad_blood"
        badBloodVideo.channel = kanyeChannel
        badBloodVideo.numberOfViews = 1604684607
        
        return [blankSpaceVideo, badBloodVideo]
    }() */
    
    var videos: [Video]?
    
    func fetchVideos() {
        let url = URL(string: "https://s3-us-west-2.amazonaws.com/youtubeassets/home.json")
        URLSession.shared.dataTask(with: url!) { (data, response, error) in
            if error != nil {
                print(error.debugDescription)
                return
            }
            do {
                let json = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers)
                
                self.videos = [Video]()
                
                
                for dictionary in json as! [[String: Any]] {
                    let video = Video()
                    
                    video.title = (dictionary["title"] as! String)
                    video.thumbnailImageName = dictionary["thumbnail_image_name"] as? String
                    
                    let channelDictionary = dictionary["channel"] as! [String: Any]
                    let channel = Channel()
                    channel.name = channelDictionary["name"] as? String
                    channel.profileImageName = channelDictionary["profile_image_name"] as? String
                    
                    video.channel = channel
                    self.videos?.append(video)
                    
                }
                DispatchQueue.main.async(execute: { 
                    self.collectionView?.reloadData()
                })
            } catch let jsonError {
                print(jsonError)
            }
        }.resume()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchVideos()
        
        navigationItem.title = "Home"
        navigationController?.navigationBar.isTranslucent = false
        
        let titleLabel = UILabel(frame: CGRect(x: 0, y: 0, width: view.frame.width - 32, height: view.frame.height))
        titleLabel.text = "Home"
        titleLabel.textColor = UIColor.white
        titleLabel.font = UIFont.systemFont(ofSize: 20)
        navigationItem.titleView = titleLabel
        
        
        collectionView?.backgroundColor = UIColor.white
        
        collectionView?.register(VideoCell.self, forCellWithReuseIdentifier: "cellID")
        
        collectionView?.contentInset = UIEdgeInsetsMake(50, 0, 0, 0)
        collectionView?.scrollIndicatorInsets = UIEdgeInsetsMake(50, 0, 0, 0)
        
        setupMenuBar()
        setupNavBarButtons()
    }
    
    let menuBar: MenuBar = {
        let mb = MenuBar()
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
        view.addSubview(menuBar)
        view.addConstraintsWithFormat(format: "H:|[v0]|", views: menuBar)
        view.addConstraintsWithFormat(format: "V:|[v0(50)]|", views: menuBar)
    }
    
    func handleSearch() {
        print("123")
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
        settingViewController.navigationItem.title = setting.name
        navigationController?.navigationBar.tintColor = UIColor.white
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
        navigationController?.pushViewController(settingViewController, animated: true)
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return videos?.count ?? 0
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellID", for: indexPath) as! VideoCell
        
        cell.video = videos?[indexPath.item]
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let height = (view.frame.width - 32) * (9 / 16) // width - edges times the aspect ratio
        
        return CGSize(width: view.frame.width, height: height + 16 + 68) // 16 for space above image view and 68 for the height below it
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}
