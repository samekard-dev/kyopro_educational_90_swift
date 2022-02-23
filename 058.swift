func readIntArray() -> [Int] {
	readLine()!.split(separator: " ").map { Int(String($0))! }
}

let tenFive = 100000

let nk = readIntArray()
let n = nk[0]
let k = nk[1]

var current = n
var counter = 0
var lastAppear = [Int](repeating: -1, count: tenFive)
lastAppear[current] = 0

func process() {
	var temp = current
	var subtle = 0
	while temp != 0 {
		subtle += temp % 10
		temp /= 10
	}
	current = (current + subtle) % 100000
}

var jumped = false
while true {
	process()
	counter += 1
	if counter == k {
		break
	}
	if jumped == false {
		if lastAppear[current] == -1 {
			lastAppear[current] = counter
		} else {
			let jumpBase = counter - lastAppear[current]
			let restTimes = k - counter
			let jumpTimes = restTimes / jumpBase //結果は整数
			counter += jumpBase * jumpTimes
			jumped = true
			if counter == k {
				break
			}
		}
	}
}
print(current)
