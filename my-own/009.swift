import Foundation

func readInt() -> Int {
    Int(readLine()!)!
}

func readInts() -> [Int] {
    readLine()!.split(separator: " ").map { Int(String($0))! }
}

let n = readInt()
var pos: [(x: Double, y: Double)] = []
for _ in 0..<n {
    let xy = readInts()
    pos.append((Double(xy[0]), Double(xy[1])))
}

var minValue = Double.infinity

for i in 0..<n {
    var dir: [Double] = []
    
    for j in 0..<n {
        if j == i {
            continue
        }
        if pos[i].x == pos[j].x {
            if pos[i].y < pos[j].y {
                dir.append(Double.pi / 2.0)
            } else {
                dir.append(Double.pi * 3.0 / 2.0)
            }
        } else {
            let angle = atan((pos[j].y - pos[i].y) / (pos[j].x - pos[i].x))
            if pos[j].x < pos[i].x {
                dir.append(angle + Double.pi)
            } else if pos[j].y < pos[i].y {
                dir.append(angle + 2.0 * Double.pi)
            } else {
                dir.append(angle)
            }
        }
    }
    
    dir.sort(by: <)
    
    var a = 0
    var b = 1
    while b < dir.count {
        let value = dir[b] - dir[a] - Double.pi
        minValue = min(minValue, fabs(value))
        if value < 0.0 {
            b += 1
        } else {
            a += 1
        }
    }
}

print(180.0 - minValue * 180.0 / Double.pi)
