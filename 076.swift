func readInt() -> Int {
	Int(readLine()!)!
}

func readIntArray() -> [Int] {
	readLine()!.split(separator: " ").map { Int(String($0))! }
}

let n = readInt()
let a = readIntArray()

let aSum = a.reduce(0, +)
if aSum % 10 != 0 {
	print("No")
} else {
	let target = aSum / 10
	var start = 0
	var end = 0
	var current = a[0]
	
	while true {
		if current == target {
			print("Yes")
			break
		} else if current < target {
			end += 1
			if end == n {
				end = 0
			}
			current += a[end]
		} else {
			if start == n - 1 {
				print("No")
				break
			}
			if start == end {
				start += 1
				end = start
				current = a[start]
			} else {
				current -= a[start]
				start += 1
			}
		}
	}
}
