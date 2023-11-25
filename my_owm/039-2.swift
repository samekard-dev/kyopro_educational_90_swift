//かたつむりの目みたいに先端がひっこんで根元に情報があつまる
//最終的にひとつになる
func readInt() -> Int {
	Int(readLine()!)!
}

func readIntArray() -> [Int] {
	readLine()!.split(separator: " ").map { Int(String($0))! }
}

struct Node {
	var p: Int //parent
	var c: Set<Int> //children
	var e: Int //element 獲得したの頂点数（自身含む）
	var l: Int //length 獲得した数えるべき辺。A-B-Cがひとつになったなら4本
}

let n = readInt()

//connect
var con = [Node](repeating: Node(p: -1, c: [], e: 1, l: 0), count: n)

for _ in 1...n - 1 {
	let ab = readIntArray()
	con[ab[0] - 1].c.insert(ab[1] - 1)
	con[ab[1] - 1].c.insert(ab[0] - 1)
}

//親子関係を決定させる
//開始はどれでもいいので0を選択
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
order = order.reversed()
order.removeLast() //topは省く
var ans = 0

for c in order {
	let p = con[c].p
	ans += con[c].l * con[p].e
		+ con[p].l * con[c].e
		+ con[c].e * con[p].e
	/*
	 con[c].l  * con[p].e
	 子が獲得した本数を親の要素数が使用する
	 
	 con[p].l * con[c].e
	 親が獲得した本数を子の要素数が使用する
	 
	 con[c].e * con[p].e
	 親と子の間を利用する組み合わせ
	 */
	con[p].e += con[c].e
	con[p].l += con[c].l + con[c].e
}

print(ans)
