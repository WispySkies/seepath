//
//  GridModel.swift
//  seepath
//
//  Created by Declan McCue on 3/15/25.
//

import SwiftUI

struct Cell: Identifiable {
  let id = UUID()
  var isObstacle: Bool = false
  var isVisited: Bool = false
  var isPath: Bool = false
}

class GridModel: ObservableObject {
  @Published var grid: [[Cell]]
  @Published var start: CGPoint?
  @Published var end: CGPoint?
  
  init(size: Int) {
    grid = Array(repeating: Array(repeating: Cell(), count: size), count: size)
    start = nil
    end = nil
  }
}
