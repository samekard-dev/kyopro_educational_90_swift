//頂点がN個で辺がN-1本、すべてがつながっているので内部に輪になる部分を持たない
//輪があると、残りの部分（N-a頂点、N-a-1の辺）をつなげて全てをひとつにすることが出来ない
//よって初めの段階で木構造である
func readInt() -> Int {
    Int(readLine()!)!
}

func readInts() -> [Int] {
    readLine()!.split(separator: " ").map { Int(String($0))! }
}

let n = readInt()
var roads = [[Int]](repeating: [], count: n)

for _ in 1...n - 1 {
    let pair = readInts()
    //1を引いて0開始にします
    roads[pair[0] - 1].append(pair[1] - 1)
    roads[pair[1] - 1].append(pair[0] - 1)
}

//木構造を作る
var added = [Bool](repeating: false, count: n)

//depthは自分の下(根が上とする)に何世代いるか
var tree: [(children: [Int], depth: Int)] = [([Int], Int)](repeating: ([], 0), count: n)

func makeTree(targetCity: Int) -> Int {
    var maxDepth = 0
    for city in roads[targetCity] {
        if added[city] == false {
            tree[targetCity].children.append(city)
            added[city] = true
            let depth = makeTree(targetCity: city) + 1
            maxDepth = max(maxDepth, depth)
        }
    }
    tree[targetCity].depth = maxDepth
    return maxDepth
}

added[0] = true
_ = makeTree(targetCity: 0)

//一番長い経路を探す
var longestWay = 0
for i in 0..<n {
    switch tree[i].children.count {
        case 0:
            break
        case 1:
            longestWay = max(longestWay, tree[i].depth)
        default:
            var first = 0
            var second = 0
            for c in tree[i].children {
                if tree[c].depth > first {
                    second = first
                    first = tree[c].depth
                } else if tree[c].depth > second {
                    second = tree[c].depth
                }
            }
            longestWay = max(longestWay, first + 1 + second + 1)
    }
}

print(longestWay + 1)
