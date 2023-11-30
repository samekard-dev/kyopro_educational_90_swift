//35
func readInt() -> Int {
    Int(readLine()!)!
}

func readIntArray() -> [Int] {
    readLine()!.split(separator: " ").map { Int(String($0))! }
}

let topNode = 1

let n = readInt()

//conn:connection p:parent c:childen
var conn = [(p: Int, c: Set<Int>)](repeating: (-1, []), count: n + 1)
for _ in 1..<n {
    let ab = readIntArray()
    conn[ab[0]].c.insert(ab[1])
    conn[ab[1]].c.insert(ab[0])
}

func setParent(p: Int) {
    for c in conn[p].c {
        conn[c].p = p
        conn[c].c.remove(p)
        setParent(p: c)
    }
}

setParent(p: topNode)

var stages: [[Int]] = [[topNode]]

var stage = 0
while true {
    stages.append([])
    for n in stages[stage] {
        for c in conn[n].c {
            stages[stage + 1].append(c)
        }
    }
    if stages[stage + 1].isEmpty {
        stages.removeLast()
        break
    } else {
        stage += 1
    }
}

let q = readInt()

for _ in 1...q {
    let kv = readIntArray()
    var unfound: Set<Int> = Set(kv[1...]) //減っていきます
    var totalSet: Set<Int> = Set(kv[1...]) //増えていきます
    var answer = 0
    for s in (0...stage).reversed() {
        var foundNodes: Set<Int> = []
        for n in stages[s] {
            if totalSet.contains(n) {
                foundNodes.insert(n)
                if unfound.contains(n) {
                    unfound.remove(n)
                }
            }
        }
        if unfound.isEmpty && foundNodes.count == 1 {
            break
        }
        answer += foundNodes.count
        for n in foundNodes {
            totalSet.insert(conn[n].p)
        }
    }
    print(answer)
}
