//グループを作る。グループ内のひとつの値が決定すれば他のものも決定する関係で構成する
//グループの中で一番小さいものをleaderとする
//グループ内のそれぞれのものはleaderと自分の関係を記録しておく

func readInt() -> Int {
	Int(readLine()!)!
}

func readIntArray() -> [Int] {
	readLine()!.split(separator: " ").map { Int(String($0))! }
}

struct Relationship {
	var leader: Int
	var source: Int = 0
	var flag: Int = 1
	/* leaderが決定したら自身の値は
	 自身 = source + flag * leaderの値
	 で求まる
	 自身が決定したらleaderはいくつか求めるときもこの式を利用する
	 */
}

let n = readInt()
let qs = readInt()

var rel = (0...n).map { Relationship(leader: $0) }

func organize(_ a: Int) {
	let leader = rel[a].leader
	if rel[leader].leader == leader {
		return
	} else {
		organize(leader)
		rel[a].source += rel[a].flag * rel[leader].source
		rel[a].flag *= rel[leader].flag
		rel[a].leader = rel[leader].leader
	}
}

for _ in 1...qs {
	let q = readIntArray()
	switch q[0] {
		case 0:
			rel[q[2]].leader = q[1]
			rel[q[2]].source = q[3]
			rel[q[2]].flag = -1
			organize(q[2])
		case 1:
			organize(q[1])
			organize(q[2])
			if rel[q[1]].leader == rel[q[2]].leader {
				let leaderValue = rel[q[1]].flag * (q[3] - rel[q[1]].source)
				let q2Value = rel[q[2]].source + rel[q[2]].flag * leaderValue
				print(q2Value)
			} else {
				print("Ambiguous")
			}
		default:
			fatalError()
	}
}


/*
 *で始まる文は状況の説明
 
 * a b c dがある
 a
 b
 c
 d
 
 * a + b = あ が与えられる
 a
 bあ  b = あ - a
 c
 d
 
 * b + c = い が与えられる
 a
 bあ  b = あ - a
 cい  c = い - b = い - あ + a
 d
 
 * c + d = う が与えられる
 a
 bあ  b = あ - a
 cい  c = い - b = い - あ + a
 dう  d = う - c = う - (い - あ + a) = う - い + あ - a
 
 * d + e = え が与えられる
 a
 bあ  b = あ - a
 cい  c = い - b = い - あ + a
 dう  d = う - c = う - (い - あ + a) = う - い + あ - a
 eえ  d = え - d = え - (う - い + あ - a) = え - う + い - あ + a
 
 離れている情報を処理するパターン
 
 * a b c dがある
 a
 b
 c
 d
 
 * b + c = い という情報が与えられる
 a
 b
 cい  c = い - b
 d
 
 * c + d = う という情報が与えられる
 a
 b
 cい  c = い - b
 dう  d = う - い + b
 
 * a + b = あ という情報が与えられる
 a
 bあ  b = あ - a
 cい  c = い - b
 dう  d = う - い + b
 
 * dを使おうとしたとき、dが見ているbはleaderではないと発覚したので更新する
 a
 bあ  b = あ - a
 cい  c = い - b
 dう  d = う - い + あ - a
 このようにdとbが離れていても単純に代入すれば良い
 
 必要な情報は
 - ひらがなの和
 - leaderの符号
 の2つ
 
 */
