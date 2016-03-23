//
//  Response.swift
//  NUREAPI
//
//  Created by Oleg Dreyman on 18.02.16.
//  Copyright © 2016 Oleg Dreyman. All rights reserved.
//

import Foundation

public struct Response<T> {

    #if !os(Linux)
    public var response: NSHTTPURLResponse?

    public init(data: T, response: NSHTTPURLResponse) {
        self.data = data
        self.response = response
        self.statusCode = response.statusCode ?? 0
        self.headers = response.allHeaderFields as? [String: AnyObject] ?? [:]
    }
    #endif

    public init(data: T, statusCode: Int, headers: [String: AnyObject]) {
        self.data = data
        self.statusCode = statusCode
        self.headers = headers
    }

    public var data: T
    public var statusCode: Int
    public var headers: [String: AnyObject]
}
