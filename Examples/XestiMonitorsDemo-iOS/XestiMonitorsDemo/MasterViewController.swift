// © 2016–2025 John Gary Pusey (see LICENSE.md)

import UIKit

public class MasterViewController: UITableViewController {
    override public func viewWillAppear(_ animated: Bool) {
        clearsSelectionOnViewWillAppear = splitViewController?.isCollapsed ?? false

        super.viewWillAppear(animated)
    }
}
