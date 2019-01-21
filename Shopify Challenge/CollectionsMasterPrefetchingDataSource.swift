//
//  CollectionsMasterPrefetchingDataSource.swift
//  Shopify Challenge
//
//  Created by Martin Jr Powlette on 2019-01-21.
//  Copyright © 2019 Martin Jr Powlette. All rights reserved.
//

import UIKit

extension CollectionsTableViewController: UITableViewDataSourcePrefetching {
    
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        indexPaths.forEach { self.downloadImage(forItemAtIndex: $0.row) }
    }
    
    func tableView(_ tableView: UITableView, cancelPrefetchingForRowsAt indexPaths: [IndexPath]) {
        indexPaths.forEach { self.cancelDownloadingImage(forItemAtIndex: $0.row) }
    }
    
    // TODO: - Reimplement prefetching download methods under the download manager or another method. Current implementation from https://andreygordeev.com/2017/02/20/uitableview-prefetching/
    
    internal func downloadImage(forItemAtIndex index: Int) {
        let url = collections[index].image.src
        guard tasks.index(where: { $0.originalRequest?.url == url }) == nil else {
            // We're already downloading the image.
            return
        }
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            // Perform UI changes only on main thread.
            DispatchQueue.main.async {
                if let data = data, let image = UIImage(data: data) {
                    self.images[index] = image
                    // Reload cell with fade animation.
                    let indexPath = IndexPath(row: index, section: 0)
                    if self.tableView.indexPathsForVisibleRows?.contains(indexPath) ?? false {
                        self.tableView.reloadRows(at: [IndexPath(row: index, section: 0)], with: .fade)
                    }
                }
            }
        }
        task.resume()
        tasks.append(task)
    }
    
    internal func cancelDownloadingImage(forItemAtIndex index: Int) {
        let url = collections[index].image.src
        // Find a task with given URL, cancel it and delete from `tasks` array.
        guard let taskIndex = tasks.index(where: { $0.originalRequest?.url == url }) else {
            return
        }
        let task = tasks[taskIndex]
        task.cancel()
        tasks.remove(at: taskIndex)
    }
}
