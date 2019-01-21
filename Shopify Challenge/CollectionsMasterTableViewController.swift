//
//  CollectionsTableViewController.swift
//  Shopify Challenge
//
//  Created by Martin Jr Powlette on 2019-01-16.
//  Copyright © 2019 Martin Jr Powlette. All rights reserved.
//

import UIKit

class CollectionsTableViewController: UITableViewController {
    
    private lazy var downloadManager = DownloadManager()
    internal var tasks = [URLSessionTask]()
    
    var collections = [CustomCollection]() {
        didSet { initializeImagesArray() }
    }
    var images = [UIImage?]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.prefetchDataSource = self
        registerTableViewCells()
        reloadCollections()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.barTintColor = .white
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return collections.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CollectionCell", for: indexPath) as! CollectionTableViewCell
        let collection = collections[indexPath.row]
        
        cell.bannerText = collection.title
        if let image = images[indexPath.row] {
            cell.bannerImage = image
        } else {
            cell.bannerImage = nil
            self.downloadImage(forItemAtIndex: indexPath.row)
        }
        
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "CollectionsDetail", bundle: .main)
        let controller = storyboard.instantiateInitialViewController() as! CollectionsDetailViewController
        controller.collection = collections[indexPath.row]
        controller.downloadManager = downloadManager
        controller.collectionImage = images[indexPath.row]

        navigationController?.pushViewController(controller, animated: true)
    }
    
    // MARK: View Setup
    private func registerTableViewCells() {
        let collectionTableViewCellNib = UINib(nibName: "CollectionTableViewCell", bundle: .main)
        tableView.register(collectionTableViewCellNib, forCellReuseIdentifier: "CollectionCell")
    }
    
    private func initializeImagesArray() {
        var newImages = [UIImage?]()
        for _ in collections {
            newImages.append(nil)
        }
        images = newImages
    }
    
    @IBAction func reloadCollections() {
        // iOS Bug? Calling .beginRefreshing() causes so odd layout and spacing issues when using a large title.
        // https://stackoverflow.com/questions/48347215/programmatic-beginrefreshing-on-ios11-has-problems-with-largetitles-mode
        //tableView.refreshControl?.beginRefreshing()
        
        downloadManager.fetchCustomCollections { (updatedCollections, error) in
            guard error == nil else {
                self.alert(with: "Download Error", message: error!.localizedDescription)
                self.refreshControl?.endRefreshing()
                return
            }
            
            DispatchQueue.main.async {
                self.reloadTableView(with: updatedCollections!)
                self.refreshControl?.endRefreshing()
            }
        }
    }
    
    private func reloadTableView(with newCollections: [CustomCollection]) {
        tableView.performBatchUpdates({
            if !collections.isEmpty {
                let indexPathes = self.collections.enumerated().map({
                    IndexPath(row: $0.offset, section: 0)
                })
                tableView.deleteRows(at: indexPathes, with: .fade)
            }
            
            collections = newCollections
            
            let indexPathes = newCollections.enumerated().map({
                IndexPath(row: $0.offset, section: 0)
            })
            tableView.insertRows(at: indexPathes, with: .fade)
        }, completion: nil)
    }

}
