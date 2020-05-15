//
//  SectionedTableViewDataSource.swift
//  Focus
//
//  Created by Scott Bolin on 5/1/20.
//  Copyright © 2020 Scott Bolin. All rights reserved.
//

import UIKit

class SectionedTableViewDataSource: NSObject {
  private let dataSources: [UITableViewDataSource]
  
  init(dataSources: [UITableViewDataSource]) {
    self.dataSources = dataSources
  }
}

extension SectionedTableViewDataSource: UITableViewDataSource {
  func numberOfSections(in tableView: UITableView) -> Int {
    return dataSources.count
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//    let dataSource = dataSources[section]
//    return dataSource.tableView(tableView, numberOfRowsInSection: 0)
    return 3
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let dataSource = dataSources[indexPath.section]
    let indexPath = IndexPath(row: indexPath.row, section: 0)
    return dataSource.tableView(tableView, cellForRowAt: indexPath)
  }
}
