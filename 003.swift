func readInt() -> Int {
	Int(readLine()!)!
}

func readIntArray() -> [Int] {
	readLine()!.split(separator: " ").map { Int(String($0))! }
}

let n = readInt()
var roads = [[Int]](repeating: [], count: n)

for _ in 1...n - 1 {
	let pair = readIntArray()
	//1を引いて0開始にします
	roads[pair[0] - 1].append(pair[1] - 1)
	roads[pair[1] - 1].append(pair[0] - 1)
}

//木構造を作る
var added = [Bool](repeating: false, count: n)
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
let depth = makeTree(targetCity: 0)
tree[0].depth = depth

//一番長い経路を探す
var longestWay = 0
for i in 0..<n {
	tree[i].children = tree[i].children.sorted{ tree[$0].depth > tree[$1].depth }
	switch tree[i].children.count {
		case 0:
			break
		case 1:
			longestWay = max(longestWay, tree[i].depth)
		default:
			longestWay = max(longestWay, 
							 tree[tree[i].children[0]].depth + 1 +
							 tree[tree[i].children[1]].depth + 1)
	}
}

print(longestWay + 1)
