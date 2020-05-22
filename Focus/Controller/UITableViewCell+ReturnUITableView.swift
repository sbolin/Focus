//
//  UITableViewCell+ReturnUITableView.swift
//  Focus
//
//  Created by Scott Bolin on 5/22/20.
//  Copyright © 2020 Scott Bolin. All rights reserved.
//

import UIKit

//MARK: - UITableViewCell extension which returns the calling cell's containing UITableView
extension UITableViewCell {
  var tableView: UITableView? {
    var view = superview
    while let v = view, v.isKind(of: UITableView.self) == false {
      view = v.superview
    }
    return view as? UITableView
  }
}
