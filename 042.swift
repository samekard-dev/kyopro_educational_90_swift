func readInt() -> Int {
	Int(readLine()!)!
}

let limit = 100000
let tenNineSeven = 1000000007

let k = readInt()

if k % 9 != 0 {
	print(0)
} else {
	var dp = [Int](repeating: 0, count: limit + 1)
	dp[1] = 1
	dp[2] = 2
	dp[3] = 4
	dp[4] = 8
	dp[5] = 16
	dp[6] = 32
	dp[7] = 64
	dp[8] = 128
	dp[9] = 256
	if k >= 10 {
		for i in 10...k {
			var sum = 0
			for j in i - 9...i - 1 {
				sum += dp[j]
			}
			dp[i] = sum % tenNineSeven
		}
	}
	print(dp[k])
}
