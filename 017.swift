//この解き方の方針を調べるときのキーワードは「BIT」

func readInts() -> [Int] {
    readLine()!.split(separator: " ").map { Int(String($0))! }
}

class Bit {
    var elements = 0
    var indexOffset = 0
    var store: [Int]
    init(elements: Int, first: Int) {
        self.elements = elements
        self.indexOffset = 1 - first
        store = [Int](repeating: 0, count: elements + 1)
        //0-4 (elements 5) は 1-5 に変換されて配列の要素数は 6
        //1-4 (elements 4) は そのまま 1-4 なので配列の要素数は 5
    }
    
    func add(pos: Int, value: Int) {
        var pos2 = pos + indexOffset
        while pos2 <= elements {
            store[pos2] += value
            pos2 += pos2 & -pos2 //最終ビットを足す。例 1->2 6->8
        }
    }
    
    func sum(pos: Int) -> Int {
        var pos2 = pos + indexOffset
        var ans = 0
        while pos2 >= 1 {
            ans += store[pos2]
            pos2 -= pos2 & -pos2 //最終ビットを引く。例 5->4 10->8
        }
        return ans
    }
}

let nm = readInts()
let n = nm[0]
let m = nm[1]

var bit = Bit(elements: n, first: 1) //場所は1-indexなので

var lines = [[Int]](repeating: [], count: n + 1)
for _ in 1...m {
    let line = readInts()
    lines[line[0]].append(line[1])
}

var ans = 0

for l in 1...n {
    for r in lines[l] {
        ans += bit.sum(pos: r - 1) - bit.sum(pos: l)
    }
    for r in lines[l] {
        bit.add(pos: r, value: 1)
    }
}

print(ans)
