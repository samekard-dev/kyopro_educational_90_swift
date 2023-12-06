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

//dp[k][selected]
//selectedをk分割した中での最低コスト
var dp = [[Int]](repeating: [Int](repeating: Int.max, count: 1 << n), count: kN + 1)
for i in 0..<(1 << n) {
    dp[1][i] = cost[i]
}

//あるselectedのk分割は
//1とk-1(調査済)を足すと考える
//oneGは全部でひとつのグループ
//selected - oneGはk - 1個のグループ
for k in 2...kN {
    for selected in 1..<(1 << n) {
        if selected.nonzeroBitCount < k {
            continue
        }
        var oneG = (selected - 1) & selected
        while oneG != 0 {
            dp[k][selected] = min(dp[k][selected], max(dp[k - 1][selected - oneG], cost[oneG]))
            oneG = (oneG - 1) & selected
        }
    }
}

print(dp[kN][(1 << n) - 1])

