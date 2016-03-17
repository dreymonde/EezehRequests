//
//  JSONRequest.swift
//  NUREAPI
//
//  Created by Oleg Dreyman on 18.02.16.
//  Copyright © 2016 Oleg Dreyman. All rights reserved.
//

import Foundation

#if os(Linux)
    import Jay
#endif

#if os(Linux)
    public typealias JSON = [String: Any]
#else
    public typealias JSON = [String: AnyObject]
#endif

public class JSONRequest: RequestType {
    
    public let method: Method
    public let url: NSURL
    public var body: NSData?
    public var completion: (Response<JSON> -> Void)
    public var error: (RequestError -> Void)? = nil
    
    public init(_ method: Method, url: NSURL, _ completion: (Response<JSON> -> Void)) {
        self.method = method
        self.url = url
        self.completion = completion
        self.error = nil
    }
    
    public func execute() {
        let request = DataRequest(.GET, url: url) { response in
            do {
                let json = try self.parseJSON(fromData: response.data)
                let responseStruct = Response(data: json, statusCode: response.statusCode, headers: response.headers)
                self.completion(responseStruct)
                return
            } catch let error as NSError where error.code == 3840 {
                guard let data = self.fixFuckingCIST(response.data) else {
                    self.error?(.JsonParseNull)
                    return
                }
                do {
                    let json = try self.parseJSON(fromData: data)
                    let responseStruct = Response(data: json, statusCode: response.statusCode, headers: response.headers)
                    self.completion(responseStruct)
                    return
                } catch {
                    self.error?(.JsonParseNull)
                }
            } catch {
                // guard let data = self.fixFuckingCIST(response.data) else {
                //     self.error?(.JsonParseNull)
                //     return
                // }
                // do {
                //     let json = try self.parseJSON(fromData: data)
                //     let responseStruct = Response(data: json, statusCode: response.statusCode, headers: response.headers)
                //     self.completion(responseStruct)
                //     return
                // } catch {
                //     print(error)
                //     self.error?(.JsonParseNull)
                // }
                print(error)
                self.error?(.JsonParseNull)
            }
        }
        request.error = pushError
        request.execute()
    }

    public enum JsonParseError: ErrorType {
        case CastFail
    }

    private func parseJSON(fromData data: NSData) throws -> JSON {
        #if os(Linux) 
        let bytes = data.plainBytes
        let rawJSON = try Jay().jsonFromData(bytes)
        if let json = rawJSON as? JSON {
            return json
        } else {
            throw JsonParseError.CastFail
        }
        #else
        let rawJSON = try NSJSONSerialization.JSONObjectWithData(data, options: [])
        if let json = rawJSON as? JSON {
            return json
        } else {
            throw JsonParseError.CastFail
        }
        #endif
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