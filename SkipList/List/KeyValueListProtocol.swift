//
//  KeyValueListProtocol.swift
//  SkipList
//
//  Created by zjj on 2021/8/4.
//

import Foundation

protocol KeyValueListProtocol {
    associatedtype Key
    associatedtype Value
    
    func value(for key: Key) -> Value?
    func setValue(_ value: Value, for key: Key) -> Value?
    func removeValue(for key: Key) -> Value?
}

protocol KeyValueListNodeProtocol {
    
}

extension KeyValueListNodeProtocol {
    func deinitPrint() {
//        print("deinit", self)
    }
}
