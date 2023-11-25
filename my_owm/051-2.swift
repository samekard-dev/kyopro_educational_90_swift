//基本的に全探索だが、結果が予測できるところは値を求めて瞬時にリターン

func readIntArray() -> [Int] {
	readLine()!.split(separator: " ").map { Int(String($0))! }
}

func combination(a: Int, b: Int) -> Int {
	var returnValue = 1
	for i in 0..<b {
		returnValue *= a - i
		returnValue /= i + 1
	}
	return returnValue
}

let nkp = readIntArray()
let n = nkp[0]
let k = nkp[1]
let p = nkp[2]
let a = readIntArray().sorted(by: >)

var series = [[Int]](repeating: [Int](repeating: 0, count: n + 1), count: n)
//series[i][j]はi番目から連続するj個の要素を足した値
for i in 0..<n {
	var current = 0
	for j in 1...n {
		current += a[i + j - 1]
		series[i][j] = current
		if i + j - 1 == n - 1 {
			//最後
			break
		}
	}
}

var ans = 0

func seek(l: Int, m: Int, border: Int) {
	if series[l][m] <= border {
		ans += combination(a: n - l, b: m)
		return
	} else if series[n - m][m] > border {
		return
	} else {
		if m == 1 {
			for i in l...n - 1 {
				if a[i] <= border {
					ans += n - i
					break
				}
			}
		} else {
			for i in l...n - m {
				seek(l: i + 1, m: m - 1, border: border - a[i])
			}
		}
	}
}

seek(l: 0, m: k, border: p)
print(ans)
