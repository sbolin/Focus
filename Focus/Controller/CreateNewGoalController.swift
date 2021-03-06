//
//  CreateNewGoalController.swift
//  Focus
//
//  Created by Scott Bolin on 8/20/20.
//  Copyright © 2020 Scott Bolin. All rights reserved.
//

// create view programatically, enter Goal and todos, use protocol to save new Focus task

import UIKit

// revised protocol
protocol CreateNewGoalControllerDelegate {
  func goalPassBack(goal: String, todo1: String, todo2: String, todo3: String)
}

class CreateNewGoalController: UIViewController, UIAdaptivePresentationControllerDelegate {
  
  //MARK: - Properties
  var delegate: CreateNewGoalControllerDelegate?
  var goal = String()
  // TODO: Should be based on GlobalVariable not fixed number of todoItems
  var todoItem = [String]()
  var todoItem1 = String()
  var todoItem2 = String()
  var todoItem3 = String()
  
  let goalLabel: UILabel = {
    let label = UILabel()
    label.text = "Focus Goal:"
    label.textColor = .darkGray
    label.translatesAutoresizingMaskIntoConstraints = false
    return label
  }()
  
  let goalTextField: UITextField = {
    let textField = UITextField()
    textField.placeholder = "Enter today's goal"
    textField.textColor = .orange
    textField.translatesAutoresizingMaskIntoConstraints = false
    return textField
  }()
  
  let todoOneLabel: UILabel = {
    let label = UILabel()
    label.text = "Task #1:"
    label.textColor = .darkGray
    label.translatesAutoresizingMaskIntoConstraints = false
    return label
  }()
  
  let todoOneTextField: UITextField = {
    let textField = UITextField()
    textField.placeholder = "First task"
    textField.textColor = .orange
    textField.translatesAutoresizingMaskIntoConstraints = false
    return textField
  }()
  
  let todoTwoLabel: UILabel = {
    let label = UILabel()
    label.text = "Task #2:"
    label.textColor = .darkGray
    label.translatesAutoresizingMaskIntoConstraints = false
    return label
  }()
  
  let todoTwoTextField: UITextField = {
    let textField = UITextField()
    textField.placeholder = "Second task"
    textField.textColor = .orange
    textField.translatesAutoresizingMaskIntoConstraints = false
    return textField
  }()
  
  let todoThreeLabel: UILabel = {
    let label = UILabel()
    label.text = "Task #3:"
    label.textColor = .darkGray
    label.translatesAutoresizingMaskIntoConstraints = false
    return label
  }()
  
  let todoThreeTextField: UITextField = {
    let textField = UITextField()
    textField.placeholder = "Third task"
    textField.textColor = .orange
    textField.translatesAutoresizingMaskIntoConstraints = false
    return textField
  }()

  //MARK: - View Lifecycle
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    goalTextField.becomeFirstResponder()
  }
  
  override func viewWillLayoutSubviews() {
    // prevent user from dismissing view
    isModalInPresentation = true
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    navigationItem.title = "Add Focus Goal"
    setupSaveButton()
    setupUI()
  }
  
  //MARK: - Set up the navigation bar, called from TodayViewController
  func setupNavBar() {
    
    UINavigationBar.appearance().tintColor = .white
    UINavigationBar.appearance().prefersLargeTitles = true
    
    let appearance = UINavigationBarAppearance()
    UINavigationBar.appearance().tintColor = .white
    appearance.backgroundColor = .orange
    appearance.largeTitleTextAttributes = [.foregroundColor : UIColor.white] //portrait title
    appearance.titleTextAttributes = [.foregroundColor : UIColor.white] //landscape title
    
    UINavigationBar.appearance().tintColor = .white
    UINavigationBar.appearance().standardAppearance = appearance //landscape
    UINavigationBar.appearance().compactAppearance = appearance
    UINavigationBar.appearance().scrollEdgeAppearance = appearance //portrait
  }
  
  
  //MARK: - Setup graphical UI programatically
  private func setupUI() {
    
    _ = setupCreateBackground(height: 195)
    
    view.addSubview(goalLabel)
    goalLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
    goalLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true
    goalLabel.widthAnchor.constraint(equalToConstant: 100).isActive = true
    goalLabel.heightAnchor.constraint(equalToConstant: 50).isActive = true
    
    view.addSubview(goalTextField)
    goalTextField.topAnchor.constraint(equalTo: goalLabel.topAnchor).isActive = true
    goalTextField.leadingAnchor.constraint(equalTo: goalLabel.trailingAnchor).isActive = true
    goalTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
    goalTextField.bottomAnchor.constraint(equalTo: goalLabel.bottomAnchor).isActive = true
    
    view.addSubview(todoOneLabel)
    todoOneLabel.topAnchor.constraint(equalTo: goalLabel.bottomAnchor).isActive = true
    todoOneLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true
    todoOneLabel.widthAnchor.constraint(equalToConstant: 100).isActive = true
    todoOneLabel.heightAnchor.constraint(equalToConstant: 50).isActive = true
    
    view.addSubview(todoOneTextField)
    todoOneTextField.topAnchor.constraint(equalTo: todoOneLabel.topAnchor).isActive = true
    todoOneTextField.leadingAnchor.constraint(equalTo: todoOneLabel.trailingAnchor).isActive = true
    todoOneTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
    todoOneTextField.bottomAnchor.constraint(equalTo: todoOneLabel.bottomAnchor).isActive = true
    
    view.addSubview(todoTwoLabel)
    todoTwoLabel.topAnchor.constraint(equalTo: todoOneLabel.bottomAnchor).isActive = true
    todoTwoLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true
    todoTwoLabel.widthAnchor.constraint(equalToConstant: 100).isActive = true
    todoTwoLabel.heightAnchor.constraint(equalToConstant: 50).isActive = true
    
    view.addSubview(todoTwoTextField)
    todoTwoTextField.topAnchor.constraint(equalTo: todoTwoLabel.topAnchor).isActive = true
    todoTwoTextField.leadingAnchor.constraint(equalTo: todoTwoLabel.trailingAnchor).isActive = true
    todoTwoTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
    todoTwoTextField.bottomAnchor.constraint(equalTo: todoTwoLabel.bottomAnchor).isActive = true
    
    
    view.addSubview(todoThreeLabel)
    todoThreeLabel.topAnchor.constraint(equalTo: todoTwoLabel.bottomAnchor).isActive = true
    todoThreeLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true
    todoThreeLabel.widthAnchor.constraint(equalToConstant: 100).isActive = true
    todoThreeLabel.heightAnchor.constraint(equalToConstant: 50).isActive = true
    
    view.addSubview(todoThreeTextField)
    todoThreeTextField.topAnchor.constraint(equalTo: todoThreeLabel.topAnchor).isActive = true
    todoThreeTextField.leadingAnchor.constraint(equalTo: todoThreeLabel.trailingAnchor).isActive = true
    todoThreeTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
    todoThreeTextField.bottomAnchor.constraint(equalTo: todoThreeLabel.bottomAnchor).isActive = true
    
  }
  
  func setupCreateBackground(height: CGFloat) -> UIView {
    let mainView = UIView()
    mainView.backgroundColor = UIColor.white
    mainView.translatesAutoresizingMaskIntoConstraints = false
    
    view.addSubview(mainView)
    mainView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
    mainView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
    mainView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
    mainView.heightAnchor.constraint(equalToConstant: height).isActive = true
    
    mainView.layer.cornerRadius = 12
    mainView.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
    
    return mainView
  }
  
  //MARK: - Class methods
  // no cancel - user must save new Focus item before proceeding
  private func setupSaveButton() {
    navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(handleSave))
  }
  
  @objc private func handleSave() {
    
    guard let goalName = goalTextField.text else { return }
    guard let todoItem1 = todoOneTextField.text else { return }
    guard let todoItem2 = todoTwoTextField.text else { return }
    guard let todoItem3 = todoThreeTextField.text else { return }
    
    // validate input
    if goalName.isEmpty {
      showError(title: "Empty Goal", message: "Please enter a new goal", buttonTitle: "Got It!")
      return
    }
    
    if todoItem1.isEmpty {
      showError(title: "Empty Task Item", message: "Please enter a new Task 1", buttonTitle: "Got It!")
      return
    }
    
    if todoItem2.isEmpty  {
      showError(title: "Empty Task Item", message: "Please enter a new Task 2", buttonTitle: "Got It!")
      return
    }
    
    if todoItem3.isEmpty {
      showError(title: "Empty Task Item", message: "Please enter a new Task 3", buttonTitle: "Got It!")
      return
    }

    delegate?.goalPassBack(goal: goalName, todo1: todoItem1, todo2: todoItem2, todo3: todoItem3)
    dismiss(animated: true, completion: nil)
 
  }
  
  // show dialog if goal/task are input improperly
  private func showError(title: String, message: String, buttonTitle: String) {
    let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
    alertController.addAction(UIAlertAction(title: buttonTitle, style: .default, handler: nil))
    present(alertController, animated: true, completion: nil)
  }
}
