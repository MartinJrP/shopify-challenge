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
    
    var collection: CustomCollection?
    var collectionImage: UIImage?
    
    var bannerView: CollectionBannerView?
    
    var downloadManager: DownloadManager!
    var products = [Product]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupBannerView()
        title = collection?.title
        descriptionLabel.text = collection?.description
        bannerView?.image = collectionImage
        
        if collection?.description == nil {
            descriptionLabel.isHidden = true
        }
        
        reloadProducts()
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
        return products.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SubtitleProductCell", for: indexPath)
        let product = products[indexPath.row]

        cell.textLabel?.text = product.title
        
        let boldTextAttribute: [NSAttributedString.Key: Any] = [
            .font: UIFont.boldSystemFont(ofSize: cell.detailTextLabel!.font.pointSize)
        ]
        
        let quantityStatusText = NSAttributedString(string: "Available: ")
        let quantityText = NSAttributedString(string: product.totalQuantity.description,
                                              attributes: boldTextAttribute)
        
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
        guard let contentView = bannerView, let navigationController = navigationController else { return }
        
        let endBannerViewYCoordinate = contentView.frame.maxY - navigationController.navigationBar.frame.height - 16
        let bannerViewIsOnScreen = scrollView.contentOffset.y > endBannerViewYCoordinate
        
        if bannerViewIsOnScreen {
            navigationController.navigationBar.setValue(false, forKey: "hidesShadow")
        } else {
            navigationController.navigationBar.setValue(true, forKey: "hidesShadow")
        }
    }
    
    private func setupBannerView() {
        bannerView = xibView.contentView as? CollectionBannerView
        bannerView?.titleText = collection?.title
        //contentView?.image = collection?.image
        bannerView?.layer.addBorder(edge: .bottom,
                                     color: UIColor.black.withAlphaComponent(0.3),
                                     thickness: 0.5)
    }
    
    @IBAction func reloadProducts() {
        tableView.refreshControl?.beginRefreshing()
        guard let collection = collection else {
            navigationController?.popViewController(animated: true)
            return
        }
        
        downloadManager.fetchProducts(for: collection.id) { (updatedProducts, error) in
            guard error == nil else {
                self.alert(with: "Download Error", message: error!.localizedDescription)
                self.refreshControl?.endRefreshing()
                return
            }
            
            DispatchQueue.main.async {
                self.reloadTableView(with: updatedProducts!)
                self.refreshControl?.endRefreshing()
            }
        }
    }
    
    private func reloadTableView(with newProducts: [Product]) {
        tableView.performBatchUpdates({
            if !products.isEmpty {
                let indexPathes = self.products.enumerated().map({
                    IndexPath(row: $0.offset, section: 0)
                })
                tableView.deleteRows(at: indexPathes, with: .fade)
            }
            
            products = newProducts
            
            let indexPathes = newProducts.enumerated().map({
                IndexPath(row: $0.offset, section: 0)
            })
            tableView.insertRows(at: indexPathes, with: .fade)
        }, completion: nil)
    }
}
