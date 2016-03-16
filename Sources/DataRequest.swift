//
//  DataRequest.swift
//  NUREAPI
//
//  Created by Oleg Dreyman on 18.02.16.
//  Copyright © 2016 Oleg Dreyman. All rights reserved.
//
#if os(Linux)
import HTTPClient
#endif

import Foundation

/// Request which returns NSData
public class DataRequest: RequestType {
    
    /// Request method
    public let method: Method
    /// Request URL.
    public let url: NSURL
    /// Request NSData body. Leave like nil if you don't want to pass anything.
    public var body: NSData?
    /// Completion handler. Set with init.
    public var completion: (Response<NSData> -> Void)
    /// Optional error handler.
    public var error: (RequestError -> Void)? = nil
    
    public init(_ method: Method, url: NSURL, _ completion: (Response<NSData> -> Void)) {
        self.method = method
        self.url = url
        self.completion = completion
        self.error = nil
    }
    
    public func execute() -> () {

        #if os(Linux)
        guard let host = url.host, path = url.path else {
            self.error?(.CantSendRequest)
            return
        }
        print(host)
        print(path)
        do {
            let client = try Client(host: host, port: 80)
            let result = try client.get(path)
            guard let received = result.body.buffer else {
                self.error?(.NoData)
                return
            }
            let data = NSData(bytes: received.bytes, length: received.count)
            // TODO: Headers
            let responseStruct = Response(data: data, statusCode: result.statusCode, headers: [:])
            self.completion(responseStruct)
        } catch {
            self.error?(.NetworkError(info: String(error)))
            return
        }
        #else
        let nRequest = NSMutableURLRequest(url: url)
        nRequest.HTTPMethod = method.rawValue
        nRequest.HTTPBody = body
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(nRequest) { data, response, error in
            guard error == nil else {
                self.error?(.NetworkError(info: error!.description))
                return
            }
            
            guard let httpResponse = response as? NSHTTPURLResponse else {
                self.error?(.NetworkError(info: "Response is not HTTPURLResponse"))
                return
            }
            
            guard let data = data else {
                self.error?(.NoData)
                return
            }
            
            let responseStruct = Response(data: data, response: httpResponse)
            self.completion(responseStruct)
        }
        task.resume()
        #endif
    }
    
}