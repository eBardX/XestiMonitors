//
//  MasterViewController.swift
//  XestiMonitors
//
//  Created by J. G. Pusey on 2018-01-11.
//
//  © 2018 J. G. Pusey (see LICENSE.md)
//

import UIKit

public class MasterViewController: UITableViewController {
    override public func viewWillAppear(_ animated: Bool) {
        self.clearsSelectionOnViewWillAppear = self.splitViewController?.isCollapsed ?? false

        super.viewWillAppear(animated)
    }
}
