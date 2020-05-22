//
//  TodaySection1HeaderCell.swift
//  Focus
//
//  Created by Scott Bolin on 5/15/20.
//  Copyright © 2020 Scott Bolin. All rights reserved.
//

import UIKit

class TodaySection1HeaderCell: UITableViewHeaderFooterView {
  
  //MARK: - Properties
  public static let reuseIdentifier = "TodaySection1HeaderCell"

  //MARK: - IBOutlets
  @IBOutlet weak var todaySection1Label: UILabel!
  
  //MARK: - View Life Cycle
  override func awakeFromNib() {
    super.awakeFromNib()
    
  }

}
