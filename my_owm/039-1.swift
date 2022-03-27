//TLEになります

func readInt() -> Int {
	Int(readLine()!)!
}

func readIntArray() -> [Int] {
	readLine()!.split(separator: " ").map { Int(String($0))! }
}

struct Node {
	var p: Int //parent
	var c: Set<Int> //children
	var e: Int //これ以下の木の頂点数（自身含む）
	var l: Int //これ以下に辺か数えるべき辺がいくつあるか A-B-Cなら4本
	var checked: Bool //調べたか
}

let n = readInt()

//connect
var con = [Node](repeating: Node(p: -1, c: [], e: 1, l: 0, checked: false), count: n)

for _ in 1...n - 1 {
	let ab = readIntArray()
	con[ab[0] - 1].c.insert(ab[1] - 1)
	con[ab[1] - 1].c.insert(ab[0] - 1)
}

var order: [Int] = [0]
var index = 0
while index < order.count {
	let target = order[index]
	for c in con[target].c {
		con[c].p = target
		con[c].c.remove(target)
		order.append(c)
	}
	index += 1
}

var ans = 0

for index in (1..<order.count).reversed() {
	let checking = order[index]
	if con[checking].checked  {
		continue
	}
	let p = con[checking].p
	let pc = Array(con[p].c)
	if pc.count >= 2 {
		//子同士の経路を計算
		for i in 0...pc.count - 2 {
			for j in i + 1...pc.count - 1 {
				ans += (con[pc[i]].l + con[pc[i]].e) * con[pc[j]].e 
				+ (con[pc[j]].l + con[pc[j]].e) * con[pc[i]].e
			}
		}
	}
	for c in pc {
		ans += con[c].l + con[c].e //親から子への経路を計算
		con[p].e += con[c].e
		con[p].l += con[c].l + con[c].e
		con[c].checked = true
	}
}

print(ans)
