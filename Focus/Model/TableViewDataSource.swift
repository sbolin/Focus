//
//  TableViewDataSource.swift
//  Focus
//
//  Created by Scott Bolin on 4/30/20.
//  Copyright © 2020 Scott Bolin. All rights reserved.
//

import UIKit

// MARK: - Generic TableViewDataSource class for initializing and populating tableview.
class TableViewDataSource<Model>: NSObject, UITableViewDataSource {
  typealias CellConfigurator = (Model, UITableViewCell) -> Void
  
  var models: [Model]
  
  private let reuseIdentifier: String  // try to use identifier from cell
  private let cellConfigurator: CellConfigurator
  
  init(models: [Model], reuseIdentifier: String, cellConfigurator: @escaping CellConfigurator) {
    self.models = models
    self.reuseIdentifier = reuseIdentifier // not used
    self.cellConfigurator = cellConfigurator
  }
  
  // MARK: - Generic tableview datasource methods
  func numberOfSections(in tableView: UITableView) -> Int {
    models.count
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 1
//    return models[section].count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let model = models[indexPath.row]
    let cell = tableView.dequeueReusableCell(
      withIdentifier: reuseIdentifier,
      for: indexPath
    )
    cellConfigurator(model, cell)
    return cell
  }
}

//TODO: - needs work, or re-factor completely
extension TableViewDataSource where Model == Goal {
  static func make(for goals: [Goal], reuseIdentifier: String = "TodayGoalCell") -> TableViewDataSource {
    return TableViewDataSource(
      models: goals,
      reuseIdentifier: reuseIdentifier) {
        (goal, cell) in
        cell.textLabel?.text = goal.goal
    }
  }
}
