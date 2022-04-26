/*
 基本法
 問題文の通り
 新しい色を周りに伝える

 優劣法
 隣接するペアは隣接頂点数によって優劣をつける
 5と3なら、5の頂点が優、3の頂点が劣
 多い頂点（優）から少ない頂点（劣）へは
 - 色を伝えない
 少ない頂点から多い頂点へは
 - 多い頂点への指令がいつ出たか確認する
 - 色を伝える
 頂点数が同じのときは
 - 色を伝える
 このやり方はランダムに配置された状況では基本法と処理回数があまり変わらないと思われるが
 基本法で処理時間オーバーを出すように作られた特殊なケースでは処理が軽減される
 */

func readInt() -> Int {
	Int(readLine()!)!
}

func readIntArray() -> [Int] {
	readLine()!.split(separator: " ").map { Int(String($0))! }
}

let nm = readIntArray()
let n = nm[0]
let m = nm[1]
var conSet = [(p: Set<Int>, s: Set<Int>, c: Set<Int>)](repeating: (p: [], s: [], c: []), count: n + 1)
//con: connection p: parent s: sibling c: children
var edge = [Int](repeating: 0, count: n + 1)
for _ in 0..<m {
	let ab = readIntArray()
	conSet[ab[0]].s.insert(ab[1])
	conSet[ab[1]].s.insert(ab[0])
	edge[ab[0]] += 1
	edge[ab[1]] += 1
}
for i in 1...n {
	for j in conSet[i].s where i < j {
		if edge[i] < edge[j] {
			//iが子 jが親
			conSet[i].s.remove(j)
			conSet[i].p.insert(j)
			conSet[j].s.remove(i)
			conSet[j].c.insert(i)
		} else if edge[i] > edge[j] {
			//iが親 jが子
			conSet[i].s.remove(j)
			conSet[i].c.insert(j)
			conSet[j].s.remove(i)
			conSet[j].p.insert(i)
		}
		//edge[i] == edge[j]のときはそのまま
	}
}
//Set -> Array
var con: [(p: [Int], s: [Int], c: [Int])] = []
for i in 0...n {
	con.append((p: Array(conSet[i].p), s: Array(conSet[i].s), c: Array(conSet[i].c)))
}

var state = [(updateTime: Int, qTime: Int)](repeating: (updateTime: 0, qTime: 0), count: n + 1)
//updateTime: 書き換えがおきた時間
//qTime: 指令が来た時間

let qs = readInt()
var colors = [Int](repeating: -1, count: qs + 1) //指令の色の履歴
colors[0] = 1
for qn in 1...qs {
	let q = readIntArray()
	let target = q[0]
	colors[qn] = q[1]
	
	var latest = state[target].updateTime
	for p in con[target].p {
		if state[p].qTime > latest {
			latest = state[p].qTime
		}
	}
	print(colors[latest])
	
	state[target] = (updateTime: qn, qTime: qn)
	for p in con[target].p {
		state[p].updateTime = qn
	}
	for s in con[target].s {
		state[s].updateTime = qn
	}
}
