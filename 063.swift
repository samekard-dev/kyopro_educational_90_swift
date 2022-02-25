func readIntArray() -> [Int] {
	readLine()!.split(separator: " ").map { Int(String($0))! }
}

let bitToNum = [1, 2, 4, 8, 16, 32, 64, 128, 256] //bitToNum[8]も使用する
var bitUse = [Int](repeating: 0, count: 256)
for i in 1...255 {
	var current = i
	var counter = 0
	while current > 0 {
		if current % 2 != 0 {
			counter += 1
		}
		current /= 2
	}
	bitUse[i] = counter
}

let hw = readIntArray()
let h = hw[0]
let w = hw[1]
var field: [[Int]] = []
var appearance: [Int : [Int : Int]] = [:] //例 : 52が135列にどのように出現したか。出現形式はビットで記録。

for _ in 1...h {
	field.append(readIntArray())
}

for i in 0..<h {
	for j in 0..<w {
		let value = field[i][j]
		if appearance[value] == nil {
			appearance[value] = [:]
		}
		if appearance[value]![j] == nil {
			appearance[value]![j] = 0
		}
		appearance[value]![j] = appearance[value]![j]! | bitToNum[i]
	}
}

var maxResult = 0
for appearanceValues in appearance.values {
	let certainNumberPlaces = Array(appearanceValues.values)
	for i in 1...bitToNum[h] - 1 {
		var sum = 0
		for p in certainNumberPlaces {
			if p & i == i {
				sum += bitUse[i]
			}
		}
		if sum > maxResult {
			maxResult = sum
		}
	}
}

print(maxResult)
