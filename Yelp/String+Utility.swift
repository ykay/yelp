//
//  String+Utility.swift
//  Yelp
//
//  Created by Yuichi Kuroda on 9/27/15.
//  Copyright © 2015 Yuichi Kuroda. All rights reserved.
//

import Foundation

extension String {
  func beginsWith (str: String) -> Bool {
    if let range = self.rangeOfString(str) {
      return range.startIndex == self.startIndex
    }
    return false
  }
}