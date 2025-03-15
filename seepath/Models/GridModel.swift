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
  var isEnd: Bool = false
  var mutable: Bool = true
}

class GridModel: ObservableObject {
  @Published var grid: [[Cell]]
  var start: (row: Int, col: Int)?
  var end: (row: Int, col: Int)?
  let width: Int
  let height: Int
  
  init(width: Int, height: Int) {
    self.width = width
    self.height = height
    self.grid = Array(repeating: Array(repeating: Cell(), count: width), count: height)
    grid[height - 2][1].isPath = true
    grid[height - 2][1].mutable = false
    grid[1][width - 2].isEnd = true
    grid[1][width - 2].mutable = false
    self.start = (height - 2, 1)
    self.end = (1, width - 2)
  }
  
  func reset() {
    grid = Array(repeating: Array(repeating: Cell(), count: width), count: height)
    start = nil
    end = nil
  }
}
