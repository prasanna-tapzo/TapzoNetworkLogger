//
//  NetworkStatusIcon.swift
//  NetworkLogger
//
//  Created by Prasanna Aithal on 23/06/17.
//  Copyright © 2017 Prasanna Aithal. All rights reserved.
//

import Foundation

// Icon representation for netwrok response
let ResponseStatusIcon = [
    1: "ℹ️", // 1xx - ["Informational]
    2: "✅", // 2xx - ["Success"]
    3: "⤴️", // 3xx - ["Redirection"]
    4: "⛔️", // 4xx - ["Clinet Error"]
    5: "❌"  // 5xx  - ["Server Error"]
]

// Text representation for network response
let ResponseStatusString = [
    // 1xx (Informational)
    100: "Continue",
    101: "Switching Protocols",
    102: "Processing",
    
    // 2xx (Success)
    200: "OK",
    201: "Created",
    202: "Accepted",
    203: "Non-Authoritative Information",
    204: "No Content",
    205: "Reset Content",
    206: "Partial Content",
    207: "Multi-Status",
    208: "Already Reported",
    226: "IM Used",
    
    // 3xx (Redirection)
    300: "Multiple Choices",
    301: "Moved Permanently",
    302: "Found",
    303: "See Other",
    304: "Not Modified",
    305: "Use Proxy",
    306: "Switch Proxy",
    307: "Temporary Redirect",
    308: "Permanent Redirect",
    
    // 4xx (Client Error)
    400: "Bad Request",
    401: "Unauthorized",
    402: "Payment Required",
    403: "Forbidden",
    404: "Not Found",
    405: "Method Not Allowed",
    406: "Not Acceptable",
    407: "Proxy Authentication Required",
    408: "Request Timeout",
    409: "Conflict",
    410: "Gone",
    411: "Length Required",
    412: "Precondition Failed",
    413: "Request Entity Too Large",
    414: "Request-URI Too Long",
    415: "Unsupported Media Type",
    416: "Requested Range Not Satisfiable",
    417: "Expectation Failed",
    418: "I'm a teapot",
    420: "Enhance Your Calm",
    422: "Unprocessable Entity",
    423: "Locked",
    424: "Method Failure",
    425: "Unordered Collection",
    426: "Upgrade Required",
    428: "Precondition Required",
    429: "Too Many Requests",
    431: "Request Header Fields Too Large",
    451: "Unavailable For Legal Reasons",
    
    // 5xx (Server Error)
    500: "Internal Server Error",
    501: "Not Implemented",
    502: "Bad Gateway",
    503: "Service Unavailable",
    504: "Gateway Timeout",
    505: "HTTP Version Not Supported",
    506: "Variant Also Negotiates",
    507: "Insufficient Storage",
    508: "Loop Detected",
    509: "Bandwidth Limit Exceeded",
    510: "Not Extended",
    511: "Network Authentication Required"
]

let HttpMethodIcon = [
    "POST":   "⬆️",
    "GET":    "⬇️",
    "PUT":    "↔️",
    "PATCH":  "🔃",
    "DELETE": "⏹"
]


protocol LogLevelProtocol {
    static func verboseLog(_ message: String)
}

class Logger: LogLevelProtocol {
    static func verboseLog(_ message: String) {
        print(message)
    }
}

public class NetworkLogger {
    
    public static func logRequest(_ request: URLRequest) -> () {
        #if DEBUG
            var s = ""
            
            if let method = request.httpMethod {
                s += "\(HttpMethodIcon[method]!) "
                s += "\(method) "
            }
            if let url = request.url?.absoluteString {
                s += "'\(url)' "
            }
            if let headers = request.allHTTPHeaderFields , headers.count > 0 {
                s += "\n" + logHeaders(headers as [String : AnyObject])
            }

            Logger.verboseLog(s)
        #else
        #endif
    }
    public static func logResponse(_ response: URLResponse) -> () {
       
        #if DEBUG
           var s = ""
           if let url = response.url?.absoluteString {
                s += "\(url) "
            }
            
            if let httpResponse = response as? HTTPURLResponse {
                s += "("
                
                let iconNumber = Int(floor(Double(httpResponse.statusCode) / 100.0))
                if let iconString = ResponseStatusIcon[iconNumber] {
                    s += "\(iconString) "
                }
                
                
                s += "\(httpResponse.statusCode)"
                if let statusString = ResponseStatusString[httpResponse.statusCode] {
                    s += " \(statusString)"
                }
                s += ")"
            }
            Logger.verboseLog(s)

        #else
        #endif
    }
    
   static private func logHeaders(_ headers: [String: AnyObject]) -> String {
        var s = "Headers: [\n"
        for (key, value) in headers {
            s += "\t\(key) : \(value)\n"
        }
        s += "]"
        return s
    }
}
