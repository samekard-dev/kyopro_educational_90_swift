func readIntArray() -> [Int] {
	readLine()!.split(separator: " ").map { Int(String($0))! }
}

/* 
//atcorder形式
let nk = readIntArray()
let n = nk[0]
let k = nk[1]
let s = Array(readLine()!)
 */

//E869120形式
let s = Array(readLine()!)
let n = s.count
let k = readIntArray()[0]

var selected = [Bool](repeating: false, count: n)
for i in n - k...n - 1 {
	selected[i] = true
}
var addCharIndex = n - k - 1
while addCharIndex >= 0 {
	var i = addCharIndex
	var j = addCharIndex + 1
	selected[i] = true
	var counter = 0
	while true {
		while selected[j] == false {
			j += 1
		}
		counter += 1
		if s[i].asciiValue! > s[j].asciiValue! {
			selected[i] = false
			break
		}
		if counter < k {
			i = j
			j += 1
		} else {
			selected[j] = false
			break
		}
	}
	addCharIndex -= 1
}
for i in 0..<n {
	if selected[i] {
		print(s[i], terminator: "")
	}
}
print()
