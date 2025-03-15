//
//  Algorithm.swift
//  seepath
//
//  Created by Declan McCue on 3/15/25.
//
import Foundation

struct Position: Hashable {
  let row: Int
  let col: Int
}

protocol Algorithm {
  var searchTask: Task<Void, Never>? { get set }
  var speed_ms: Int { get set }
  
  init(speed: Int)

  func search(grid: GridModel, start: Position, end: Position, onUpdate: @escaping () -> Void)
  func cancel()
}
