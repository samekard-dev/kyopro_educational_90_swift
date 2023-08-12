//O(n^2)
//n=1000くらいまでは有効なやりかた

func readInt() -> Int {
	Int(readLine()!)!
}

let tenNineSeven = 1000000007

let n = readInt()

if n == 1 {
	print(1)
} else {
	var dp = [[Int]](repeating: [Int](repeating: 0, count: n + 1), count: n + 1)
	//dp[a][b] ボールb個で差がa以上のときの選び方
	
	for k in 1...n {
		dp[k][1] = 1
	}
	
	for k in 1...n {
		for b in 2...n {
			//dp[k][b]を求める
			//b-1個までの情報は入っている
			
			var sum = 0
			
			//b個目を選択しない
			sum += dp[k][b - 1]
			
			//b個目をはじめのボールとして選択する
			sum += 1
			
			//b個目を2個目以降として選択する
			if b - k >= 1 {
				sum += dp[k][b - k]
			}
			
			dp[k][b] = sum % tenNineSeven
		}
		print(dp[k][n])
	}
}
