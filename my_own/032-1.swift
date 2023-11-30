func readInt() -> Int {
	Int(readLine()!)!
}

func readIntArray() -> [Int] {
	readLine()!.split(separator: " ").map { Int(String($0))! }
}

func factorial(of source: Int) -> Int {
	var result = 1
	for i in 1...source {
		result *= i
	}
	return result
}

func permutations<T>(of values: [T]) -> [[T]] {
	guard values.isEmpty == false else {
		return [[]]
	}
	var result = [[T]](repeating: [], count: factorial(of:values.count))
	result[0] = values
	var dataEnd = 0
	let last = values.count - 1
	
	func inPermutations(ref: Int, target: Int) {
		if target != last {
			inPermutations(ref: ref, target: target + 1)
			for i in target + 1...last {
				dataEnd += 1
				result[dataEnd] = result[ref]
				let temp = result[dataEnd][target]
				result[dataEnd][target] = result[dataEnd][i]
				result[dataEnd][i] = temp
				inPermutations(ref: dataEnd, target: target + 1)
			}
		}
	}
	
	inPermutations(ref: dataEnd, target: 0)
	
	return result
}

let n = readInt()
var a: [[Int]] = []
for _ in 0..<n {
	a.append(readIntArray())
}
let m = readInt()
var pass = [[Bool]](repeating: [Bool](repeating: true, count: n), count: n)
for _ in 0..<m {
	let xy = readIntArray()
	let x = xy[0] - 1
	let y = xy[1] - 1
	pass[x][y] = false
	pass[y][x] = false
}

var minTime = Int.max
let initArray = (0..<n).map{ $0 }
checkRelayLoop:
for relay in permutations(of: initArray) {
	var currentTime = 0
	var previousPerson = 0
	for (ku, person) in relay.enumerated() {
		if 1 <= ku {
			if pass[previousPerson][person] == false {
				continue checkRelayLoop
			}
		}
		currentTime += a[person][ku]
		previousPerson = person
	}
	if currentTime < minTime {
		minTime = currentTime
	}
}

if minTime == Int.max {
	print(-1)
} else {
	print(minTime)
}
