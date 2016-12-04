//
//  MasterViewController.swift
//  XestiMonitors
//
//  Created by J. G. Pusey on 2016-11-23.
//
//  © 2016 J. G. Pusey (see LICENSE.md)
//

import UIKit

class MasterViewController: UITableViewController {

    override func viewWillAppear(_ animated: Bool) {

        self.clearsSelectionOnViewWillAppear = self.splitViewController!.isCollapsed

        super.viewWillAppear(animated)

    }

    //override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    //    if segue.identifier == "showDetail" {
    //        if let indexPath = self.tableView.indexPathForSelectedRow {
    //            let object = objects[indexPath.row] as! NSDate
    //            let controller = (segue.destination as! UINavigationController).topViewController as! DetailViewController
    //            controller.detailItem = object
    //            controller.navigationItem.leftBarButtonItem = self.splitViewController?.displayModeButtonItem
    //            controller.navigationItem.leftItemsSupplementBackButton = true
    //        }
    //    }
    //}

}
