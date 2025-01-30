//
//  HTTPMethod.swift
//  SwipeAssignment
//
//  Created by Satyam Singh on 29/01/25.
//

import Foundation

extension URLRequest {
    mutating func addHTTPMethod(with httpMethod: HTTPMethod) {
        self.httpMethod = httpMethod.rawValue
    }
    
    mutating func addAppJsonContentType() {
        self.addValue("application/json", forHTTPHeaderField: "Content-Type")
    }
    
    mutating func addAuthorization(withToken token: String) {
        self.addValue("Bearer " + token, forHTTPHeaderField: "Authorization")
        self.addValue("1", forHTTPHeaderField: "count")
        self.addValue("1234", forHTTPHeaderField: "ts")
        #if RELEASE
        self.addValue("RELEASE", forHTTPHeaderField: "env")
        #else
        self.addValue("DEV", forHTTPHeaderField: "env")
        #endif
        
    }
}

// MARK: HTTP Method [Enum]
enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case patch = "PATCH"
    case delete = "DELETE"
}


import Foundation

extension Data {
    // The boundary string for multipart form data (only generate once)
    static func boundary() -> String {
        return "Boundary-\(UUID().uuidString)"
    }

    mutating func appendFormField(name: String, value: String, boundary: String) {
        if let valueData = value.data(using: .utf8) {
            append("--\(boundary)\r\n".data(using: .utf8)!)
            append("Content-Disposition: form-data; name=\"\(name)\"\r\n\r\n".data(using: .utf8)!)
            append(valueData)
            append("\r\n".data(using: .utf8)!)
        }
    }

    mutating func appendFileField(name: String, filename: String, data: Data, boundary: String) {
        append("--\(boundary)\r\n".data(using: .utf8)!)
        append("Content-Disposition: form-data; name=\"\(name)\"; filename=\"\(filename)\"\r\n".data(using: .utf8)!)
        append("Content-Type: image/jpeg\r\n\r\n".data(using: .utf8)!)
        append(data)
        append("\r\n".data(using: .utf8)!)
    }
}

