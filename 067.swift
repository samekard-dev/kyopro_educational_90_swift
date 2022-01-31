import Foundation

let nk = readLine()!.split(separator: " ")
let nStr = nk[0]
let k = Int(nk[1])!

//与えられた文字列を8進数で解釈する
var value = 0
for c in nStr {
	value *= 8
	let number = Int(String(c))!
	value += number
}

//操作
for _ in 1...k {
	value = to9andChange8to5(value: value)
}

//8進数で出力
var printON = false
for i in (0...19).reversed() {
	//let dividing = Int(pow(Double(8), Double(i)))
	var dividing = 1
	for _ in 0..<i {
		dividing *= 8
	}
	if value / dividing > 0 {
		printON = true
	}
	if printON {
		print(value / dividing, terminator: "")
	}
	value %= dividing
}
if printON {
	print("")
} else {
	print("0") //与えられた数が0のとき
}

func to9andChange8to5(value: Int) -> Int {
	var current = value
	var returnValue = 0
	var multipleValue = 1
	while current > 0 {
		var remainder = current % 9
		if remainder == 8 {
			remainder = 5
		}
		returnValue += remainder * multipleValue
		multipleValue *= 8
		current /= 9
	}
	return returnValue
}
