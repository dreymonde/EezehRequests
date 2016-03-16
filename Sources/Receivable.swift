//
//  Receivable.swift
//  NUREAPI
//
//  Created by Oleg Dreyman on 18.02.16.
//  Copyright © 2016 Oleg Dreyman. All rights reserved.
//

import Foundation

public protocol Receivable {

	associatedtype Received
    associatedtype AnError = ErrorType

	var completion: (Received -> Void) { get }
	var error: (AnError -> Void)? { get set }

	func execute() -> ()

}

extension Receivable {
    
    public var pushError: (AnError -> Void) {
        return { error in
            self.error?(error)
        }
    }
    
}