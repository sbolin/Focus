//
//  HistorySection0HeaderCell.swift
//  Focus
//
//  Created by Scott Bolin on 5/15/20.
//  Copyright © 2020 Scott Bolin. All rights reserved.
//

import UIKit

class HistorySection0HeaderCell: UITableViewHeaderFooterView {
  
  //MARK: - Properties
  public static let HistorySection0HeaderCellReuseIdentifier = "HistorySection0HeaderCell"

  //MARK: - IBOutlets
  @IBOutlet weak var historySection0Label: UILabel!
  @IBOutlet weak var historySection0Button: UIButton!
  
  //MARK: - View Life Cycle
  override func awakeFromNib() {
    super.awakeFromNib()
    
  }
  
  
  
  //MARK: - IBActions
  @IBAction func historySection0ButtonTapped(_ sender: UIButton) {
  }
  
}
