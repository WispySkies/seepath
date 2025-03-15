//
//  Algorithm.swift
//  seepath
//
//  Created by Declan McCue on 3/15/25.
//
import Foundation

protocol Algorithm {
  func search(grid: GridModel, start: CGPoint, end: CGPoint, onUpdate: @escaping () -> Void)
}
