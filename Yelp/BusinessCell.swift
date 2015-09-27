//
//  BusinessCell.swift
//  Yelp
//
//  Created by Yuichi Kuroda on 9/23/15.
//  Copyright (c) 2015 Yuichi Kuroda. All rights reserved.
//

import UIKit

class BusinessCell: UITableViewCell {
  @IBOutlet weak var nameLabel: UILabel!
  @IBOutlet weak var reviewsCountLabel: UILabel!
  @IBOutlet weak var distanceLabel: UILabel!
  @IBOutlet weak var categoriesLabel: UILabel!
  
  @IBOutlet weak var ratingImageView: UIImageView!
  @IBOutlet weak var thumbImageView: UIImageView!
  
  var business: Business! {
    didSet {
      nameLabel.text = business.name
      thumbImageView.setImageWithURL(business.imageURL)
      categoriesLabel.text = business.categories
      addressLabel.text = business.address
      reviewsCountLabel.text = "\(business.reviewCount!)"
      ratingImageView.setImageWithURL(business.ratingImageURL)
      distanceLabel.text = business.distance
    }
  }
  
  @IBOutlet weak var addressLabel: UILabel!
  override func awakeFromNib() {
    super.awakeFromNib()
    // Initialization code
    thumbImageView.layer.cornerRadius = 4.0
    thumbImageView.clipsToBounds = true
    
    nameLabel.preferredMaxLayoutWidth = nameLabel.frame.size.width
  }
  
  override func layoutSubviews() {
    super.layoutSubviews()
    
    nameLabel.preferredMaxLayoutWidth = nameLabel.frame.size.width
  }
  
  override func setSelected(selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
    
    // Configure the view for the selected state
  }
  
}
