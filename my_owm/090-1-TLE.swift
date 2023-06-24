//nが3桁程度ならAC
func readInts() -> [Int] {
    readLine()!.split(separator: " ").map { Int(String($0))! }
}
let mod = 998244353
let nk = readInts()
let n = nk[0]
let k = nk[1]
var dp = [[Int]](repeating: [Int](repeating: 0, count: n + 1), count: k + 1)
for kk in 0...k {
    dp[kk][0] = 1
}
dp[k][1] = 1
for kk in stride(from: k - 1, through: 0, by: -1) {
    let limit = kk == 0 ? n : min(k / kk, n)
    for i in 1...limit {
        dp[kk][i] = dp[kk + 1][i]
        let others = i - 1
        for j in 0...others {
            var temp = dp[kk][i] + dp[kk][j] * dp[kk + 1][others - j]
            temp %= mod
            dp[kk][i] = temp
        }
    }
}
print(dp[0][n])
