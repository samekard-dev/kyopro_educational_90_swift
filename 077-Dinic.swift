import Foundation

func readInts() -> [Int] {
    readLine()!.split(separator: " ").map { Int(String($0))! }
}

struct Edge {
    let to: Int
    let all: Int
    var cap: Int
    var rev: Int
}

struct Dinic {
    //classにしたらTime Limited Error
    //structでOK
    let size: Int
    var conn: [[Edge]]
    var level: [Int]
    var inter: [Int]
    var q: [Int]

    init(size: Int) {
        self.size = size
        self.conn = [[Edge]](repeating: [], count: size * 2 + 2)
        self.level = [Int](repeating: -1, count: size * 2 + 2)
        self.inter = [Int](repeating: -1, count: size * 2 + 2)
        self.q = [Int](repeating: -1, count: size * 2 + 2)
    }
    
    mutating func addEdge(u: Int, v: Int, c: Int) {
        //revは相手にとって自分は何番目なのか
        conn[u].append(Edge(to: v, all: c, cap: c, rev: conn[v].count))
        conn[v].append(Edge(to: u, all: c, cap: 0, rev: conn[u].count - 1))
    }
    
    mutating func bfs(s: Int) {
        var current = 0
        var next = 0
        q[next] = s
        next += 1
        level[s] = 0
        while current < next {
            let v = q[current]
            current += 1
            for c in conn[v] {
                if c.cap == 0 || level[c.to] != -1 {
                    continue
                }
                q[next] = c.to
                next += 1
                level[c.to] = level[v] + 1
            }
        }
    }
    
    mutating func dfs(pos: Int, to: Int, f: Int) -> Int {
        if pos == to {
            return f
        }
        for i in inter[pos]..<conn[pos].count {
            inter[pos] += 1
            let c = conn[pos][i]
            if c.cap > 0 && level[pos] < level[c.to] {
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
        }
        return 0
    }
    
    mutating func maxFlow(s: Int, t: Int) -> Int {
        var ret = 0
        while true {
            for i in 0..<level.count {
                level[i] = -1
            }
            bfs(s: s)
            if level[t] == -1 {
                break
            }
            for i in 0..<inter.count {
                inter[i] = 0
            }
            while true {
                let f = dfs(pos: s, to: t, f: Int.max)
                if f == 0 {
                    break
                }
                ret += f                
            }
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

var d = Dinic(size: n)
var possibility = [[Int]](repeating: [Int](repeating: -1, count: 8), count: n)
for i in 0..<n {
    for j in 0..<8 {
        let tx = aPos[i].0 + dx[j] * t
        let ty = aPos[i].1 + dy[j] * t
        if let b = bMap[tx + ty * 1000000001] {
            possibility[i][j] = b
            d.addEdge(u: i, v: n + b, c: 1)
        }
    }
}

for i in 0..<n {
    d.addEdge(u: 2 * n, v: i, c: 1)
    d.addEdge(u: i + n, v: 2 * n + 1, c: 1)
}

let res = d.maxFlow(s: 2 * n, t: 2 * n + 1)

if res != n {
    print("No")
    exit(0)
}

var answer = [Int](repeating: -1, count: n)
for i in 0..<n {
    for c in d.conn[i] {
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
