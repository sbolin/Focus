//
//  HistoryTaskCell.swift
//  Focus
//
//  Created by Scott Bolin on 4/30/20.
//  Copyright © 2020 Scott Bolin. All rights reserved.
//

import UIKit

class HistoryTaskCell: UITableViewCell {
  
  //MARK: - Properties
  public static let reuseIdentifier = "HistoryTaskCell"
  
  //MARK: - IBOutlets
  @IBOutlet weak var historyTask: UITextField!
  @IBOutlet weak var historyTaskCompleted: UIButton!
  
  override func awakeFromNib() {
    super.awakeFromNib()

  }
  
}
