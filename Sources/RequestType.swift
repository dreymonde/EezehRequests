//
//  Request.swift
//  CocoaNURE
//
//  Created by Oleg Dreyman on 17.02.16.
//  Copyright © 2016 Oleg Dreyman. All rights reserved.
//

import Foundation

/**
 *  Main protocol for requests
 */
public protocol RequestType: Receivable {
    
    associatedtype ResponseType
    
    var method: Method { get }
    var URL: NSURL { get }
    var body: NSData? { get set }
    var completion: (Response<ResponseType> -> Void) { get set }
    var error: (RequestError -> Void)? { get set }
    
    func execute() -> ()
    
}

/**
 Request method enum. Right now, only GET and POST is supported.
 
 - GET:  GET request.
 - POST: POST request.
 */
public enum Method: String {
    case GET, POST
}

/**
 Request error.
 
 - NetworkError:  Something is wrong with the network.
 - NoData:        No data was received.
 - JsonParseNull: Can't parse JSON from received data.
 */
public enum RequestError: ErrorType {
    case NetworkError(info: String)
    case NoData
    case JsonParseNull
}