func readIntArray() -> [Int] {
	readLine()!.split(separator: " ").map { Int(String($0))! }
}

let lr = readIntArray()
let l = UInt(lr[0])
let r = UInt(lr[1])
let tenNineSeven: UInt = 1000000007

var keta: UInt = 1
var bottom: UInt = 1
var top: UInt = 10 * bottom - 1
var ans: UInt = 0

while true {
	
	//範囲が重なっているか
	if l <= top && bottom <= r {
		var rangeL = bottom
		var rangeR = top
		if bottom < l {
			rangeL = l
		}
		if r < top {
			rangeR = r
		}
		let sumLR = rangeL + rangeR
		let range = rangeR - rangeL + 1
		var nums: UInt = 0
		if range % 2 == 0 {
			nums = range / 2 % tenNineSeven * (sumLR % tenNineSeven)
		} else {
			nums = range % tenNineSeven * (sumLR / 2 % tenNineSeven)
		}
		nums %= tenNineSeven
		ans += nums * keta
		ans %= tenNineSeven
		if r <= top {
			break
		}
	}
	
	keta += 1
	bottom *= 10
	top = bottom * 10 - 1
	//19桁の時はtopがIntの範囲を超えるのでUIntを使っている
}

print(ans)
