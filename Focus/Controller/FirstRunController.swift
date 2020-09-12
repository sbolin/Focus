//
//  FirstRunController.swift
//  Focus
//
//  Created by Scott Bolin on 9/11/20.
//  Copyright © 2020 Scott Bolin. All rights reserved.
//

import UIKit

class FirstRunController: UIViewController {
  @IBOutlet weak var viewHolder: UIView!
  let scrollView = UIScrollView()
  
  override func viewDidLoad() {
    super.viewDidLoad()
  }
  
  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    configure()
  }
  
  private func configure() {
    
    scrollView.frame = viewHolder.bounds
    viewHolder.addSubview(scrollView)
    let frameWidth = viewHolder.frame.size.width
    let frameHeight = viewHolder.frame.size.height
    
    let titles = ["Welcome to Focus!", "Get Started Quick", "Let's Go!"]
    let descriptions = [
    "Simple steps to get the most out of Focus App.",
    "1. Create a Focus Goal and 3 key tasks each day. " +
    "2. Click the star once a task is completed, or click again if unfinished. " +
    "3. After your three tasks are complete, your Focus is complete!",
    "Each morning, you can continue using the previous days Focus (if you didn't finish), or create a new Focus. Notifications are required. Click Let's Go below, and your first Focus will be created for you - just edit the Goal and tasks. Lets get started!"
    ]
    
    for page in 0...2 {
      let frame = CGRect(x: CGFloat(page) * frameWidth, y: 0, width: frameWidth, height: frameHeight)
      let pageView = UIView(frame: frame)
      let pageWidth = pageView.frame.size.width
      let pageHeight = pageView.frame.size.height
      scrollView.addSubview(pageView)
      
      // Title, image, description, button
      let title = UILabel(frame: CGRect(x: 10, y: 10, width: pageWidth - 20, height: 120))
      let imageView = UIImageView(frame: CGRect(x: 10, y: 10 + 120 + 10, width: pageWidth - 20, height: pageHeight - 60 - 130 - 160 - 15))
      let description = UILabel(frame: CGRect(x: 10, y: pageHeight - 60 - 160, width: pageWidth - 20, height: 150))
      let button = UIButton(frame: CGRect(x: 10, y: pageHeight - 60, width: pageWidth - 20, height: 50))

      title.textAlignment = .center
      title.font = UIFont.systemFont(ofSize: 32, weight: .bold)
      title.text = titles[page]
      
      pageView.addSubview(title)
      
      imageView.contentMode = .scaleAspectFit
      imageView.image = UIImage(named: "welcome_\(page + 1)")
      
      pageView.addSubview(imageView)
      
      description.textAlignment = .natural
      description.font = UIFont.systemFont(ofSize: 16, weight: .regular)
      description.numberOfLines = 0
      description.text = descriptions[page]
      
      pageView.addSubview(description)
      
      button.setTitleColor(.white, for: .normal)
      button.backgroundColor = .orange
      button.setTitle("Continue", for: .normal)
      if page == 2 { button.setTitle("Let's Go!", for: .normal) }
      button.tag = page + 1
      button.addTarget(self, action: #selector(didTapButton(_:)), for: .touchUpInside)
      
      pageView.addSubview(button)
      
    }
    scrollView.contentSize = CGSize(width: frameWidth * 3, height: 0)
    scrollView.isPagingEnabled = true
  }
  
  @objc func didTapButton(_ button: UIButton) {
    
    guard button.tag < 3 else {
      // dismiss view and continue
      // set user default pref to has read
      dismiss(animated: true, completion: nil)
      return
    }
    // scroll to next page
    scrollView.setContentOffset(CGPoint(x: viewHolder.frame.size.width * CGFloat(button.tag), y: 0), animated: true)
  }
}


