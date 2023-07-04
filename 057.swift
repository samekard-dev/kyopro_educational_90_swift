func readInt() -> Int {
    Int(readLine()!)!
}

func readInts() -> [Int] {
    readLine()!.split(separator: " ").map { Int(String($0))! }
}

let nm = readInts()
let n = nm[0] //スイッチ数
let m = nm[1] //パネル数

var t = [[Bool]](repeating: [Bool](repeating: false, count: m), count: n)

for s in 0..<n {
    _ = readLine()!
    let pp = readInts()
    for p in pp {
        t[s][p - 1] = true
    }
}

var target: [Bool] = readInts().map { $0 == 1 }

var newSwPos = 0
for p in 0..<m {
    var found = false
    for s in newSwPos..<n {
        if t[s][p] {
            if s != newSwPos {
                let temp = t[s]
                t[s] = t[newSwPos]
                t[newSwPos] = temp
            }
            found = true
            break
        }
    }
    if found {
        for s in newSwPos + 1..<n {
            if t[s][p] {
                for i in p..<m {
                    t[s][i] = t[s][i] != t[newSwPos][i]
                }
            }
        }
        if target[p] {
            for i in p..<m {
                target[i] = target[i] != t[newSwPos][i]
            }
        }
        newSwPos += 1
    }
}

if let _ = target.first(where: { $0 })  {
    print("0")
} else {
    var ans = 1
    for _ in newSwPos..<n {
        ans *= 2
        ans %= 998244353
    }
    print(ans)
}
