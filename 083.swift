import Foundation

func readInt() -> Int {
    Int(readLine()!)!
}

func readInts() -> [Int] {
    readLine()!.split(separator: " ").map { Int(String($0))! }
}

let nm = readInts()
let n = nm[0]
let m = nm[1]

var g = [[Int]](repeating: [], count: n)
for _ in 0..<m {
    let ab = readInts()
    g[ab[0] - 1].append(ab[1] - 1)
    g[ab[1] - 1].append(ab[0] - 1)
}

let qN = readInt()
var x: [Int] = []
var y: [Int] = []

for _ in 0..<qN {
    let q = readInts()
    x.append(q[0] - 1)
    y.append(q[1])
}

let b = Int(sqrt(Double(2 * m)))
var large: Set<Int> = []
for i in 0..<n {
    if g[i].count >= b {
        large.insert(i)
    }
}

var largeLink = [Set<Int>](repeating: [], count: n)
for l in large {
    for i in g[l] {
        largeLink[i].insert(l)
    }
}

var update = [Int](repeating: -1, count: n)
var updateLarge = [Int](repeating: -1, count: n) //Largeは周辺への伝達を保留している

for i in 0..<qN {
    var last = update[x[i]]
    for l in largeLink[x[i]] {
        last = max(last, updateLarge[l])
    }
    print(last == -1 ? 1 : y[last])
    update[x[i]] = i
    if large.contains(x[i]) {
        updateLarge[x[i]] = i
    } else {
        for j in g[x[i]] {
            update[j] = i
        }
    }
}

/* 
 
 書き込み
 update[自分]はを更新する
 小ならupdate[周り]を更新
 大ならupdateLarge[自分]を更新
 
 読み込み
 update[自分]を見る
 updateLarge[接続している大]を見る
 
 伝達
 小1→小2 小1のタイミングで小2に伝える
 小1→大1 小1のタイミングで大1に伝える
 大1→小1 小1のタイミングで大1からもらう
 大1→大2 大2のタイミングで大1からもらう
 
 */
