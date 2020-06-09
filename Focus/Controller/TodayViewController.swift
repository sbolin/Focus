//
//  TodayViewController.swift
//  Focus
//
//  Created by Scott Bolin on 4/30/20.
//  Copyright © 2020 Scott Bolin. All rights reserved.
//

import UIKit
import CoreData

class TodayViewController: UIViewController {
  
  //MARK: - Properties
  let todayViewdelegate = TodayViewDelegate()
  var dataSource: TodayViewDataSource<ToDo, TodayViewController>!
  var fetchedResultsController: NSFetchedResultsController<ToDo>!
    
  //MARK:- IBOutlets
  @IBOutlet weak var todayTableView: UITableView!
  
  //MARK: - View Life Cycle
  override func viewDidLoad() {
    super.viewDidLoad()
    CoreDataController.shared.createToDosIfNeeded()
    todayTableView.delegate = todayViewdelegate
    setupTableView()
    registerForKeyboardNotifications()
  }
  
  //MARK: - Setup tableview to show last note
  func setupTableView() {
    // setup fetchrequest
    if fetchedResultsController == nil {
      fetchedResultsController = CoreDataController.shared.fetchedToDoResultsController
    }
    fetchedResultsController.fetchRequest.fetchLimit = 0
    let createdAtDescriptor = NSSortDescriptor(key: "todoDateCreated", ascending: false)
    fetchedResultsController.fetchRequest.sortDescriptors = [createdAtDescriptor]
    fetchedResultsController.fetchRequest.fetchLimit = 1
    
    do {
      try fetchedResultsController.performFetch()
      todayTableView.reloadData()
    } catch {
      print("Fetch failed")
    }
    dataSource = TodayViewDataSource(tableView: todayTableView, fetchedResultsController: fetchedResultsController, delegate: self)
  }
  
  //MARK:- Notification Functions for keyboard
  func registerForKeyboardNotifications() {
    NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
    NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
  }
  
  @objc func keyboardWillShow(notification: NSNotification) {
    let keyboardFrame = notification.userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! CGRect
    adjustLayoutForKeyboard(targetHeight: keyboardFrame.size.height)
  }
  
  @objc func keyboardWillHide(notification: NSNotification) {
    adjustLayoutForKeyboard(targetHeight: 0)
  }
  
  func adjustLayoutForKeyboard(targetHeight: CGFloat) {
    todayTableView.contentInset.bottom = targetHeight
  }
  
  @IBAction func addTodayTask(_ sender: UIButton) {
    todayTableView.beginUpdates()
    
    // add task to dataSource
    let context = CoreDataController.shared.managedContext
    let todo = ToDo(context: context)
    todo.todo = "New Todo"
    todo.todoDateCreated = Date()
    todo.todoCompleted = false
    // update the tableview UI
    todayTableView.insertRows(at: [IndexPath(row: 0, section: 1)], with: .automatic)
    todayTableView.endUpdates()
    CoreDataController.shared.saveContext()
  }
}

//MARK: - Delegate Methods
extension TodayViewController: TodayViewDataSourceDelegate {
  func configureTodayGoalCell(at indexPath: IndexPath, _ cell: TodayGoalCell, for object: Goal) {
    cell.configure()
  }
  
  func configureTodayToDoCell(at indexPath: IndexPath, _ cell: TodayToDoCell, for object: ToDo) {
    cell.configureTodayTaskCell(at: indexPath, for: object)
  }
  

}
