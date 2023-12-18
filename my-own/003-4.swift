func readInt() -> Int {
    Int(readLine()!)!
}

func readInts() -> [Int] {
    readLine()!.split(separator: " ").map { Int(String($0))! }
}

let n = readInt()

var conn = [Set<Int>](repeating: [], count: n)

for _ in 1...n - 1 {
    let e = readInts()
    conn[e[0] - 1].insert(e[1] - 1)
    conn[e[1] - 1].insert(e[0] - 1)
}

var leaves: [Int] = []
for i in 0..<n {
    if conn[i].count == 1 {
        leaves.append(i)
    }
}

var remain = n
var current = 0

while true {
    if remain == 1 {
        print(current + 1)
        break
    } else if remain == 2 {
        print(current + 2)
        break
    } else {
        var nextLeaves: [Int] = []
        for i in leaves {
            let p = conn[i].first!
            conn[p].remove(i)
            conn[i].removeAll()
            if conn[p].count == 1 {
                nextLeaves.append(p)
            }
            remain -= 1
        }
        leaves = nextLeaves
    }
    current += 2
}

