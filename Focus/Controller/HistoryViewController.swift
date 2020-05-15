//
//  HistoryViewController.swift
//  Focus
//
//  Created by Scott Bolin on 4/30/20.
//  Copyright © 2020 Scott Bolin. All rights reserved.
//

import UIKit

class HistoryViewController: UIViewController {
  
  //MARK: - Properties
  
  let goals = [Goal]()

  //MARK:- IBOutlets
  @IBOutlet weak var historyTableView: UITableView!
  
  //MARK: - View Life Cycle
  override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }


}
