func readIntArray() -> [Int] {
	readLine()!.split(separator: " ").map { Int(String($0))! }
}

let hw = readIntArray()
let h = hw[0]
let w = hw[1]

let start = readIntArray()
let startR = start[0] - 1
let startC = start[1] - 1
let terminator = readIntArray()
let termiR = terminator[0] - 1
let termiC = terminator[1] - 1

var area: [[Character]] = []
for _ in 1...h {
	area.append(Array(readLine()!))
}

struct NextData {
	var r: Int
	var c: Int
	var d: Int //0: both, 1: hr, 2: vr
	var t: Int //曲がった回数 = 書き込むデータ
}

var plan: [NextData] = []
plan.append(NextData(r: startR, c: startC, d: 0, t: 0))
var current = 0

var doneHr = [[Bool]](repeating: [Bool](repeating: false, count: w), count: h)
var doneVr = [[Bool]](repeating: [Bool](repeating: false, count: w), count: h)

var times = [[Int]](repeating: [Int](repeating: -1, count: w), count: h)
times[startR][startC] = 0

while true {
	let info = plan[current]
	if (info.d == 0 || info.d == 1) && doneVr[info.r][info.c] == false {
		//縦方向
		doneVr[info.r][info.c] = true
	verticalSearch:
		for d in [-1, 1] {
			var posY = info.r
			while true {
				posY += d
				if posY < 0 || posY > h - 1 || area[posY][info.c] == "#" {
					continue verticalSearch
				}
				if times[posY][info.c] == -1 {
					times[posY][info.c] = info.t
				}
				doneVr[posY][info.c] = true
				if doneHr[posY][info.c] {
					continue
				}
				if (info.c - 1 >= 0 && area[posY][info.c - 1] == ".") ||
					(info.c + 1 <= w - 1 && area[posY][info.c + 1] == ".") {
					plan.append(NextData(r: posY, c: info.c, d: 2, t: info.t + 1))
				}
			}
		}
	}
	if (info.d == 0 || info.d == 2) && doneHr[info.r][info.c] == false {
		//横方向
		doneHr[info.r][info.c] = true
	horizontalSearch:
		for d in [-1, 1] {
			var posX = info.c
			while true {
				posX += d
				if posX < 0 || posX > w - 1 || area[info.r][posX] == "#" {
					continue horizontalSearch
				}
				if times[info.r][posX] == -1 {
					times[info.r][posX] = info.t
				}
				doneHr[info.r][posX] = true
				if doneVr[info.r][posX] {
					continue
				}
				if (info.r - 1 >= 0 && area[info.r - 1][posX] == ".") ||
					(info.r + 1 <= h - 1 && area[info.r + 1][posX] == ".") {
					plan.append(NextData(r: info.r, c: posX, d: 1, t: info.t + 1))
				}
			}
		}
	}
	
	if times[termiR][termiC] != -1 {
		break
	}
	
	current += 1
}
print(times[termiR][termiC])
