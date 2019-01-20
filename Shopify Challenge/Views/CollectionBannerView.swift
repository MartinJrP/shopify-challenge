//
//  CollectionBannerView.swift
//  Shopify Challenge
//
//  Created by Martin Jr Powlette on 2019-01-16.
//  Copyright © 2019 Martin Jr Powlette. All rights reserved.
//

import UIKit

class CollectionBannerView: UIView {

    @IBOutlet private var titleLabel: UILabel!
    @IBOutlet private var imageView: UIImageView!
    
    public var titleText: String? {
        didSet { setNeedsLayout() }
    }
    public var image: UIImage? {
        didSet { setNeedsLayout() }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        titleLabel.text = titleText
        imageView.image = image
    }

    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        
        titleLabel.text = "Label Text"
        imageView.image = UIImage(named: "Aerodynamic")
    }
}
