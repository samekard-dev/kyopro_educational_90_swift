let tenNineSeven = 1000000007

func readInt() -> Int {
	Int(readLine()!)!
}

func readIntArray() -> [Int] {
	readLine()!.split(separator: " ").map { Int(String($0))! }
}

let n = readInt()
let char = readLine()!.split(separator: " ")

var connect = [(p: Int, c: Set<Int>)](repeating: (-1, []), count: n)
for _ in 1...n - 1 {
	let pair = readIntArray()
	connect[pair[0] - 1].c.insert(pair[1] - 1)
	connect[pair[1] - 1].c.insert(pair[0] - 1)
}

func organize(t: Int) {
	for c in connect[t].c {
		connect[c].p = t
		connect[c].c.remove(t)
		organize(t: c)
	}
}
organize(t: 0)

var types = [(ab: Int, a: Int, b: Int)](repeating: (ab: 0, a: 0, b: 0), count: n)

func check(t: Int) {
	
	if connect[t].c.isEmpty {
		if char[t] == "a" {
			types[t].a = 1
		} else if char[t] == "b" {
			types[t].b = 1
		}
	} else {
		for c in connect[t].c {
			check(t: c)
		}
		
		//部分木全体の値
		//t: total
		var tTypeAB = 0
		var tTypeSame = 0
		var first = true
		
		for c in connect[t].c {
			
			//AとBはほとんど同じ処理になるのでsameとtheOtherに変更する
			//sameは親と同じ
			var cTypeSame = 0
			var cTypeTheOther = 0
			if char[t] == "a" {
				cTypeSame = types[c].a
				cTypeTheOther = types[c].b
			} else if char[t] == "b" {
				cTypeSame = types[c].b
				cTypeTheOther = types[c].a
			}

			//親と単独の子の関係
			//s: single
			let sTypeAB = (types[c].ab + cTypeTheOther) % tenNineSeven
			//- 子のType_ABと接続する
			//- 子の反対タイプと接続する
			
			let sTypeSame = (types[c].ab + cTypeSame) % tenNineSeven
			//- 子のType_ABと接続しない
			//- 子の同じタイプと接続する
			
			//統合する
			if first {
				tTypeAB = sTypeAB
				tTypeSame = sTypeSame
				first = false
			} else {
				tTypeAB = (tTypeAB * sTypeAB
						   + tTypeAB * sTypeSame
						   + tTypeSame * sTypeAB) % tenNineSeven
				tTypeSame = (tTypeSame * sTypeSame) % tenNineSeven
			}
		}

		types[t].ab = tTypeAB
		if char[t] == "a" {
			types[t].a = tTypeSame
		} else if char[t] == "b" {
			types[t].b = tTypeSame
		}
	}
}

check(t: 0)
print(types[0].ab)

/*
 ある頂点以下で構成される部分木について考える
 その部分木はすでに切断の全パターンが調べられているとする
 （切断は各部分にAとB両方含むように行われる。
 ただし、トップが含まれるグループだけは
 上とつながる拡張性があるのでABのどちらか一方でもよいとする）
 その全パターンは次のように分けられる
 - 「トップが含まれるグループ」にAB両方含む。これをType_ABとする
 - 「トップが含まれるグループ」はAのみ。これをType_Aとする
 - 「トップが含まれるグループ」はBのみ。これをType_Bとする
 
 例えば、
 部分木が葉のみでそれがAの場合、Type_A が1個である
 Aに2個のBがぶら下がっている場合、Type_AB が1個
 a (a (a, b), b (a, b))という部分木の場合
 Type_AB が3個
 Type_A が1個
 の4つが考えられる
 
 次に、その頂点の親(Pとする)以下の部分木が上の3パターンをそれぞれいくつ持つか調べる
 PがAのとき、P以下の部分木は
 Type_Bにはならない
 Type_Aになるには子のType_Aと接続するか子のType_ABと接続を切るなので、
 - 子のType_Aと接続
 - 子のType_ABと切断
 を考える
 Type_ABになるには子のType_ABとType_Bのうちのどれかとつなげるので、
 - 子のType_ABと接続
 - 子のType_Bと接続
 を考えるが、
 その場合別の子のType_Aと接続してもType_ABとなるのでこれも考慮する。
 
 プログラムでは一度に全部の子を扱って集計するのではなく、子をひとつづつ加えていく
 */
