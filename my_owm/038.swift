import Foundation

func readIntArray() -> [Int] {
	readLine()!.split(separator: " ").map { Int(String($0))! }
}

let tenEighteen = 1000000000000000000
let ab = readIntArray()
let a = ab[0]
let b = ab[1]
let larger = max(a, b)
let smaller = min(a, b)

func getLCD(_ larger: Int, _ smaller: Int) -> Int {
	if larger % smaller == 0 {
		return smaller
	} else {
		return getLCD(smaller, larger % smaller)
	}
}

let lcd = getLCD(larger, smaller)

let log10L = log10(Double(larger))
let log10S = log10(Double(smaller))
let log10LCD = log10(Double(lcd))

if log10L + log10S - log10LCD > 18.1 {
	//極端に大きいもの
	print("Large")
} else {
	let answer = larger / lcd * smaller
	if answer > tenEighteen {
		print("Large")
	} else {
		print(answer)
	}
}
