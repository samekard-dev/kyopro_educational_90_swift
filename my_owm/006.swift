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
let k = readIntArray()[0]

var selected = [Int](repeating: 0, count: k)
for i in 0..<k {
	selected[i] = n - k + i
}
var addCharIndex = n - k - 1
while addCharIndex >= 0 {
	
	var current = 0
	var comparedIndex = addCharIndex
	
	while current < k {
		if s[comparedIndex] <= s[selected[current]] {
			let temp = selected[current]
			selected[current] = comparedIndex
			comparedIndex = temp
			current += 1
		} else {
			break
		}
	}
	
	addCharIndex -= 1
}
for i in 0..<k {
	print(s[selected[i]], terminator: "")
}
print()
