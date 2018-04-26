//
//  MasterViewController.swift
//  XestiMonitorsDemo-iOS
//
//  Created by J. G. Pusey on 2016-11-23.
//
//  © 2016 J. G. Pusey (see LICENSE.md)
//

import UIKit

public class MasterViewController: UITableViewController {
    override public func viewWillAppear(_ animated: Bool) {
        clearsSelectionOnViewWillAppear = splitViewController?.isCollapsed ?? false

        super.viewWillAppear(animated)
    }
}
