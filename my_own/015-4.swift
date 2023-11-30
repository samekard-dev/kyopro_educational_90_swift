//TLE（処理時間オーバー）になります。
//10,000あたりが限界（求められているのは100,000）

let tenNineSeven = 1000000007

func readInt() -> Int {
	Int(readLine()!)!
}

let n = readInt()

var dp = [[Int]](repeating: [Int](repeating: 1, count: 2), count: n + 1)
var counter = 0

for k in 1...n {
	dp[k][0] = 1
	dp[k][1] = k
	for i in k + 1..<n + 1 {
		dp[i][0] = (dp[i - k][0] + dp[i - k][1]) % tenNineSeven
		dp[i][1] = (dp[i - 1][0] + dp[i - 1][1]) % tenNineSeven
	}
	print((dp[n][0] + dp[n][1] - 1) % tenNineSeven)
}
