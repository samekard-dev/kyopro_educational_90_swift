func readInt() -> Int {
	Int(readLine()!)!
}
 
func readIntArray() -> [Int] {
	readLine()!.split(separator: " ").map { Int(String($0))! }
}
 
let n = readInt()
let abc = readIntArray().sorted(by: >)
let a = abc[0]
let b = abc[1]
let c = abc[2]
 
if n % a == 0 {
	print(n / a) 
} else {
 	var minCoins = Int.max
	for currentA in (0...n / a) {
		let remain1 = n - currentA * a
		if remain1 % b == 0 {
			minCoins = min(minCoins, currentA + remain1 / b)
		} else {
			for currentB in (0...remain1 / b) {
				let remain2 = remain1 - currentB * b
				if remain2 % c == 0 {
					minCoins = min(minCoins, currentA + currentB + remain2 / c)
				}
			}
		}
	}
 	print(minCoins)
}
