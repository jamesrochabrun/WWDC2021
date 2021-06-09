//
//  Endpoint.swift
//  DiffableCollectionTutorial
//
//  Created by James Rochabrun on 6/7/21.
//

import Foundation

protocol Endpoint {
  var base:  String { get }
  var path: String { get }
  var queryItems: [URLQueryItem] { get }
}

extension Endpoint {

  var urlComponents: URLComponents {
    var components = URLComponents(string: base)! /// Force unwrapping to catch error on debug, avoid this in prod or add assertion
    components.path = path
    components.queryItems = queryItems
    return components
  }

  var request: URLRequest {
    let url = urlComponents.url! /// Force unwrapping to catch error on debug, avoid this in prod or add assertion
    return URLRequest(url: url)
  }
}
