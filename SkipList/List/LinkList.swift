//
//  LinkList.swift
//  SkipList
//
//  Created by zjj on 2021/8/4.
//

import Foundation

class LinkList<Key, Value> : KeyValueListProtocol, CustomStringConvertible, CustomDebugStringConvertible where Key: Comparable, Value: Any {
    var description: String {
        var total = "LinkList:\n"
        var node = firstNode
        var str = ""
        while let next = node.next {
            str.append("\(String(describing: next)), ")
            node = next
        }
        str.append("\n")
        total.append(str)
        
        return total
    }
    
    var debugDescription: String {
        return self.description
    }
    
    let firstNode: Node<Key, Value>
    
    init(id: Key) {
        self.firstNode = Node<Key, Value>(key: id, value: nil)
    }
    
    @discardableResult func value(for key: Key) -> Value? {
        var node = firstNode
        while let next = node.next, next.key <= key {
            if next.key < key {
                node = next
            } else if key == next.key {
                return next.value
            }
        }
        return nil
    }
    
    @discardableResult func setValue(_ value: Value, for key: Key) -> Value? {
        var node = firstNode
        while let next = node.next, next.key <= key {
            if next.key < key {
                node = next
            } else if key == next.key {
                let oldValue = next.value
                next.value = value
                return oldValue
            }
        }
        let prevs = node
        
        // 连接前后
        let newNode = Node<Key, Value>(key: key, value: value)
        newNode.next = prevs.next
        prevs.next = newNode
        return nil // return oldvalue if need
    }
    
    @discardableResult func removeValue(for key: Key) -> Value? {
        var node = firstNode
        
        while let next = node.next {
            if next.key < key {
                node = next
            } else if key == next.key {
                let oldVal = next.value
                node.next = next.next
                return oldVal
            }
        }
        return nil
    }
}

extension LinkList {
    class Node<Key, Value>: KeyValueListNodeProtocol, CustomStringConvertible, CustomDebugStringConvertible {
        
        deinit {
            self.deinitPrint()
        }
        
        var description: String {
            var vaStr = "nil"
            if value != nil {
                vaStr = "\(value!)"
            }
            return "(\(key):\(vaStr))"
        }
        
        var debugDescription: String {
            return self.description
        }
        
        let key: Key
        var value: Value?
        var next: Node<Key, Value>?
        init(key: Key, value: Value?) {
            self.key = key
            self.value = value
        }
    }
}

