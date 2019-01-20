//
//  CollectionTableViewCell.swift
//  Shopify Challenge
//
//  Created by Martin Jr Powlette on 2019-01-16.
//  Copyright © 2019 Martin Jr Powlette. All rights reserved.
//

import UIKit

class CollectionTableViewCell: UITableViewCell {

    @IBOutlet private var collectionBanner: CollectionBannerView!
    
    public var bannerText: String? {
        didSet { setNeedsLayout() }
    }
    public var bannerImage: UIImage? {
        didSet { setNeedsLayout() }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let banner = (UINib(nibName: "CollectionBannerView", bundle: .main).instantiate(withOwner: self, options: nil) as! [CollectionBannerView]).first!
        addSubview(banner)
        banner.frame = collectionBanner.frame
        collectionBanner = banner
        print("Loaded a banner from nib")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        collectionBanner.titleText = bannerText
        collectionBanner.image = bannerImage
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
