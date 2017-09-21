//
//  APIService.swift
//  YoutubeClone
//
//  Created by Devin Reich on 9/20/17.
//  Copyright © 2017 Devin Reich. All rights reserved.
//

import UIKit

class APIService: NSObject {
    static let sharedInstance = APIService()
    
    let baseUrl = "https://s3-us-west-2.amazonaws.com/youtubeassets/"
    
    func fetchVideos(completion: @escaping ([Video]) -> ()) {
        fetchVideosForUrlString(urlString: "\(baseUrl)home.json", completion: completion)
    }
    
    func fetchTrendingFeed(completion: @escaping ([Video]) -> ()) {
        fetchVideosForUrlString(urlString: "\(baseUrl)trending.json", completion: completion)
    }
    
    func fetchSubscriptionFeed(completion: @escaping ([Video]) -> ()) {
        fetchVideosForUrlString(urlString: "\(baseUrl)subscriptions.json", completion: completion)
    }
    
    func fetchVideosForUrlString(urlString: String, completion: @escaping ([Video]) -> ()) {
        let url = URL(string: urlString)
        URLSession.shared.dataTask(with: url!) { (data, response, error) in
            if error != nil {
                print(error.debugDescription)
                return
            }
            do {
                let json = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers)
                
                var videos = [Video]()
                
                
                for dictionary in json as! [[String: Any]] {
                    let video = Video()
                    
                    video.title = (dictionary["title"] as! String)
                    video.thumbnailImageName = dictionary["thumbnail_image_name"] as? String
                    
                    let channelDictionary = dictionary["channel"] as! [String: Any]
                    let channel = Channel()
                    channel.name = channelDictionary["name"] as? String
                    channel.profileImageName = channelDictionary["profile_image_name"] as? String
                    
                    video.channel = channel
                    videos.append(video)
                    
                }
                
                DispatchQueue.main.async(execute: {
                    completion(videos)
                })
            } catch let jsonError {
                print(jsonError)
            }
            
            }.resume()
    }
}

/*
 
 let json = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers)
 
 var videos = [Video]()
 
 
 for dictionary in json as! [[String: Any]] {
 let video = Video()
 
 video.title = (dictionary["title"] as! String)
 video.thumbnailImageName = dictionary["thumbnail_image_name"] as? String
 
 let channelDictionary = dictionary["channel"] as! [String: Any]
 let channel = Channel()
 channel.name = channelDictionary["name"] as? String
 channel.profileImageName = channelDictionary["profile_image_name"] as? String
 
 video.channel = channel
 videos.append(video)
 
 }
 
 DispatchQueue.main.async(execute: {
 completion(videos)
 */
