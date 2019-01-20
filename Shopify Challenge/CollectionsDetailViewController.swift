//
//  CollectionsDetailViewController.swift
//  Shopify Challenge
//
//  Created by Martin Jr Powlette on 2019-01-16.
//  Copyright © 2019 Martin Jr Powlette. All rights reserved.
//

import UIKit

class CollectionsDetailViewController: UITableViewController {

    @IBOutlet private var xibView: XibView!
    @IBOutlet private var descriptionLabel: UILabel!
    
    var collection: Collection?
    
    var contentView: CollectionBannerView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupBannerView()
        title = collection?.title
        descriptionLabel.text = collection?.description
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.navigationBar.prefersLargeTitles = false
        //navigationController?.navigationBar.setValue(true, forKey: "hidesShadow")
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        navigationController?.navigationBar.setValue(false, forKey: "hidesShadow")
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        guard let headerView = tableView.tableHeaderView else { return }
        
        let size = headerView.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
        if headerView.frame.size.height != size.height {
            headerView.frame.size.height = size.height
            tableView.tableHeaderView = headerView
            tableView.layoutIfNeeded()
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 100
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SubtitleProductCell", for: indexPath)

        cell.textLabel?.text = "Product Title"
        
        let boldTextAttribute: [NSAttributedString.Key: Any] = [
            .font: UIFont.boldSystemFont(ofSize: cell.detailTextLabel!.font.pointSize)
        ]
        
        let quantityStatusText = NSAttributedString(string: "Available: ")
        let quantityText = NSAttributedString(string: "55", attributes: boldTextAttribute)
        
        let quantityLabelText = NSMutableAttributedString()
        quantityLabelText.append(quantityStatusText)
        quantityLabelText.append(quantityText)
        
        cell.detailTextLabel?.attributedText = quantityLabelText

        return cell
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Products"
    }
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard let contentView = contentView, let navigationController = navigationController else { return }
        
        let endBannerViewYCoordinate = contentView.frame.maxY - navigationController.navigationBar.frame.height - 16
        let bannerViewIsOnScreen = scrollView.contentOffset.y > endBannerViewYCoordinate
        
        if bannerViewIsOnScreen {
            navigationController.navigationBar.setValue(false, forKey: "hidesShadow")
        } else {
            navigationController.navigationBar.setValue(true, forKey: "hidesShadow")
        }
    }
    
    private func setupBannerView() {
        contentView = xibView.contentView as? CollectionBannerView
        contentView?.titleText = collection?.title
        contentView?.image = collection?.image
        contentView?.layer.addBorder(edge: .bottom,
                                     color: UIColor.black.withAlphaComponent(0.3),
                                     thickness: 0.5)
    }
}
