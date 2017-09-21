//
//  TrendingCell.swift
//  YoutubeClone
//
//  Created by Devin Reich on 9/20/17.
//  Copyright © 2017 Devin Reich. All rights reserved.
//

import UIKit

class TrendingCell: FeedCell {

    override func fetchVideos() {
        APIService.sharedInstance.fetchTrendingFeed { (videos: [Video]) in
            self.videos = videos
            self.collectionView.reloadData()
        }
    }

}
