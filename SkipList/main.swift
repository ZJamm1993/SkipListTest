//
//  main.swift
//  SkipList
//
//  Created by zjj on 2021/8/3.
//

import Foundation

print("Hello, World!")

func RandomInt() -> Int {
    return Int.random(in: -10000...10000)
}

let startTime = Date.timeIntervalSinceReferenceDate


var list = SkipList<Int, Int>(id: 1)

let dataSize = 10000

var checkList: [Int: Int] = [:
]
for i in stride(from: 100, through: dataSize, by: 3) {
    checkList[i] = i
}

var deleteList: [Int] = []
for i in stride(from: 111, through: dataSize, by: 4) {
    deleteList.append(i)
}

// add
for i in 0...dataSize {
//    list.setValue(RandomInt(), for: i)
    list[i] = RandomInt()
}
for i in checkList {
//    list.setValue(i.value, for: i.key)
    list[i.key] = i.value
}

// check
for i in checkList {
    let checkVal = i.value
//    let val = list.value(for: i.key)
    let val = list[i.key]
    assert(val == checkVal, "Get Value Error")
}

// delete
for i in deleteList {
//    list.removeValue(for: i)
//    let val = list.value(for: i)
    list[i] = nil
    let val = list[i]
    assert(val == nil, "Deleted Value Error")
}

let endTime = Date.timeIntervalSinceReferenceDate

print("Hello, World! Interval:", endTime - startTime)

print(list)
