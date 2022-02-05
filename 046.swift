func readInt() -> Int {
	Int(readLine()!)!
}

func readIntArray() -> [Int] {
	readLine()!.split(separator: " ").map { Int(String($0))! }
}

let baseNumber = 46
let n = readInt()
let a = readIntArray().map { $0 % baseNumber }
let b = readIntArray().map { $0 % baseNumber }
let c = readIntArray().map { $0 % baseNumber }

var aData = [Int](repeating: 0, count: baseNumber)
var bData = [Int](repeating: 0, count: baseNumber)
var cData = [Int](repeating: 0, count: baseNumber)

for i in 0..<n {
	aData[a[i]] += 1
	bData[b[i]] += 1
	cData[c[i]] += 1
}

var counter = 0
for i in 0..<baseNumber {
	for j in 0..<baseNumber {
		counter += aData[i] * bData[j] * cData[(baseNumber * 2 - (i + j)) % baseNumber]
	}
}
print(counter)
