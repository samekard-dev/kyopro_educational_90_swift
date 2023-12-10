func readInt() -> Int {
    Int(readLine()!)!
}

func readInts() -> [Int] {
    readLine()!.split(separator: " ").map { Int(String($0))! }
}

let n = readInt()
var edges = [[Int]](repeating: [], count: n)

for _ in 1...n - 1 {
    let pair = readInts()
    //1を引いて0開始にします
    edges[pair[0] - 1].append(pair[1] - 1)
    edges[pair[1] - 1].append(pair[0] - 1)
}

var depth: [Int] = []
var seen: [Bool] = []
var dMaxNode = -1
var dMax = -1

func prepare() {
    depth = [Int](repeating: -1, count: n)
    seen = [Bool](repeating: false, count: n)
    dMaxNode = -1
    dMax = -1
}

func dfs(_ node: Int, _ d: Int) {
    seen[node] = true
    depth[node] = d
    if d > dMax {
        dMax = d
        dMaxNode = node
    }
    for e in edges[node] {
        if seen[e] == false {
            dfs(e, d + 1)
        }
    }
}

prepare()
dfs(0, 0)
let next = dMaxNode
prepare()
dfs(next, 0)

print(dMax + 1)
