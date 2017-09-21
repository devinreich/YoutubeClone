//
//  SubscriptionCell.swift
//  YoutubeClone
//
//  Created by Devin Reich on 9/20/17.
//  Copyright © 2017 Devin Reich. All rights reserved.
//

import UIKit

class SubscriptionCell: FeedCell {

    override func fetchVideos() {
        APIService.sharedInstance.fetchSubscriptionFeed { (videos: [Video]) in
            self.videos = videos
            self.collectionView.reloadData()
        }
    }

}
