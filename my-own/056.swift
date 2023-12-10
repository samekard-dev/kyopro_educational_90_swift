/*
 DPでは「Aを足す」「Bを足す」ではなく、AとBの差を用いて「足す」「足さない」の2通り
 AとBの差が大きい日から行うように並べ替える
 大きすぎて正解の可能性がなくなった値は捨てる
 小さすぎて正解の可能性がなくなった値は捨てる(selectAllHigherを用いて残りすべて大きい方を選択しても届くか判定する)
 一度見たところはもう見ない(checked)
 */

import Foundation

func readInts() -> [Int] {
    readLine()!.split(separator: " ").map { Int(String($0))! }
}

let ns = readInts()
let n = ns[0]
let s = ns[1]
var aGTb = [Bool](repeating: false, count: n)
var diff = [(day: Int, value: Int)](repeating: (0, 0), count: n)
var target = s

for i in 0..<n {
    let ab = readInts()
    aGTb[i] = ab[0] > ab[1]
    diff[i] = (i, max(ab[0], ab[1]) - min(ab[0], ab[1]))
    target -= min(ab[0], ab[1])
}

if target < 0 {
    print("Impossible")
    exit(0)
}

diff = diff.sorted(by: { $0.value > $1.value } )

var selectAllHigher = [Int](repeating: 0, count: n)
//selectAllHigher[i] : i以降(i含む)全部高い方を選んだらどれだけになるか
selectAllHigher[n - 1] = diff[n - 1].value
for i in (0..<n - 1).reversed() {
    selectAllHigher[i] = selectAllHigher[i + 1] + diff[i].value
}

var printed = false
var history = [Bool](repeating: false, count: n)
var checked = [Int](repeating: Int.max, count: target + 1) //targetが0未満の場合はすでにexit(0)している前提

func seek(index: Int, current: Int) {
    guard printed == false else {
        return
    }
    if current > target {
        return
    }
    if current + selectAllHigher[index] < target {
        return
    }
    if checked[current] <= index {
        return
    }
    
    if current == target {
        printHistory()
    } else if index == n - 1 {
        if current + diff[index].value == target {
            history[index] = true
            printHistory()
            history[index] = false
        }
    } else {
        //lower
        seek(index: index + 1, current: current)
        
        //higher
        history[index] = true
        seek(index: index + 1, current: current + diff[index].value)
        history[index] = false
    }
    checked[current] = min(checked[current], index)
}

func printHistory() {
    var result = [Bool](repeating: false, count: n)
    for i in 0..<n {
        result[diff[i].day] = history[i]
    }
    for i in 0..<n {
        if result[i] == aGTb[i] {
            print("A", terminator: "")
        } else {
            print("B", terminator: "")
        }
        //a[i] = b[i]のときはAでもBでも正解となるはず...
    }
    print()
    printed = true
}

seek(index: 0, current: 0)

if printed == false {
    print("Impossible")
}
