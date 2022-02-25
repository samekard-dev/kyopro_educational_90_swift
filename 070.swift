func readInt() -> Int {
	Int(readLine()!)!
}

func readIntArray() -> [Int] {
	readLine()!.split(separator: " ").map { Int(String($0))! }
}

let n = readInt()
var xData: [Int] = []
var yData: [Int] = []
for _ in 1...n {
	let pos = readIntArray()
	xData.append(pos[0])
	yData.append(pos[1])
}

xData = xData.sorted(by: <)
yData = yData.sorted(by: <)
let xAve = xData[n / 2] //偶数なら中央左右のどちらかでいい
let yAve = yData[n / 2]
var inconv = 0
for x in xData {
	inconv += abs(x - xAve)
}
for y in yData {
	inconv += abs(y - yAve)
}

print(Int(inconv))
