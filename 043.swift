class Cell {
    let x: Int
    let y: Int
    let dir: Int
    var pre: Cell?
    var next: Cell?
    
    init(x: Int, y: Int, dir: Int) {
        self.x = x
        self.y = y
        self.dir = dir
    }
}

class Deque {
    var first: Cell?
    var last: Cell?
    var count = 0
    
    func popFirst() -> Cell? {
        if count == 0 {
            return nil
        } else {
            let ret = first
            if count == 1 {
                first = nil
                last = nil
            } else {
                first = first!.next
                first!.pre = nil
                ret!.next = nil
            }
            count -= 1
            return ret
        }
    }
    
    func popLast() -> Cell? {
        if count == 0 {
            return nil
        } else {
            let ret = last
            if count == 1 {
                first = nil
                last = nil
            } else {
                last = last!.pre
                last!.next = nil
                ret!.pre = nil
            }
            count -= 1
            return ret
        }
    }
    
    func pushFirst(c: Cell) {
        if count == 0 {
            first = c
            last = c
        } else {
            c.next = first
            first!.pre = c
            first = c
        }
        count += 1
    }
    
    func pushLast(c: Cell) {
        if count == 0 {
            first = c
            last = c
        } else {
            c.pre = last
            last!.next = c
            last = c            
        }
        count += 1
    }
}

func readInts() -> [Int] {
    readLine()!.split(separator: " ").map { Int(String($0))! }
}

let hw = readInts()
let h = hw[0]
let w = hw[1]

/*
 縦がX軸
 横がY軸
 */

let start = readInts()
let startX = start[0] - 1
let startY = start[1] - 1
let terminator = readInts()
let termiX = terminator[0] - 1
let termiY = terminator[1] - 1

var area: [[Bool]] = []
for _ in 1...h {
    area.append(Array(readLine()!).map { $0 == "." })
}

//ある場所に、ある方向へ進行中に到達したとき、それまでに曲がった回数はいくつか
var dist = [[[Int]]](repeating: [[Int]](repeating: [Int](repeating: Int.max, count: 4), count: w), count: h)

let deq = Deque()

for i in 0..<4 {
    dist[startX][startY][i] = 0
    deq.pushLast(c: Cell(x: startX, y: startY, dir: i))
}

let dx = [1, 0, -1, 0]
let dy = [0, 1, 0, -1]
while let u = deq.popFirst() {
    for i in 0..<4 {
        let tx = u.x + dx[i]
        let ty = u.y + dy[i]
        if 0 <= tx, tx < h, 0 <= ty, ty < w, area[tx][ty] {
            if u.dir == i {
                //同一方向
                let cost = dist[u.x][u.y][u.dir]
                if cost < dist[tx][ty][i] {
                    dist[tx][ty][i] = cost
                    //注:Firstへpush
                    deq.pushFirst(c: Cell(x: tx, y: ty, dir: i))
                }
            } else {
                //別方向
                let cost = dist[u.x][u.y][u.dir] + 1
                if cost < dist[tx][ty][i] {
                    dist[tx][ty][i] = cost
                    deq.pushLast(c: Cell(x: tx, y: ty, dir: i))
                }
            }
        }
    }
}

var answer = Int.max
for i in 0..<4 {
    answer = min(answer, dist[termiX][termiY][i])
}
print(answer)

