//
//  JSONRequest.swift
//  NUREAPI
//
//  Created by Oleg Dreyman on 18.02.16.
//  Copyright © 2016 Oleg Dreyman. All rights reserved.
//

import Foundation

public typealias JSON = [String: AnyObject]

public class JSONRequest: RequestType {
    
    public let method: Method
    public let URL: NSURL
    public var body: NSData?
    public var completion: (Response<JSON> -> Void)
    public var error: (RequestError -> Void)? = nil
    
    public init(_ method: Method, url: NSURL, _ completion: (Response<JSON> -> Void)) {
        self.method = method
        self.URL = url
        self.completion = completion
        self.error = nil
    }
    
    public func execute() {
        let request = DataRequest(.GET, url: URL) { response in
            do {
                if let json = try NSJSONSerialization.JSONObjectWithData(response.data, options: []) as? JSON {
                    let responseStruct = Response(data: json, response: response.response)
                    self.completion(responseStruct)
                    return
                }
                self.error?(.JsonParseNull)
            } catch {
                // print("Can't parse CIST JSON, remaking")
                guard let data = self.fixFuckingCIST(response.data) else {
                    self.error?(.JsonParseNull)
                    return
                }
                do {
                    if let json = try NSJSONSerialization.JSONObjectWithData(data, options: [.AllowFragments]) as? JSON {
                        let responseStruct = Response(data: json, response: response.response)
                        self.completion(responseStruct)
                        return
                    }
                    self.error?(.JsonParseNull)
                } catch {
                    self.error?(.JsonParseNull)
                }
            }
        }
        request.error = pushError
        request.execute()
    }
        
    private func fixFuckingCIST(data: NSData) -> NSData? {
        guard let received = String(data: data, encoding: NSWindowsCP1251StringEncoding) else {
            return nil
        }
        guard let dataFromString = received.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false) else {
            return nil
        }
        return dataFromString
    }
    
}