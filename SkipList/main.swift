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


let list = SkipList<Int, Int>(id: 1)

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
    list.setValue(RandomInt(), for: i)
}
for i in checkList {
    list.setValue(i.value, for: i.key)
}

// check
for i in checkList {
    let checkVal = i.value
    let val = list.value(for: i.key)
    assert(val == checkVal, "Get Value Error")
}

// delete
for i in deleteList {
    list.removeValue(for: i)
    let val = list.value(for: i)
    assert(val == nil, "Deleted Value Error")
}

let endTime = Date.timeIntervalSinceReferenceDate

print("Hello, World! Interval:", endTime - startTime)

//print(list)
