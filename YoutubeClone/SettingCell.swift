//
//  SettingCell.swift
//  YoutubeClone
//
//  Created by Devin Reich on 9/18/17.
//  Copyright © 2017 Devin Reich. All rights reserved.
//

import UIKit

class SettingCell: BaseCell {
    
    override var isHighlighted: Bool {
        didSet {
            backgroundColor = isHighlighted ? UIColor.darkGray : UIColor.white
            
            cellLabel.textColor = isHighlighted ? UIColor.white : UIColor.black
            
            cellImage.tintColor = isHighlighted ? UIColor.white : UIColor.darkGray
        }
    }
    
    var setting: Setting? {
        didSet {
            cellLabel.text = setting?.name
            if let imageName = setting?.imageName {
                cellImage.image = UIImage(named: imageName)?.withRenderingMode(.alwaysTemplate)
                
                cellImage.tintColor = UIColor.darkGray
            }
        }
    }
    let cellLabel: UILabel = {
        let label = UILabel()
        label.text = "Settings"
        label.font = UIFont.systemFont(ofSize: 13)
        return label
    }()
    let cellImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "settings")
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    override func setupViews() {
        super.setupViews()
        
        addSubview(cellLabel)
        addSubview(cellImage)
        
        addConstraintsWithFormat(format: "H:|-8-[v0(30)]-8-[v1]|", views: cellImage, cellLabel)
        addConstraintsWithFormat(format: "V:|[v0]|", views: cellLabel)
        addConstraintsWithFormat(format: "V:[v0(30)]", views: cellImage)
        
        addConstraint(NSLayoutConstraint(item: cellImage, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0))
    }
}
