import Foundation

func readInts() -> [Int] {
    readLine()!.split(separator: " ").map { Int(String($0))! }
}

struct Edge {
    let to: Int
    var all: Int
    var cap: Int
    var rev: Int
}

class FordFulkerson {
    
    let size: Int
    var conn: [[Edge]]
    var used: [Bool]
    
    init(size: Int) {
        self.size = size
        self.conn = [[Edge]](repeating: [], count: size * 2 + 2)
        self.used = [Bool](repeating: false, count: size * 2 + 2)
    }
    
    func addEdge(u: Int, v: Int, c: Int) {
        //revは相手にとって自分は何番目なのか
        conn[u].append(Edge(to: v, all: c, cap: c, rev: conn[v].count))
        conn[v].append(Edge(to: u, all: c, cap: 0, rev: conn[u].count - 1))
    }
    
    func dfs(pos: Int, to: Int, f: Int) -> Int {
        if pos == to {
            return f
        }
        used[pos] = true
        for (i, c) in conn[pos].enumerated() {
            if used[c.to] || c.cap == 0 {
                continue
            }
            let z = dfs(pos: c.to, to: to, f: min(f, c.cap))
            if z != 0 {
                conn[pos][i].cap = c.cap - z
                //Swiftの2次元配列の読み&書き遅い問題があるので
                //a[][] -= xxx
                //という書き方を避ける
                //そのためallを追加
                conn[c.to][c.rev].cap = c.all - (c.cap - z)
                return z
            }
        }
        return 0
    }
    
    func maxFlow(s: Int, t: Int) -> Int {
        var ret = 0
        while true {
            for i in 0..<used.count {
                used[i] = false
            }
            let f = dfs(pos: s, to: t, f: Int.max)
            if f == 0 {
                break
            }
            ret += f
        }
        return ret
    }
}

let dx = [1, 1, 0, -1, -1, -1, 0, 1]
let dy = [0, 1, 1, 1, 0, -1, -1, -1]

let nt = readInts()
let n = nt[0]
let t = nt[1]

var aPos: [(Int, Int)] = []
for _ in 0..<n {
    let input = readInts()
    aPos.append((input[0], input[1]))
}

var bPos: [(Int, Int)] = []
for _ in 0..<n {
    let input = readInts()
    bPos.append((input[0], input[1]))
}

var bMap: [Int : Int] = [:]
for (i, b) in bPos.enumerated() {
    bMap[b.0 + b.1 * 1000000001] = i
}

let ff = FordFulkerson(size: n)
var possibility = [[Int]](repeating: [Int](repeating: -1, count: 8), count: n)
for i in 0..<n {
    for j in 0..<8 {
        let tx = aPos[i].0 + dx[j] * t
        let ty = aPos[i].1 + dy[j] * t
        if let b = bMap[tx + ty * 1000000001] {
            possibility[i][j] = b
            ff.addEdge(u: i, v: n + b, c: 1)
        }
    }
}

for i in 0..<n {
    ff.addEdge(u: 2 * n, v: i, c: 1)
    ff.addEdge(u: i + n, v: 2 * n + 1, c: 1)
}

let res = ff.maxFlow(s: 2 * n, t: 2 * n + 1)

if res != n {
    print("No")
    exit(0)
}

var answer = [Int](repeating: -1, count: n)
for i in 0..<n {
    for c in ff.conn[i] {
        if c.to >= 2 * n || c.cap == 1 {
            continue
        }
        for j in 0..<8 {
            if possibility[i][j] != -1 && possibility[i][j] == c.to - n {
                answer[i] = j + 1
            }
        }
    }
}

print("Yes")
print(answer.map({ "\($0)" }).joined(separator: " "))
