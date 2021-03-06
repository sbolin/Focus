//
//  HistorySection0HeaderCell.swift
//  Focus
//
//  Created by Scott Bolin on 5/15/20.
//  Copyright © 2020 Scott Bolin. All rights reserved.
//
import UIKit

protocol HistorySection0HeaderCellDelegate: class {
  func historySection0(_ cell: HistorySection0HeaderView, sectionTapped: Bool)
}

class HistorySection0HeaderView: UITableViewHeaderFooterView {
  
  //MARK: - Properties
  public static let reuseIdentifier = "HistorySection0HeaderCell"
  weak var delegate: HistorySection0HeaderCellDelegate?
  var sectionNumber: Int!

  //MARK: - IBOutlets
  @IBOutlet weak var historySection0Label: UILabel!
  @IBOutlet weak var historySection0Button: UIButton!
  
  //MARK: - View Life Cycle
  override func awakeFromNib() {
    super.awakeFromNib()
    
  }
  
  //MARK: - IBActions
  @IBAction func historySection0ButtonTapped(_ sender: UIButton) {
    historySection0Button.isSelected.toggle()
    delegate?.historySection0(self, sectionTapped: historySection0Button.isSelected)
  }
}
