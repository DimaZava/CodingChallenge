//
//  APIService.swift
//  codingChallenge
//
//  Created by Dmitry Zawadsky on 26.04.2021.
//

import Foundation

protocol APIServiceInput {
    
    func profiles(result: @escaping (Result<Data, Error>) -> Void)
    func timelineEvents(for profileId: String, result: @escaping (Result<Data, Error>) -> Void)
    func healthPrompts(for profileId: String, result: @escaping (Result<Data, Error>) -> Void)
}

final class APIService: APIServiceInput {
    
    // MARK: Constants
    private let urlSession: URLSession
    private let timeoutIntervalForRequest: TimeInterval = 60 * 2
    private let timeoutIntervalForResource: TimeInterval = 60 * 2
    var authHeaders: HTTPHeaders {
        [:]
    }
    
    // MARK: Properties
    private var currentTasks = [URLSessionTask]()
    
    // MARK: Lifecycle
    init() {
        let sessionConfiguration = URLSessionConfiguration.default
        sessionConfiguration.timeoutIntervalForRequest = timeoutIntervalForRequest
        sessionConfiguration.timeoutIntervalForResource = timeoutIntervalForResource
        urlSession = URLSession(configuration: sessionConfiguration)
    }
    
    func requestResource<T>(resource: APIEndpoints,
                            dataCarrier: DataCarrier,
                            headers: HTTPHeaders?,
                            progress: (Progress) -> Void = { _ in },
                            result: @escaping (Result<T, Error>) -> Void) {
        request(resource,
                method: resource.method,
                dataCarrier: dataCarrier,
                headers: headers,
                progress: progress,
                result: result)
    }
}

// MARK: - Private Extension
private extension APIService {
    
    // swiftlint:disable:next cyclomatic_complexity function_body_length function_parameter_count
    func request<T>(_ resource: APIEndpoints,
                    method: HTTPMethod,
                    dataCarrier: DataCarrier,
                    headers: HTTPHeaders?,
                    progress: (Progress) -> Void,
                    result: @escaping (Result<T, Error>) -> Void) {
        
        let completionHandler: (Data?, URLResponse?, Error?) -> Void = { [weak self] data, response, error in
            
            self?.currentTasks.removeAll(where: { $0.currentRequest?.url == response?.url })
            
            guard error == nil else { result(.failure(error!)); return }
            
            let statusCode = (response as? HTTPURLResponse)?.statusCode ?? -1
            
            guard 200..<300 ~= statusCode else {
                print("Error - \(response?.url?.absoluteString ?? "N/A") HTTP \(statusCode)")
                result(.failure(CCError.unableToObtainObject))
                return
            }
            
            print("Success - \(response?.url?.absoluteString ?? "N/A") HTTP \(statusCode)")
            
            do {
                if let data = data {
                    if T.self is Void.Type {
                        // swiftlint:disable:next force_cast
                        result(.success(Void() as! T))
                    } else if T.self is Data.Type || T.self is Data?.Type {
                        // swiftlint:disable:next force_cast
                        result(.success(data as! T))
                    } else if let json = try JSONSerialization.jsonObject(with: data) as? T {
                        result(.success(json))
                    }
                } else {
                    result(.failure(CCError.unableToObtainObject))
                }
            } catch {
                result(.failure(error))
            }
        }
        
        do {
            var originalRequest: URLRequest
            
            switch dataCarrier {
            case .parameters(let parameters):
                switch method {
                case .get:
                    originalRequest =
                        try URLRequest(url: resource.getURL(urlParameters: parameters),
                                       method: method,
                                       headers: headers ?? .init(),
                                       parameters: nil)
                default:
                    preconditionFailure("unimplemented")
                }
            }
            
            let task = urlSession.dataTask(with: originalRequest, completionHandler: completionHandler)
            let activeSameTasks = currentTasks.filter {
                task.originalRequest?.url == $0.originalRequest?.url &&
                    task.originalRequest?.httpMethod == $0.originalRequest?.httpMethod &&
                    task.originalRequest?.httpBody == $0.originalRequest?.httpBody
            }
            
            if !activeSameTasks.isEmpty {
                print("Suspending previous tasks \(activeSameTasks.map { $0.originalRequest?.url })")
                activeSameTasks.forEach { $0.cancel() }
            }
            
            currentTasks.append(task)
            progress(task.progress)
            task.resume()
            
            #if DEBUG
            print(NSString(string: originalRequest.curlString))
            #endif
        } catch {
            print(error)
            result(.failure(error))
        }
    }
}

