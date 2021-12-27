//以下の解法はTLE(時間超え)でした

func readIntArray() -> [Int] {
	readLine()!.split(separator: " ").map { Int(String($0))! }
}

let nm = readIntArray()
let n = nm[0]
let m = nm[1]

var lines: [(l: Int, r: Int)] = []
for _ in 0..<m {
	let line = readIntArray()
	lines.append((line[0], line[1]))
}
lines = lines.sorted(by: { $0.r > $1.r }).sorted(by: { $0.l < $1.l })
//leftの昇順に並べるが、leftが同じ場合はrightの降順になるようにする
//これは、leftが同じ場合に前のlineが次のlineのじゃまにならないようにするためである

var sum = [Int](repeating: 0, count: n + 1)
var counter = 0

for line in lines {
	if line.r - line.l >= 2 {
		for mid in line.l + 1...line.r - 1 {
			counter += sum[mid]
		}
	}
	sum[line.r] += 1
}
print(counter)
