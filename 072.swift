func readInts() -> [Int] {
    readLine()!.split(separator: " ").map { Int(String($0))! }
}

let hw = readInts()
let h = hw[0]
let w = hw[1]

var geo: [[Character]] = []
for _ in 1...h {
    geo.append(Array(readLine()!))
}

var passed = [[Bool]](repeating: [Bool](repeating: false, count: w), count: h)

var originX = 0
var originY = 0

var counter = -1

for y in 0..<h {
    for x in 0..<w {
        if geo[y][x] == "#" {
            continue
        }
        originX = x
        originY = y
        seeFrom(x: x, y: y, times: 0)
    }
}

func seeFrom(x: Int, y: Int, times: Int) {
    for (dX, dY) in [(1, 0), (-1, 0), (0, 1), (0, -1)] {
        let nextX = x + dX
        let nextY = y + dY
        if nextX >= 0 && nextX <= w - 1
            && nextY >= 0 && nextY <= h - 1
            && geo[nextY][nextX] == "."
            && passed[nextY][nextX] == false {
            walkTo(x: nextX, y: nextY, times: times + 1)
        }
    }
}

func walkTo(x: Int, y: Int, times: Int) {
    if x == originX && y == originY {
        if times >= 3 {
            if times > counter {
                counter = times
            }
        }
        return
    }
    
    passed[y][x] = true
    seeFrom(x: x, y: y, times: times)
    passed[y][x] = false
}

print(counter)
