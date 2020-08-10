//
//  Validation.swift
//  Focus
//
//  Created by Scott Bolin on 8/3/20.
//  Copyright © 2020 Scott Bolin. All rights reserved.
//

import Foundation

class Validation {
  func validatedText(newText: String, oldText: String) -> Bool {
    let trimmedNewText = newText.trimmingCharacters(in: .whitespaces)
    let trimmedOldText = oldText.trimmingCharacters(in: .whitespaces)
    let isValidatedNewText = trimmedNewText.count > 0
    let isValidatedOldText = trimmedOldText.count > 0
    let isValidatedDifferent = trimmedNewText != trimmedOldText

    let isValid = isValidatedNewText && isValidatedOldText && isValidatedDifferent
    return isValid
  }
}
