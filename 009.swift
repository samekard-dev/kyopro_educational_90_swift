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

func solve(b: Int) -> Double {
    
    var angles: [Double] = []
    
    for i in 0..<n {
        if i == b {
            continue
        }
        let dX = pos[i].x - pos[b].x
        let dY = pos[i].y - pos[b].y
        
        if dX == 0.0 {
            angles.append(dY > 0.0 ? .pi / 2.0 : .pi * 3.0 / 2.0)
        } else {
            let a = atan(dY / dX)
            if dX < 0.0 {
                angles.append(a + .pi)
            } else if dY < 0.0 {
                angles.append(a + 2.0 * .pi)
            } else {
                angles.append(a)
            }
        }
    }
    angles.sort(by: <)
    
    var retMin = Double.pi
    
    for a in angles {
        let target = a < .pi ? a + .pi : a - .pi
        
        let bottom = 0
        let top = angles.count - 1
        var left = bottom - 1 //この値は調べることはない
        var right = top + 1 //この値は調べることはない
        while right - left > 1 {  //最後は隣り合った2つになって抜ける
            let mid = left + (right - left) / 2
            if angles[mid] <= target {
                left = mid
            } else {
                right = mid
            }
        }
        
        let candidate1: Double
        let candidate2: Double
        if left == bottom - 1 {
            candidate1 = target - (angles.last! - 2.0 * .pi)
        } else {
            candidate1 = target - angles[left]
        }
        if right == top + 1 {
            candidate2 = (angles[0] + 2.0 * .pi) - target
        } else {
            candidate2 = angles[right] - target
        }
        retMin = min(retMin, candidate1, candidate2)
    }
    
    return .pi - retMin
}

var ans = 0.0

//点Bを選んで残りから最大角度を出す
for b in 0..<n {
    ans = max(ans, solve(b: b))
}

print(ans / (2.0 * .pi) * 360.0)
