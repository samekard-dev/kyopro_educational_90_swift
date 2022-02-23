func readIntArray() -> [Int] {
	readLine()!.split(separator: " ").map { Int(String($0))! }
}

let nk = readIntArray()
let n = nk[0]
let k = nk[1]
let a = readIntArray()
var times: [Int : Int] = [:]
var s = 0
var e = 0
var kinds = 1
var longest = 1
times[a[e]] = 1

while true {
	if kinds > k {
		times[a[s]] = times[a[s]]! - 1
		if times[a[s]] == 0 {
			kinds -= 1
		}
		s += 1
	} else {
		if e - s + 1 > longest {
			longest = e - s + 1
		}
		e += 1
		if e == n {
			break
		} else {
			if times[a[e]] == nil {
				times[a[e]] = 0
			}
			if times[a[e]] == 0 {
				kinds += 1
			}
			times[a[e]] = times[a[e]]! + 1
		}
	}
}
print(longest)
