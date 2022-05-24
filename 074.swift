import Foundation

func readInt() -> Int {
	Int(readLine()!)!
}

let n = readInt()
var s = Array(readLine()!)
var counter = 0
for i in 0..<n {
	switch s[i] {
		case "a":
			break
		case "b":
			//「自分」と「左側すべて」にわけました
			//1行にまとめる方法もあります
			counter += 1
			counter += Int(pow(2.0, Double(i))) - 1
		case "c":
			counter += 2
			counter += 2 * (Int(pow(2.0, Double(i))) - 1)
		default:
			break
	}
}

print(counter)
