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
			//iは最大59なので、pow計算した結果のDoubleの値が、
			//全てのIntを正確に現せる範囲を超えるが、
			//2の倍数なので正確さを維持する
			counter += Int(pow(2.0, Double(i))) - 1
		case "c":
			counter += 2
			counter += 2 * (Int(pow(2.0, Double(i))) - 1)
		default:
			break
	}
}

print(counter)
