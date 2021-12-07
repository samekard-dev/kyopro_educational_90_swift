import Foundation

func readInt() -> Int {
	Int(readLine()!)!
}

func readIntArray() -> [Int] {
	readLine()!.split(separator: " ").map { Int(String($0))! }
}

let n = readInt()
var pos: [(x: Double, y: Double)] = []
for _ in 0..<n {
	let xy = readIntArray()
	pos.append((Double(xy[0]), Double(xy[1])))
}

var dir = [[Double]](repeating: [], count: n)
for i in 0...n - 2 {
	for j in i + 1...n - 1 {
		if pos[i].x == pos[j].x {
			if pos[i].y < pos[j].y {
				dir[i].append(Double.pi / 2.0)
				dir[j].append(Double.pi * 3.0 / 2.0)
			} else {
				dir[i].append(Double.pi * 3.0 / 2.0)
				dir[j].append(Double.pi / 2.0)
			}
		} else if pos[i].x < pos[j].x {
			let angle = atan((pos[j].y - pos[i].y) / (pos[j].x - pos[i].x))
			dir[i].append(angle >= 0.0 ? angle : angle + 2.0 * Double.pi)
			dir[j].append(angle + Double.pi)
		} else {
			let angle = atan((pos[i].y - pos[j].y) / (pos[i].x - pos[j].x))
			dir[j].append(angle >= 0.0 ? angle : angle + 2.0 * Double.pi)
			dir[i].append(angle + Double.pi)
		}
	}
}

var minValue = Double.infinity
for i in 0..<n {
	dir[i] = dir[i].sorted(by: <)
	var a = 0
	var b = 1
	while b < n - 1 {
		let value = dir[i][b] - dir[i][a] - Double.pi
		minValue = min(minValue, fabs(value))
		if value < 0.0 {
			b += 1
		} else {
			a += 1
		}
	}
}

print(180.0 - minValue * 180.0 / Double.pi)
