//
//  Extension + Array.swift
//  AQIIndexMonitor
//
//  Created by Parth Bhatt on 12/12/21.
//

import Foundation

extension Array where Element : Equatable {

  public mutating func mergeElements<C : Collection>(newElements: C) where C.Iterator.Element == Element{
    let filteredList = newElements.filter({!self.contains($0)})
    self.append(contentsOf: filteredList)
  }

}
