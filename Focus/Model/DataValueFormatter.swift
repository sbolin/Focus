//
//  DataValueFormatter.swift
//  Focus
//
//  Created by Scott Bolin on 7/29/20.
//
//  Taken from ChartsDemo App, LargeValueFormatter.swift
//  Copyright © 2016 dcg. All rights reserved.
//

import Foundation
import Charts

class DataValueFormatter: NSObject, IValueFormatter {
  
  /// Suffix to be appended after the values.
  ///
  /// **default**: suffix: ["", "k", "m", "b", "t"]
  public var suffix = ["", "k", "m", "b", "t"]
  
  /// An appendix text to be added at the end of the formatted value.
  public var appendix: String?
  
  public init(appendix: String? = nil) {
    self.appendix = appendix
  }
  
  fileprivate func format(value: Double) -> String {

    //Add font variation - NOTE: NOT USED
//    let font = UIFont.systemFont(ofSize: 6, weight: .light)
//    let textColor = UIColor.systemOrange
//    let attributes: [NSAttributedString.Key: Any] = [
//      .foregroundColor: textColor,
//      .font: font,
//      .textEffect: NSAttributedString.TextEffectStyle.letterpressStyle]

    var sig = value
    var length = 0
    let maxLength = suffix.count - 1

    while sig >= 1000.0 && length < maxLength {
      sig /= 1000.0
      length += 1
    }
    
    var r = String(format: "%2.f", sig) + suffix[length]
    
    
    
    if let appendix = appendix {
      r += appendix
    }
//    let attributedString = NSAttributedString(string: r, attributes: attributes)
//    return attributedString
    
    return r
  }
  
  func stringForValue(_ value: Double, entry: ChartDataEntry, dataSetIndex: Int, viewPortHandler: ViewPortHandler?) -> String {
    return format(value: value)
  }
}
