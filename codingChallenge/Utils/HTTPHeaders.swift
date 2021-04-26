//
//  APIUtils.swift
//  AirLST
//
//  Created by Dmitry Zawadsky on 26.05.2020.
//  Copyright © 2020 AirLST. All rights reserved.
//

import Foundation

/// An order-preserving and case-insensitive representation of HTTP headers.
struct HTTPHeaders {
    private var headers: [HTTPHeader] = []

    /// Creates an empty instance.
    init() {}

    /// Creates an instance from an array of `HTTPHeader`s. Duplicate case-insensitive names are collapsed into the last
    /// name and value encountered.
    init(_ headers: [HTTPHeader]) {
        self.init()

        headers.forEach { update($0) }
    }

    /// Creates an instance from a `[String: String]`. Duplicate case-insensitive names are collapsed into the last name
    /// and value encountered.
    init(_ dictionary: [String: String]) {
        self.init()

        dictionary.forEach { update(HTTPHeader(name: $0.key, value: $0.value)) }
    }

    /// Case-insensitively updates or appends an `HTTPHeader` into the instance using the provided `name` and `value`.
    ///
    /// - Parameters:
    ///   - name:  The `HTTPHeader` name.
    ///   - value: The `HTTPHeader value.
    mutating func add(name: String, value: String) {
        update(HTTPHeader(name: name, value: value))
    }

    /// Case-insensitively updates or appends the provided `HTTPHeader` into the instance.
    ///
    /// - Parameter header: The `HTTPHeader` to update or append.
    mutating func add(_ header: HTTPHeader) {
        update(header)
    }

    /// Case-insensitively updates or appends an `HTTPHeader` into the instance using the provided `name` and `value`.
    ///
    /// - Parameters:
    ///   - name:  The `HTTPHeader` name.
    ///   - value: The `HTTPHeader value.
    mutating func update(name: String, value: String) {
        update(HTTPHeader(name: name, value: value))
    }

    /// Case-insensitively updates or appends the provided `HTTPHeader` into the instance.
    ///
    /// - Parameter header: The `HTTPHeader` to update or append.
    mutating func update(_ header: HTTPHeader) {
        guard let index = headers.index(of: header.name) else {
            headers.append(header)
            return
        }

        headers.replaceSubrange(index...index, with: [header])
    }

    /// Case-insensitively removes an `HTTPHeader`, if it exists, from the instance.
    ///
    /// - Parameter name: The name of the `HTTPHeader` to remove.
    mutating func remove(name: String) {
        guard let index = headers.index(of: name) else { return }

        headers.remove(at: index)
    }

    /// Sort the current instance by header name.
    mutating func sort() {
        headers.sort { $0.name < $1.name }
    }

    /// Returns an instance sorted by header name.
    ///
    /// - Returns: A copy of the current instance sorted by name.
    func sorted() -> HTTPHeaders {
        HTTPHeaders(headers.sorted { $0.name < $1.name })
    }

    /// Case-insensitively find a header's value by name.
    ///
    /// - Parameter name: The name of the header to search for, case-insensitively.
    ///
    /// - Returns:        The value of header, if it exists.
    func value(for name: String) -> String? {
        guard let index = headers.index(of: name) else { return nil }

        return headers[index].value
    }

    /// Case-insensitively access the header with the given name.
    ///
    /// - Parameter name: The name of the header.
    subscript(_ name: String) -> String? {
        get { value(for: name) }
        set {
            if let value = newValue {
                update(name: name, value: value)
            } else {
                remove(name: name)
            }
        }
    }

    /// The dictionary representation of all headers.
    ///
    /// This representation does not preserve the current order of the instance.
    var dictionary: [String: String] {
        let namesAndValues = headers.map { ($0.name, $0.value) }

        return Dictionary(namesAndValues, uniquingKeysWith: { _, last in last })
    }
}

enum DataCarrier {
    case parameters(HTTPParameters?)
}

struct HTTPMethod: RawRepresentable, Equatable, Hashable {
    /// `CONNECT` method.
    static let connect = HTTPMethod(rawValue: "CONNECT")
    /// `DELETE` method.
    static let delete = HTTPMethod(rawValue: "DELETE")
    /// `GET` method.
    static let get = HTTPMethod(rawValue: "GET")
    /// `HEAD` method.
    static let head = HTTPMethod(rawValue: "HEAD")
    /// `OPTIONS` method.
    static let options = HTTPMethod(rawValue: "OPTIONS")
    /// `PATCH` method.
    static let patch = HTTPMethod(rawValue: "PATCH")
    /// `POST` method.
    static let post = HTTPMethod(rawValue: "POST")
    /// `PUT` method.
    static let put = HTTPMethod(rawValue: "PUT")
    /// `TRACE` method.
    static let trace = HTTPMethod(rawValue: "TRACE")

    let rawValue: String

    init(rawValue: String) {
        self.rawValue = rawValue
    }
}

extension HTTPHeaders: ExpressibleByDictionaryLiteral {
    public init(dictionaryLiteral elements: (String, String)...) {
        self.init()

        elements.forEach { update(name: $0.0, value: $0.1) }
    }
}

extension HTTPHeaders: ExpressibleByArrayLiteral {
    public init(arrayLiteral elements: HTTPHeader...) {
        self.init(elements)
    }
}

extension HTTPHeaders: Sequence {
    public func makeIterator() -> IndexingIterator<[HTTPHeader]> {
        headers.makeIterator()
    }
}

extension HTTPHeaders: Collection {
    var startIndex: Int {
        headers.startIndex
    }

    var endIndex: Int {
        headers.endIndex
    }

    subscript(position: Int) -> HTTPHeader {
        headers[position]
    }

    func index(after i: Int) -> Int {
        headers.index(after: i)
    }
}

extension HTTPHeaders: CustomStringConvertible {
    var description: String {
        headers.map { $0.description }.joined(separator: "\n")
    }
}

// MARK: - HTTPHeader

/// A representation of a single HTTP header's name / value pair.
public struct HTTPHeader: Hashable {
    /// Name of the header.
    let name: String

    /// Value of the header.
    let value: String

    /// Creates an instance from the given `name` and `value`.
    ///
    /// - Parameters:
    ///   - name:  The name of the header.
    ///   - value: The value of the header.
    init(name: String, value: String) {
        self.name = name
        self.value = value
    }
}

extension HTTPHeader: CustomStringConvertible {
    public var description: String {
        "\(name): \(value)"
    }
}

internal extension HTTPHeader {
    /// Returns an `Accept` header.
    ///
    /// - Parameter value: The `Accept` value.
    /// - Returns:         The header.
    static func accept(_ value: String) -> HTTPHeader {
        HTTPHeader(name: "Accept", value: value)
    }

    /// Returns an `Accept-Charset` header.
    ///
    /// - Parameter value: The `Accept-Charset` value.
    /// - Returns:         The header.
    static func acceptCharset(_ value: String) -> HTTPHeader {
        HTTPHeader(name: "Accept-Charset", value: value)
    }

    /// Returns an `Accept-Language` header.
    ///
    /// Alamofire offers a default Accept-Language header that accumulates and encodes the system's preferred languages.
    /// Use `HTTPHeader.defaultAcceptLanguage`.
    ///
    /// - Parameter value: The `Accept-Language` value.
    ///
    /// - Returns:         The header.
    static func acceptLanguage(_ value: String) -> HTTPHeader {
        HTTPHeader(name: "Accept-Language", value: value)
    }

    /// Returns an `Accept-Encoding` header.
    ///
    /// Alamofire offers a default accept encoding value that provides the most common values. Use
    /// `HTTPHeader.defaultAcceptEncoding`.
    ///
    /// - Parameter value: The `Accept-Encoding` value.
    ///
    /// - Returns:         The header
    static func acceptEncoding(_ value: String) -> HTTPHeader {
        HTTPHeader(name: "Accept-Encoding", value: value)
    }

    /// Returns a `Basic` `Authorization` header using the `username` and `password` provided.
    ///
    /// - Parameters:
    ///   - username: The username of the header.
    ///   - password: The password of the header.
    ///
    /// - Returns:    The header.
    static func authorization(username: String, password: String) -> HTTPHeader {
        let credential = Data("\(username):\(password)".utf8).base64EncodedString()

        return authorization("Basic \(credential)")
    }

    /// Returns a `Bearer` `Authorization` header using the `bearerToken` provided
    ///
    /// - Parameter bearerToken: The bearer token.
    ///
    /// - Returns:               The header.
    static func authorization(bearerToken: String) -> HTTPHeader {
        authorization("Bearer \(bearerToken)")
    }

    /// Returns an `Authorization` header.
    ///
    /// Alamofire provides built-in methods to produce `Authorization` headers. For a Basic `Authorization` header use
    /// `HTTPHeader.authorization(username:password:)`. For a Bearer `Authorization` header, use
    /// `HTTPHeader.authorization(bearerToken:)`.
    ///
    /// - Parameter value: The `Authorization` value.
    ///
    /// - Returns:         The header.
    static func authorization(_ value: String) -> HTTPHeader {
        HTTPHeader(name: "Authorization", value: value)
    }

    /// Returns a `Content-Disposition` header.
    ///
    /// - Parameter value: The `Content-Disposition` value.
    ///
    /// - Returns:         The header.
    static func contentDisposition(_ value: String) -> HTTPHeader {
        HTTPHeader(name: "Content-Disposition", value: value)
    }

    /// Returns a `Content-Type` header.
    ///
    /// All Alamofire `ParameterEncoding`s and `ParameterEncoder`s set the `Content-Type` of the request,
    /// so it may not be necessary to manually
    /// set this value.
    ///
    /// - Parameter value: The `Content-Type` value.
    ///
    /// - Returns:         The header.
    static func contentType(_ value: String) -> HTTPHeader {
        HTTPHeader(name: "Content-Type", value: value)
    }

    /// Returns a `User-Agent` header.
    ///
    /// - Parameter value: The `User-Agent` value.
    ///
    /// - Returns:         The header.
    static func userAgent(_ value: String) -> HTTPHeader {
        HTTPHeader(name: "User-Agent", value: value)
    }
}

extension Array where Element == HTTPHeader {
    /// Case-insensitively finds the index of an `HTTPHeader` with the provided name, if it exists.
    func index(of name: String) -> Int? {
        let lowercasedName = name.lowercased()
        return firstIndex { $0.name.lowercased() == lowercasedName }
    }
}

// MARK: - Defaults

extension HTTPHeaders {
    /// The default set of `HTTPHeaders` used by Alamofire. Includes `Accept-Encoding`, `Accept-Language`, and
    /// `User-Agent`.
    static let `default`: HTTPHeaders = [.defaultAcceptEncoding,
                                         .defaultAcceptLanguage,
                                         .defaultUserAgent]
}

extension HTTPHeader {
    /// Returns Alamofire's default `Accept-Encoding` header, appropriate for the encodings supported by particular OS
    /// versions.
    ///
    /// See the [Accept-Encoding HTTP header documentation](https://tools.ietf.org/html/rfc7230#section-4.2.3) .
    static let defaultAcceptEncoding: HTTPHeader = {
        let encodings: [String]
        if #available(iOS 11.0, macOS 10.13, tvOS 11.0, watchOS 4.0, *) {
            encodings = ["br", "gzip", "deflate"]
        } else {
            encodings = ["gzip", "deflate"]
        }

        return .acceptEncoding(encodings.qualityEncoded())
    }()

    /// Returns Alamofire's default `Accept-Language` header, generated by querying `Locale` for the user's
    /// `preferredLanguages`.
    ///
    /// See the [Accept-Language HTTP header documentation](https://tools.ietf.org/html/rfc7231#section-5.3.5).
    static let defaultAcceptLanguage: HTTPHeader = {
        .acceptLanguage(Locale.preferredLanguages.prefix(6).qualityEncoded())
    }()

    /// Returns Alamofire's default `User-Agent` header.
    ///
    /// See the [User-Agent header documentation](https://tools.ietf.org/html/rfc7231#section-5.5.3).
    ///
    /// Example: `iOS Example/1.0 (org.alamofire.iOS-Example; build:1; iOS 13.0.0) Alamofire/5.0.0`
    static let defaultUserAgent: HTTPHeader = {
        let info = Bundle.main.infoDictionary
        let executable = (info?[kCFBundleExecutableKey as String] as? String) ??
            (ProcessInfo.processInfo.arguments.first?.split(separator: "/").last.map(String.init)) ??
        "Unknown"
        let bundle = info?[kCFBundleIdentifierKey as String] as? String ?? "Unknown"
        let appVersion = info?["CFBundleShortVersionString"] as? String ?? "Unknown"
        let appBuild = info?[kCFBundleVersionKey as String] as? String ?? "Unknown"

        let osNameVersion: String = {
            let version = ProcessInfo.processInfo.operatingSystemVersion
            let versionString = "\(version.majorVersion).\(version.minorVersion).\(version.patchVersion)"
            let osName: String = {
                #if os(iOS)
                return "iOS"
                #elseif os(watchOS)
                return "watchOS"
                #elseif os(tvOS)
                return "tvOS"
                #elseif os(macOS)
                return "macOS"
                #elseif os(Linux)
                return "Linux"
                #elseif os(Windows)
                return "Windows"
                #else
                return "Unknown"
                #endif
            }()

            return "\(osName) \(versionString)"
        }()

        let userAgent = "\(executable)/\(appVersion) (\(bundle); build:\(appBuild); \(osNameVersion)) URLSession"

        return .userAgent(userAgent)
    }()
}

extension Collection where Element == String {
    func qualityEncoded() -> String {
        enumerated().map { index, encoding in
            let quality = 1.0 - (Double(index) * 0.1)
            return "\(encoding);q=\(quality)"
        }.joined(separator: ", ")
    }
}
