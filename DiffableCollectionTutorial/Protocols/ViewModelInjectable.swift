//
//  ViewModelInjectable.swift
//  DiffableCollectionTutorial
//
//  Created by James Rochabrun on 6/7/21.
//

import Foundation

protocol ViewModelInjectable {
    associatedtype ViewModel
    func configureWithViewModel(_ model: ViewModel)
}
