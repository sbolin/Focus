//
//  ProgressViewController.swift
//  Focus
//
//  Created by Scott Bolin on 4/30/20.
//  Copyright © 2020 Scott Bolin. All rights reserved.
//

import UIKit

class ProgressViewController: UIViewController {
  
    let goal = [Goal]()

  @IBOutlet weak var progressView: UIView!
  @IBOutlet weak var weekMonthSwitch: UISegmentedControl!
  
  
  override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
  
  
  @IBAction func weekMonthToggled(_ sender: UISegmentedControl) {
  }
  
}
