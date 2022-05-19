/*
 答 = すべて - (Aのどれかと論理積が0)
 */

/*
 やりかた
 
 「A1と論理積が0」を足す
 「A2と論理積が0」を足す
 「A3と論理積が0」を足す
 :
 :
 :
 
 足しすぎたのを引く
 「A1とA2の両方と論理積が0」を引く
 「A2とA3の両方と論理積が0」を引く
 :
 :
 
 引きすぎたのを足す
 :
 足しすぎたのを引く
 :
 :
 :
 
 */

import Foundation

func readIntArray() -> [Int] {
	readLine()!.split(separator: " ").map { Int(String($0))! }
}

let nd = readIntArray()
let n = nd[0]
let d = nd[1]
let a = readIntArray()
let aCombination = Int(pow(2.0, Double(n)))

var counter = [Int](repeating: 0, count: n + 1)
//counter[i] : aの組み合わせの要素数がi個のデータ

func check(combi: Int) -> (aCount: Int, num: Int) {
	var combi = combi
	var aCount = 0
	var union = 0 //和
	var i = 0
	while combi != 0 {
		if combi & 1 == 1 {
			aCount += 1
			union |= a[i]
		}
		combi = combi>>1
		i += 1
	}
	var on = 0
	while union != 0 {
		if union & 1 == 1 {
			on += 1
		}
		union = union>>1
	}
	
	let off = d - on
	let num = Int(pow(2.0, Double(off)))
	return (aCount, num)
}

for i in 1..<aCombination {
	let (aCount, num) = check(combi: i)
	counter[aCount] += num
}

var dir = 1
var sum = 0
for i in 1...n {
	sum += dir * counter[i]
	dir *= -1
}

print(Int(pow(2.0, Double(d))) - sum)
