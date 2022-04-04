func readIntArray() -> [Int] {
	readLine()!.split(separator: " ").map { Int(String($0))! }
}

let ns = readIntArray()
let n = ns[0]
let s = ns[1]
var aGTb = [Bool](repeating: false, count: n)
var diff = [(index: Int, value: Int)](repeating: (0, 0), count: n)
var target = s

for i in 0..<n {
	let ab = readIntArray()
	aGTb[i] = ab[0] > ab[1]
	diff[i] = (i, max(ab[0], ab[1]) - min(ab[0], ab[1]))
	target -= min(ab[0], ab[1])
}
diff = diff.sorted(by: { $0.value > $1.value } )

var allHigher = [Int](repeating: 0, count: n)
//allHigher[i] : i以降(i含む)全部高い方を選んだらどれだけになるか
for i in 0..<n {
	for j in 0...i {
		allHigher[j] += diff[i].value
	}
}

var printed = false
var history = [Bool](repeating: false, count: n)
func seek(index: Int, current: Int) {
	guard printed == false else {
		return
	}
	if current > target {
		return
	}
	if current + allHigher[index] < target {
		return
	}
	if index == n - 1 {
		if current == target {
			printHistory()
		} else if current + diff[index].value == target {
			history[index] = true
			printHistory()
			history[index] = false
		}
	} else {
		//lower
		seek(index: index + 1, current: current)
		
		//higher
		history[index] = true
		seek(index: index + 1, current: current + diff[index].value)
		history[index] = false
	}
}

func printHistory() {
	var result = [Bool](repeating: false, count: n)
	for i in 0..<n {
		result[diff[i].index] = history[i]
	}
	for i in 0..<n {
		if result[i] == aGTb[i] {
			print("A", terminator: "")
		} else {
			print("B", terminator: "")
		}
		//a[i] = b[i]のときはAでもBでも正解となるはず...
	}
	print()
	printed = true
}

seek(index: 0, current: 0)

if printed == false {
	print("Impossible")
}
