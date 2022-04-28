/*
 AC後の考察
 時間の流れを反対にして考えてしまったが、
 そのままの流れでも締め切りの早い順に考えればよい
 時間が逆なこと以外は模範解答と同じ
 */

/*
 時間を逆にして考える。
 仕事に取り掛かれる日にちが指定されているとする
 すべての仕事の締め切りは最終日になる。
 */

func readInt() -> Int {
	Int(readLine()!)!
}

func readIntArray() -> [Int] {
	readLine()!.split(separator: " ").map { Int(String($0))! }
}

let days = 5000

let n = readInt()
var w: [(start: Int, days: Int, money: Int)] = [(start: 0, days: 0, money: 0)]
//dpの関係でダミーを一つ作る

for _ in 1...n {
	let input = readIntArray()
	w.append((start: days - input[0], days: input[1], money: input[2]))
	//daysは0から4999
}
w = w.sorted(by: { $0.start < $1.start })

//dpは日の境目という認識で
var dp = [[Int]](repeating: [Int](repeating: 0, count: days + 1), count: n + 1)
for i in 1...n {
	for j in 0...days {
		dp[i][j] = max(dp[i][j], dp[i - 1][j])
		if j >= w[i].start && j + w[i].days <= days {
			dp[i][j + w[i].days] = max(dp[i][j + w[i].days], dp[i - 1][j] + w[i].money)
		}
	}
}

print(dp[n][days])
