//
//  Video.swift
//  YoutubeClone
//
//  Created by Devin Reich on 9/17/17.
//  Copyright © 2017 Devin Reich. All rights reserved.
//

import UIKit

class Video: NSObject {
    var thumbnailImageName: String?
    var title: String?
    var numberOfViews: NSNumber?
    var date: NSDate?
    
    var channel: Channel?
}

class Channel: NSObject {
    var name: String?
    var profileImageName: String?
}
