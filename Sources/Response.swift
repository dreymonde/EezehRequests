//
//  Response.swift
//  NUREAPI
//
//  Created by Oleg Dreyman on 18.02.16.
//  Copyright © 2016 Oleg Dreyman. All rights reserved.
//

import Foundation

public struct Response<T> {
    public init(data: T, response: NSHTTPURLResponse) {
        self.data = data
        self.response = response
    }
        
    public var data: T
    public var response: NSHTTPURLResponse
    public var statusCode: Int {
        return response.statusCode
    }
    public var headers: [NSObject: AnyObject] {
        return response.allHeaderFields
    }
}