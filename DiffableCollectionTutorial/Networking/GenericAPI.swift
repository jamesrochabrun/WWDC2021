//
//  GenericAPI.swift
//  DiffableCollectionTutorial
//
//  Created by James Rochabrun on 6/7/21.
//

import Foundation
import UIKit

enum APIError: Error {

    case requestFailed(description: String)
    case jsonConversionFailure(description: String)
    case invalidData
    case responseUnsuccessful(description: String)
    case jsonParsingFailure
    case noInternet
    case failedSerialization

    var customDescription: String {
        switch self {
        case let .requestFailed(description): return "Request Failed error -> \(description)"
        case .invalidData: return "Invalid Data error)"
        case let .responseUnsuccessful(description): return "Response Unsuccessful error -> \(description)"
        case .jsonParsingFailure: return "JSON Parsing Failure error)"
        case let .jsonConversionFailure(description): return "JSON Conversion Failure -> \(description)"
        case .noInternet: return "No internet connection"
        case .failedSerialization: return "serialization print for debug failed."
        }
    }
}

protocol GenericAPI {
    var session: URLSession { get }
    func fetch<T: Decodable>(
        type: T.Type,
        with request: URLRequest,
        completion: @escaping (Result<T, APIError>) -> Void)
}

extension GenericAPI {

    private func decodingTask<T: Decodable>(
        with request: URLRequest,
        decodingType: T.Type,
        completionHandler completion: @escaping (Result<T, APIError>) -> Void)
    -> URLSessionDataTask {

        let task = session.dataTask(with: request) { data, response, error in

            guard let httpResponse = response as? HTTPURLResponse else {
                completion(.failure(.requestFailed(description: error.debugDescription)))
                return
            }
            guard httpResponse.statusCode == 200 else {
                completion(.failure(.responseUnsuccessful(description: "status code = \(httpResponse.statusCode)")))
                return
            }
            guard let data = data else {
                completion(.failure(.invalidData))
                return
            }
            do {
                let decoder = JSONDecoder()
                let genericModel = try decoder.decode(T.self, from: data)
                //try debugPayloadData(data)
                completion(.success(genericModel))
            } catch let error {
                completion(.failure(.jsonConversionFailure(description: error.localizedDescription)))
            }
        }
        return task
    }

    func fetch<T: Decodable>(
        type: T.Type,
        with request: URLRequest,
        completion: @escaping (Result<T, APIError>) -> Void) {
        let task = decodingTask(with: request, decodingType: T.self) { result in
            DispatchQueue.main.async {
                completion(result)
            }
        }
        task.resume()
    }

    private func debugPayloadData(_ data: Data) throws {
        guard let object = try JSONSerialization.jsonObject(with: data, options: []) as? [String: AnyObject] else {
            throw APIError.failedSerialization
        }
        print("Debug: Object response \(object)")
    }
}

@available(iOS 15, *)
protocol AsyncGenericAPI {

    var session: URLSession { get }
    func fetch<T: Decodable>(
        type: T.Type,
        with request: URLRequest) async throws -> T
}
@available(iOS 15, *)
extension AsyncGenericAPI {

    func fetch<T: Decodable>(
        type: T.Type,
        with request: URLRequest) async throws -> T {

        let (data, response) = try await session.data(for: request)
       // try! debugPayloadData(data)
        guard let httpResponse = response as? HTTPURLResponse else {
            throw APIError.requestFailed(description: "What here?")
        }
        guard httpResponse.statusCode == 200 else {
            throw APIError.responseUnsuccessful(description: "status code - \(httpResponse.statusCode)")
        }
        do {
            let decoder = JSONDecoder()
            return try decoder.decode(type, from: data)
        } catch {
            throw APIError.jsonConversionFailure(description: error.localizedDescription)
        }
    }
}
