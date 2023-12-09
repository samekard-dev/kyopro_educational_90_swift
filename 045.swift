func readInts() -> [Int] {
    readLine()!.split(separator: " ").map { Int(String($0))! }
}

let nk = readInts()
let n = nk[0]
let kN = nk[1]

var x: [Int] = []
var y: [Int] = []

for _ in 0..<n {
    let xy = readInts()
    x.append(xy[0])
    y.append(xy[1])
}

//2点間の距離
var dist = [[Int]](repeating: [Int](repeating: 0, count: n), count: n)
for i in 0..<n {
    for j in 0..<n {
        dist[i][j] = (x[i] - x[j]) * (x[i] - x[j]) + (y[i] - y[j]) * (y[i] - y[j])
    }
}

//すべてのグループ(2^N-1通りある)の中で一番遠い距離を記録する
var cost = [Int](repeating: 0, count: 1 << n)
for selected in 1..<(1 << n) {
    for i in 0..<n where (1 << i) & selected != 0 {
        for j in 0..<i where (1 << j) & selected != 0 {
            cost[selected] = max(cost[selected], dist[i][j])
        }
    }
}

//dp[selected]
//selectedを分割した中での最低コスト
//分割の個数はforブロックの中で1分割、2分割...と増えていく
var dp = [Int](repeating: Int.max, count: 1 << n)
for i in 0..<(1 << n) {
    dp[i] = cost[i]
}

//あるselectedのk分割は
//k-1(調査済)と1を足すと考える
for k in 2...kN {
    var newDp = [Int](repeating: Int.max, count: 1 << n)
    for selected in 1..<(1 << n) {
        if selected.nonzeroBitCount < k {
            continue
        }
        var selected2 = selected
        while true {
            selected2 = (selected2 - 1) & selected
            if selected2 == 0 {
                break
            }
            if selected2.nonzeroBitCount < k - 1 {
                continue
            }
            newDp[selected] = min(newDp[selected], max(dp[selected2], cost[selected - selected2]))
        }
    }
    dp = newDp
}

print(dp[(1 << n) - 1])

