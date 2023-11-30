import Foundation //atcoder上でexit文を使うため

func readInt() -> Int {
    Int(readLine()!)!
}

func readInts() -> [Int] {
    readLine()!.split(separator: " ").map { Int(String($0))! }
}

func nextPermu(_ a: inout [Int]) -> Bool {
    
    guard a.count >= 2 else {
        return false //nextは存在しない
    }
    
    let last = a.count - 1
    
    //find key place
    var key = -1
    var right = a[last]
    for i in (0..<last).reversed() {
        if a[i] < right {
            key = i
            break
        }
        right = a[i]
    }
    guard key != -1 else {
        return false
    }
    
    /* 例 123654のとき
     last 5
     key 2
     順番交換範囲 3個
     順番交換インデックス 3から5
     */
    
    //keyより右をひっくり返す
    let turn = last - key //交換範囲
    /* 例
     turn1 交換作業なし
     turn2 交換作業1回
     turn3 交換作業1回（真ん中は必要なし）
     turn4 交換作業2回
     */
    
    for i in 0..<turn / 2 {
        let temp = a[last - i]
        a[last - i] = a[key + 1 + i]
        a[key + 1 + i] = temp
    }
    
    //keyより右で、初めにあるkeyより大きいものをkeyと交換
    for i in 1...last - key {
        if a[key + i] > a[key] {
            let temp = a[key]
            a[key] = a[key + i]
            a[key + i] = temp
            break
        }
    }
    return true
}

let n = readInt()

var t: [[Int]] = []
for _ in 0..<n {
    t.append(readInts())
}

if n == 1 {
    _ = readInt()
    print(t[0][0])
    exit(0)
}

var pass = [[Bool]](repeating: [Bool](repeating: true, count: n), count: n)

for i in 0..<n {
    pass[i][i] = false
}

let m = readInt()

for _ in 0..<m {
    let noPass = readInts()
    pass[noPass[0] - 1][noPass[1] - 1] = false
    pass[noPass[1] - 1][noPass[0] - 1] = false
}

var order: [Int] = []
var ans = Int.max

for i in 0..<n {
    order.append(i)
}

repeat {
    var passCheck = true
    for i in 0...n - 2 {
        if pass[order[i]][order[i + 1]] == false {
            passCheck = false
            break
        }
    }
    if passCheck {
        var time = 0
        for i in 0..<n {
            time += t[order[i]][i]
        }
        ans = min(ans, time)
    }
    
} while (nextPermu(&order))

if ans == Int.max {
    print(-1)
} else {
    print(ans)
}
