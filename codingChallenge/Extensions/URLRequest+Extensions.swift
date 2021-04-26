//
//  URLRequest.swift
//  AirLST
//
//  Created by Dmitryj on 19/03/2019.
//  Copyright © 2019 AirLST. All rights reserved.
//

import Foundation

extension URLRequest {
    
    /// Returns a cURL command representation of this URL request.
    var curlString: String {
        
        guard let url = url else { return "" }
        
        var baseCommand = "curl \"\(url.absoluteString)\""
        if httpMethod == "HEAD" {
            baseCommand += " --head"
        }
        
        var command = [baseCommand]
        if let method = httpMethod, method != "GET" && method != "HEAD" {
            command.append("-X \(method)")
        }
        
        if let headers = allHTTPHeaderFields?.map ({ ($0.key, $0.value) }).sorted(by: { $0.0 > $1.0 }) {
            for (key, value) in headers where key != "Cookie" {
                command.append("-H '\(key): \(value)'")
            }
        }
        
        if let data = httpBody,
           let body = String(data: data, encoding: .utf8) {
            command.append("-d '\(body)'")
        }
        
        return command.joined(separator: " \\\n\t")
    }
    
    /// Returns `allHTTPHeaderFields` as `HTTPHeaders`.
    var headers: HTTPHeaders {
        get { allHTTPHeaderFields.map(HTTPHeaders.init) ?? HTTPHeaders() }
        set { allHTTPHeaderFields = newValue.dictionary }
    }
    
    init(url: URL, method: HTTPMethod, headers: HTTPHeaders?, parameters: HTTPParameters?) throws {
        self.init(url: url)
        commonSetup(method: method, headers: headers)
        
        if let parameters = parameters {
            httpBody = try JSONSerialization.data(withJSONObject: parameters)
        }
    }
    
    init(url: URL, method: HTTPMethod, headers: HTTPHeaders?, body: Data?) throws {
        self.init(url: url)
        commonSetup(method: method, headers: headers)
        
        httpBody = body
    }
    
    fileprivate mutating func commonSetup(method: HTTPMethod, headers: HTTPHeaders?) {
        httpMethod = method.rawValue
        addValue("application/json;charset=UTF-8", forHTTPHeaderField: "Content-Type")
        headers?.forEach { header in
            addValue(header.value, forHTTPHeaderField: header.name)
        }
    }
}

extension CharacterSet {
    /// Creates a CharacterSet from RFC 3986 allowed characters.
    ///
    /// RFC 3986 states that the following characters are "reserved" characters.
    ///
    /// - General Delimiters: ":", "#", "[", "]", "@", "?", "/"
    /// - Sub-Delimiters: "!", "$", "&", "'", "(", ")", "*", "+", ",", ";", "="
    ///
    /// In RFC 3986 - Section 3.4, it states that the "?" and "/" characters should not be escaped to allow
    /// query strings to include a URL. Therefore, all "reserved" characters with the exception of "?" and "/"
    /// should be percent-escaped in the query string.
    public static let rfcURLQueryAllowed: CharacterSet = {
        let generalDelimitersToEncode = ":#[]@" // does not include "?" or "/" due to RFC 3986 - Section 3.4
        let subDelimitersToEncode = "!$&'()*+,;="
        let encodableDelimiters = CharacterSet(charactersIn: "\(generalDelimitersToEncode)\(subDelimitersToEncode)")

        return CharacterSet.urlQueryAllowed.subtracting(encodableDelimiters)
    }()
}

extension HTTPURLResponse {
    /// Returns `allHeaderFields` as `HTTPHeaders`.
    var headers: HTTPHeaders {
        (allHeaderFields as? [String: String]).map(HTTPHeaders.init) ?? HTTPHeaders()
    }
}

extension URLSessionConfiguration {
    /// Returns `httpAdditionalHeaders` as `HTTPHeaders`.
    var headers: HTTPHeaders {
        get { (httpAdditionalHeaders as? [String: String]).map(HTTPHeaders.init) ?? HTTPHeaders() }
        set { httpAdditionalHeaders = newValue.dictionary }
    }
}
