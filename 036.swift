func readInt() -> Int {
    Int(readLine()!)!
}

func readInts() -> [Int] {
    readLine()!.split(separator: " ").map { Int(String($0))! }
}

let nq = readInts()
let n = nq[0]
let qN = nq[1]

var pos: [(x: Int, y: Int)] = []
for _ in 0..<n {
    let xy = readInts()
    pos.append((x: xy[0], y: xy[1]))
}

var minX = Int.max
var maxX = Int.min
var minY = Int.max
var maxY = Int.min

for i in 0..<n {
    let newX = pos[i].x + pos[i].y //元の右上が正
    let newY = pos[i].y - pos[i].x //元の左上が正
    pos[i].x = newX
    pos[i].y = newY
    minX = min(minX, newX)
    maxX = max(maxX, newX)
    minY = min(minY, newY)
    maxY = max(maxY, newY)
}

for _ in 0..<qN {
    let q = readInt() - 1
    
    print(
        max(
            pos[q].x - minX,
            maxX - pos[q].x,
            pos[q].y - minY,
            maxY - pos[q].y
        )
    )
}
