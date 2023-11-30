func readInt() -> Int {
    Int(readLine()!)!
}

func readInts() -> [Int] {
    readLine()!.split(separator: " ").map { Int(String($0))! }
}

let n = readInt()
var edges = [Set<Int>](repeating: [], count: n)

for _ in 1...n - 1 {
    let pair = readInts()
    //1を引いて0開始にします
    edges[pair[0] - 1].insert(pair[1] - 1)
    edges[pair[1] - 1].insert(pair[0] - 1)
}

var depth: [Int] = [Int](repeating: 0, count: n)
var leaves: [Int] = []
var next = 0

for i in 0..<n {
    if edges[i].count == 1 {
        leaves.append(i)
    }
}

search:
while true {
    let target = leaves[next]
    let connect = edges[target].first!
    edges[connect].remove(target)
    switch edges[connect].count {
        case 0:
            print(depth[connect] + depth[target] + 2)
            break search
        case 1:
            depth[connect] = depth[target] + 1
            leaves.append(connect)
        default:
            break
    }
    next += 1
}
