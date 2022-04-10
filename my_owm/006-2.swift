func readInt() -> Int {
	Int(readLine()!)!
}

func readIntArray() -> [Int] {
	readLine()!.split(separator: " ").map { Int(String($0))! }
}

/*
//atcoder形式
let nk = readIntArray()
let n = nk[0]
let k = nk[1]
let s = Array(readLine()!)
 */

//E869120形式
let s = Array(readLine()!)
let n = s.count
let k = readInt()

var selected = Array(s[n - k...n - 1])
var compared = [Character](repeating: " ", count: k + 1)

var pos = n - k - 1
while pos >= 0 {
	var current = 0
	compared[0] = s[pos]
	
	while current < k {
		if compared[current] <= selected[current] {
			compared[current + 1] = selected[current]
			selected[current] = compared[current]
			current += 1
		} else {
			break
		}
	}
	pos -= 1
}

print(selected.map({ String($0) }).joined())
