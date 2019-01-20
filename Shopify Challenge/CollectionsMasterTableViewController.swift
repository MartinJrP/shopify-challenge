//
//  CollectionsTableViewController.swift
//  Shopify Challenge
//
//  Created by Martin Jr Powlette on 2019-01-16.
//  Copyright © 2019 Martin Jr Powlette. All rights reserved.
//

import UIKit

class CollectionsTableViewController: UITableViewController {
    
    lazy var downloadManager = DownloadManager()
    
    var collections = [CustomCollection]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

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
        
        cell.bannerImage = indexPath.row % 2 == 0 ? UIImage(named: "Aerodynamic") : UIImage(named: "Durable")
        cell.bannerText = collection.title
        
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "CollectionsDetail", bundle: .main)
        let controller = storyboard.instantiateInitialViewController() as! CollectionsDetailViewController
        controller.collection = collections[indexPath.row]

        navigationController?.pushViewController(controller, animated: true)
    }
    
    // MARK: View Setup
    private func registerTableViewCells() {
        let collectionTableViewCellNib = UINib(nibName: "CollectionTableViewCell", bundle: .main)
        tableView.register(collectionTableViewCellNib, forCellReuseIdentifier: "CollectionCell")
    }
    
    private func reloadCollections() {
        tableView.refreshControl?.beginRefreshing()
        downloadManager.fetchCustomCollections { (updatedCollections, error) in
            guard error == nil else {
                self.alert(with: "Download Error", message: error!.localizedDescription)
                return
            }
            
            DispatchQueue.main.async {
                self.reloadTableView(with: updatedCollections!)
            }
        }
    }
    
    private func reloadTableView(with newCollections: [CustomCollection]) {
        tableView.performBatchUpdates({
            if !collections.isEmpty {
                let indexPathes = self.collections.enumerated().map({
                    IndexPath(row: $0.offset, section: 0)
                })
                tableView.deleteRows(at: indexPathes, with: .automatic)
            }
            
            collections = newCollections
            tableView.refreshControl?.endRefreshing()
            
            let indexPathes = newCollections.enumerated().map({
                IndexPath(row: $0.offset, section: 0)
            })
            tableView.insertRows(at: indexPathes, with: .automatic)
        }, completion: nil)
    }
    
    private func alert(with title: String, message: String?) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let dismissAction = UIAlertAction(title: "OK", style: .default) { (_) in
            self.dismiss(animated: true, completion: nil)
        }
        
        alertController.addAction(dismissAction)
        
        present(alertController, animated: true, completion: nil)
    }

}
