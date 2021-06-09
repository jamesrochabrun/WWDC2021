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

    var localizedDescription: String {
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
        with request: URLRequest,
        decode: @escaping (Decodable) -> T?,
        completion: @escaping (Result<T, APIError>) -> Void)
}

extension GenericAPI {

    @available(iOS 15, *)
    func fetch<T: Decodable>(
        type: T.Type,
        with request: URLRequest) async throws -> T {

        let (data, response) = try await session.data(for: request)
        guard let httpResponse = response as? HTTPURLResponse else {
            throw APIError.requestFailed(description: "What here?")
        }
        guard httpResponse.statusCode == 200 else {
            throw APIError.responseUnsuccessful(description: "What here?")
        }
        do {
            let decoder = JSONDecoder()
            return try decoder.decode(T.self, from: data)
        } catch {
            throw APIError.jsonConversionFailure(description: error.localizedDescription)
        }
    }

    typealias JSONTaskCompletionHandler = (Decodable?, APIError?) -> Void

    private func decodingTask<T: Decodable>(with request: URLRequest, decodingType: T.Type, completionHandler completion: @escaping JSONTaskCompletionHandler) -> URLSessionDataTask {

        let task = session.dataTask(with: request) { data, response, error in

            guard let httpResponse = response as? HTTPURLResponse else {
                completion(nil, .requestFailed(description: error.debugDescription))
                return
            }
            guard httpResponse.statusCode == 200 else {
                completion(nil, .responseUnsuccessful(description: "status code = \(httpResponse.statusCode)"))
                return
            }
            guard let data = data else {
                completion(nil, .invalidData)
                return
            }
            do {
                let decoder = JSONDecoder()
                let genericModel = try decoder.decode(T.self, from: data)
                //try debugPayloadData(data)
                completion(genericModel, nil)
            } catch let error {
                completion(nil, .jsonConversionFailure(description: error.localizedDescription))
            }
        }
        return task
    }

    func fetch<T: Decodable>(with request: URLRequest, decode: @escaping (Decodable) -> T?, completion: @escaping (Result<T, APIError>) -> Void) {

        let task = decodingTask(with: request, decodingType: T.self) { json , error in

            DispatchQueue.main.async {
                guard let json = json else {
                    guard let error = error else {
                        completion(Result.failure(.invalidData))
                        return
                    }
                    completion(Result.failure(error))
                    return
                }
                guard let value = decode(json) else {
                    completion(.failure(.jsonParsingFailure))
                    return
                }
                completion(.success(value))
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
