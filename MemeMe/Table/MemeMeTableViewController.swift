//
//  MemeMeTableViewController.swift
//  MemeMe
//
//  Created by Lixiang Zhang on 12/28/20.
//

import UIKit

class MemeMeTableViewController: UITableViewController {
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }

    // MARK: - UITableViewControllerDataSource

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return memes.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: tableViewReusableCellId, for: indexPath) as! MemeTableViewCell
        let meme = memes[indexPath.row]
        cell.memeImage?.image = meme.memedImage
        cell.memeDescription.text = "\(meme.topText)...\(meme.bottomText)"
        return cell
    }
    
    // MARK: - UITableViewControllerDelegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailViewController = storyboard?.instantiateViewController(identifier: detailViewControllerId) as! MemeMeDetailViewController
        detailViewController.image = memes[indexPath.row].memedImage
        navigationController?.pushViewController(detailViewController, animated: true)
    }
}
