//
//  CollectionsTableViewController.swift
//  Shopify Challenge
//
//  Created by Martin Jr Powlette on 2019-01-16.
//  Copyright © 2019 Martin Jr Powlette. All rights reserved.
//

import UIKit

class CollectionsTableViewController: UITableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let collectionTableViewCellNib = UINib(nibName: "CollectionTableViewCell", bundle: .main)
        tableView.register(collectionTableViewCellNib, forCellReuseIdentifier: "CollectionCell")
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
        return 1000
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CollectionCell", for: indexPath) as! CollectionTableViewCell
        
        cell.bannerImage = indexPath.row % 2 == 0 ? UIImage(named: "Aerodynamic") : UIImage(named: "Durable")
        cell.bannerText = "Demo Collection"
        
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "CollectionsDetail", bundle: .main)
        let controller = storyboard.instantiateInitialViewController() as! CollectionsDetailViewController
        controller.collection = Collection(title: "Demo Collection",
                                           description: "This is a super cool demo collection generated from tableView(_:didSelectRowAt:)", image: UIImage(named: "Aerodynamic"))

        navigationController?.pushViewController(controller, animated: true)
    }

}
