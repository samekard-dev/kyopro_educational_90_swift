//nが3桁程度ならAC
func readInts() -> [Int] {
    readLine()!.split(separator: " ").map { Int(String($0))! }
}
let mod = 998244353
let nk = readInts()
let n = nk[0]
let k = nk[1]
var dp = [[[Int]]](repeating:[[Int]](repeating: [Int](repeating: 0, count: n + 1), count: n + 1), count: k + 1)
for i in 0...n {
    dp[k][i][i] = 1
}
for i in 0..<n {
    dp[k][i][i + 1] = 1
}
for kk in stride(from: k - 1, through: 0, by: -1) {
    for i in 0...n {
        dp[kk][i][i] = 1
    }
    for i in 0..<n {
    loopJ:
        for j in i + 1...n {
            if kk * (j - i) > k {
                break loopJ
            }
            dp[kk][i][j] = dp[kk + 1][i][j]
            for l in i..<j {
                let temp = dp[kk][i][j] + dp[kk][i][l] * dp[kk + 1][l + 1][j]
                dp[kk][i][j] = temp % mod
            }
        }
    }
}
print(dp[0][0][n])
