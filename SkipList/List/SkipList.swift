//
//  SkipList.swift
//  SkipList
//
//  Created by zjj on 2021/8/3.
//

import Foundation

class SkipList<Key, Value> : KeyValueListProtocol, CustomStringConvertible, CustomDebugStringConvertible where Key: Comparable, Value: Any {
    var description: String {
        var total = "SkipList:\n"
        for i in stride(from: maxLevel - 1, through: 0, by: -1) {

            var node = firstNode
            var str = "level(\(i)): "
            if firstNode.nexts[i] == nil {
                continue
            }
            while let next = node.nexts[i] {
                str.append("\(String(describing: next)), ")
                node = next
            }
            str.append("\n")
            total.append(str)
        }
        
        return total
    }
    
    var debugDescription: String {
        return self.description
    }
    
    let firstNode: Node<Key, Value>
    fileprivate var currentMaxLevel: Int = 1
    fileprivate let maxLevel: Int = 32
    fileprivate let P: Double = 0.25
    
    init(id: Key) {
        self.firstNode = Node<Key, Value>(key: id, value: nil, level: maxLevel)
    }
    
    @discardableResult func value(for key: Key) -> Value? {
        var node = firstNode
        for i in stride(from: currentMaxLevel - 1, through: 0, by: -1) {
            while let next = node.nexts[i], next.key <= key {
                if next.key < key {
                    node = next
                } else if key == next.key {
                    return next.value
                }
            }
        }
        return nil
    }
    
    @discardableResult func setValue(_ value: Value, for key: Key) -> Value? {
        var node = firstNode
        var prevs = [Node<Key, Value>?](repeating: nil, count: currentMaxLevel)
        for i in stride(from: currentMaxLevel - 1, through: 0, by: -1) {
            while let next = node.nexts[i], next.key <= key {
                if next.key < key {
                    node = next
                } else if key == next.key {
                    let oldValue = next.value
                    next.value = value
                    return oldValue
                }
            }
            prevs[i] = node
        }
        
        // 连接前后
        let newLevel = randomLevel()
        let newNode = Node<Key, Value>(key: key, value: value, level: newLevel)
        for i in 0..<newLevel {
            if i < currentMaxLevel {
                newNode.nexts[i] = prevs[i]?.nexts[i]
                prevs[i]?.nexts[i] = newNode
            }
        }
        // 重置层数
        currentMaxLevel = max(newLevel, currentMaxLevel)
        return nil // return oldvalue if need
    }
    
    @discardableResult func removeValue(for key: Key) -> Value? {
        var node = firstNode
        var prevs = [Node<Key, Value>?](repeating: nil, count: currentMaxLevel)
        var exist = false
        for i in stride(from: currentMaxLevel - 1, through: 0, by: -1) {
            while let next = node.nexts[i] {
                if next.key < key {
                    node = next
                } else if key == next.key {
                    exist = true
                    break
                } else {
                    break
                }
//                if next.key >= key {
//                    break
//                }
            }
            prevs[i] = node
        }
        
        if !exist {
            return nil
        }
        let deleteNode = node.nexts[0]
        // 连接前后
        for i in 0..<(deleteNode?.nexts.count ?? 0) {
            if i < prevs.count {
                prevs[i]?.nexts[i] = deleteNode?.nexts[i]
            }
        }
        // 重置层数
        while let _ = firstNode.nexts[currentMaxLevel - 1] {
            if currentMaxLevel > 1 {
                currentMaxLevel -= 1
            } else {
                break
            }
        }
        return deleteNode?.value
    }
    
    private func randomLevel() -> Int {
        var lev = 1
        while Double.random(in: 0...1) < P && lev < maxLevel {
            lev += 1
        }
        return lev
    }
}

extension SkipList {
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
        var nexts: [Node<Key, Value>?]
        init(key: Key, value: Value?, level: Int) {
            self.key = key
            self.value = value
            self.nexts = [Node<Key, Value>?](repeating: nil, count: level)
        }
    }
}
