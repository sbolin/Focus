//
//  UIButton+Actions.swift
//  Focus
//
//  Created by Scott Bolin on 5/9/20.
//  Copyright © 2020 Scott Bolin. All rights reserved.
//

import UIKit

// Methods for UIButton behaviors when clicked
extension UIButton {
  
  // wiggle button
  
  func wiggle() {
    DispatchQueue.main.async {
      let springAnim = self.startWiggle(view: self)
      let correctionAnim = self.endWiggle(view: self)
      self.layer.add(springAnim, forKey: nil)
      self.layer.add(correctionAnim, forKey: nil)
    }
  }
  
  private func startWiggle(view: UIButton) -> CASpringAnimation{
    let animation = CASpringAnimation(keyPath: "transform")
    animation.damping = 0.0 //0
    animation.initialVelocity = 80 //80
    animation.mass = 0.04 //0.04
    animation.stiffness = 50 //50
    animation.duration = 0.4 //0.3
    animation.toValue = CATransform3DRotate(CATransform3DMakeAffineTransform(view.transform), CGFloat((7.0 * Double.pi) / 180.0), 0, 0, 1)
    return animation
  }
  
  private func endWiggle(view: UIButton) -> CABasicAnimation{
    let animation = CABasicAnimation(keyPath: "transform")
    animation.duration = 0.4 //0.3
    animation.toValue = CATransform3DRotate(CATransform3DMakeAffineTransform(view.transform), 0, 0, 0, 1)
    return animation
  }
  
  // rotate button around all three axis
  
  func whirl() {
    let springAnim = startWhirl(view: self)
    self.layer.add(springAnim, forKey: nil)
  }
  
  private func startWhirl(view: UIButton) -> CASpringAnimation{
    let animation = CASpringAnimation(keyPath: "transform")
    animation.repeatCount = 1
    animation.autoreverses = false
    animation.damping = 0.0 //0
    animation.initialVelocity = 3 //80
    animation.mass = 1 //0.04
    animation.stiffness = 1 //50
    animation.duration = 1.5 //0.3
    animation.toValue = CATransform3DRotate(CATransform3DMakeAffineTransform(view.transform), CGFloat((Double.pi)), 1, 1, 1)
    return animation
  }
}
