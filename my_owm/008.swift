func readInt() -> Int {
	Int(readLine()!)!
}

let ten_nine_seven = 1000000000 + 7

/*
//atcoder方式
let count = readInt()
let s = Array(readLine()!)
*/

//E869120方式
let s = Array(readLine()!)
let count = s.count

var aSum = 0
var tSum = 0
var cSum = 0
var oSum = 0
var dSum = 0
var eSum = 0
var rSum = 0

for i in 0..<count {
	switch s[i] {
		case "a":
			aSum += 1
		case "t":
			tSum += aSum
			if tSum >= ten_nine_seven {
				tSum -= ten_nine_seven
			}
		case "c":
			cSum += tSum
			if cSum >= ten_nine_seven {
				cSum -= ten_nine_seven
			}
		case "o":
			oSum += cSum
			if oSum >= ten_nine_seven {
				oSum -= ten_nine_seven
			}
		case "d":
			dSum += oSum
			if dSum >= ten_nine_seven {
				dSum -= ten_nine_seven
			}
		case "e":
			eSum += dSum
			if eSum >= ten_nine_seven {
				eSum -= ten_nine_seven
			}
		case "r":
			rSum += eSum
			if rSum >= ten_nine_seven {
				rSum -= ten_nine_seven
			}
		default:
			break
	}
}
print(rSum)
