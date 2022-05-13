func readIntArray() -> [Int] {
	readLine()!.split(separator: " ").map { Int(String($0))! }
}

struct State {
	var l: Int //なくても良いが、lとrでそろえるとコードが見やすい
	var r: Int
	var v: Int
	var pre: Int
	var next: Int
	
	init(l: Int, r: Int, v: Int, pre: Int, next: Int) {
		self.l = l
		self.r = r
		self.v = v
		self.pre = pre
		self.next = next
	}
}

let wn = readIntArray()
let w = wn[0]
let n = wn[1]

var base = [State](repeating: State(l: 0, r: 0, v: 0, pre: 0, next: w + 1), count: w + 2)
var add = [State](repeating: State(l: 0, r: 0, v: 0, pre: 0, next: w + 1), count: w + 2)
//素材ごとにaddのデータを作成しbaseに統合する

var inputData = [(l: Int, r: Int, v: Int)](repeating: (0, 0, 0), count: n)

for i in 0..<n {
	let lrv = readIntArray()
	inputData[i] = (lrv[0], lrv[1], lrv[2])
}

inputData = inputData.sorted(by: {
	return $0.r - $0.l < $1.r - $1.l
})
 
for i in 0..<n {
	let l = inputData[i].l
	let r = inputData[i].r
	let v = inputData[i].v
	
	//前回までのデータに今回の材料を最低量で足したデータをaddに設定する。
	do {
		var ref = 0
		var latest = 0
		
		while ref != w + 1 {
			let idx = base[ref].l + l
			if idx > w {
				break
			}
			add[idx] = State(l: idx, r: base[ref].r + l, 
								 v: base[ref].v + v, 
								 pre: latest, next: -1)
			add[latest].next = idx
			latest = idx
			ref = base[ref].next
		}
		add[latest].next = w + 1
		add[w + 1].pre = latest
	}
	
	//今作ったデータの個々の右端を拡張していく。他と重なった場合は価値を比べる。
	//拡張の対象は最後から逆順に
	let ex = r - l
	var checking = add[w + 1].pre
	while checking != 0 {
		let rr = min(add[checking].r + ex, w)
		add[checking].r = rr //仮。状況により削っていく。
		
		var comp = add[checking].next //compared
	extending:
		while comp != w + 1 {
			if rr < add[comp].l {
				if rr == add[comp].l - 1 && add[checking].v == add[comp].v {
					add[checking].r = add[comp].r
					add[checking].next = add[comp].next
					add[add[comp].next].pre = checking
				}
				break
			} else {
				let diffV = add[checking].v - add[comp].v
				if diffV < 0 {
					add[checking].r = add[comp].l - 1
					break
				} else if diffV > 0 {
					if rr < add[comp].r{
						add[checking].next = rr + 1
						add[rr + 1] = State(l: rr + 1, r: add[comp].r, 
											v: add[comp].v, 
											pre: checking, next: add[comp].next)
						add[add[rr + 1].next].pre = rr + 1
						break
					} else {
						add[checking].next = add[comp].next
						add[add[comp].next].pre = checking
					}
				} else {
					add[checking].r = max(rr, add[comp].r)
					add[checking].next = add[comp].next
					add[add[comp].next].pre = checking
				}
			}
			comp = add[checking].next
		}
		checking = add[checking].pre
	}
	
	//融合する
	do {
		var bIdx = base[0].next
		var aIdx = add[0].next
		var latest = 0
		
		while bIdx != w + 1 || aIdx != w + 1 {
			if aIdx == w + 1 {
				base[latest].next = bIdx
				base[bIdx].pre = latest
				bIdx = w + 1
				latest = base[w + 1].pre
				break
			}
			if bIdx == w + 1 {
				base[latest].next = aIdx
				base[aIdx] = State(l: aIdx, r: add[aIdx].r, 
								   v: add[aIdx].v, 
								   pre: latest, next: -1)
				latest = aIdx
				aIdx = add[aIdx].next
				continue
			}
			
			if base[bIdx].r < add[aIdx].l {
				base[latest].next = bIdx
				base[bIdx].pre = latest
				latest = bIdx
				bIdx = base[bIdx].next
			} else if add[aIdx].r < base[bIdx].l {
				base[latest].next = aIdx
				base[aIdx] = State(l: aIdx, r: add[aIdx].r, 
								   v: add[aIdx].v, 
								   pre: latest, next: -1)
				latest = aIdx
				aIdx = add[aIdx].next
			} else {
				//重なっている。重なり方は
				//開始が(同じ、baseが左、addが左)の3つ
				//終了が(同じ、baseが右、addが右)の3つ
				//合計9つ
				let head1 = min(base[bIdx].l, add[aIdx].l)
				let head2 = max(base[bIdx].l, add[aIdx].l) - 1
				let body1 = max(base[bIdx].l, add[aIdx].l)
				let body2 = min(base[bIdx].r, add[aIdx].r)
				let tail1 = min(base[bIdx].r, add[aIdx].r) + 1
				
				//tailを分割し、今回はbody部分までの制御とする。tail部分は次回に行う
				if base[bIdx].r < add[aIdx].r {
					add[tail1] = State(l: tail1, r: add[aIdx].r, 
									   v: add[aIdx].v, 
									   pre: aIdx, next: add[aIdx].next)
					add[aIdx].r = body2
					add[aIdx].next = tail1
					add[add[tail1].next].pre = tail1
				}
				if add[aIdx].r < base[bIdx].r {
					base[tail1] = State(l: tail1, r: base[bIdx].r, 
										v: base[bIdx].v, 
										pre: bIdx, next: base[bIdx].next)
					base[bIdx].r = body2
					base[bIdx].next = tail1
					base[base[tail1].next].pre = tail1
				}
				
				//左側のチェック
				if base[bIdx].l == add[aIdx].l {
					if add[aIdx].v > base[bIdx].v {
						base[bIdx].v = add[aIdx].v
					}
					base[latest].next = bIdx
					latest = bIdx
					aIdx = add[aIdx].next
					bIdx = base[bIdx].next
				} else {
					let bValue = base[bIdx].v
					let aValue = add[aIdx].v
					let bNext = base[bIdx].next
					let aNext = add[aIdx].next
					
					//head部分を切り離す
					base[latest].next = head1
					base[head1] = State(l: head1, r: head2, 
										v: 0, 
										pre: latest, next: body1)
					base[body1] = State(l: body1, r: body2, 
										v: 0, 
										pre: head1, next: bNext)
					base[bNext].pre = body1
					
					//vを設定する
					if add[aIdx].l < base[bIdx].l {
						base[head1].v = aValue
					} else {
						base[head1].v = bValue
					}
					base[body1].v = max(aValue, bValue)
					
					latest = body1
					bIdx = bNext
					aIdx = aNext
				}
			}
		}
		base[w + 1].pre = latest
		base[latest].next = w + 1
		
		//同じ値がつながったところを整理
		var i = 0
		while base[i].next != w + 1 {
			let next = base[i].next
			if base[i].r + 1 == base[next].l &&
				base[i].v == base[next].v {
				base[i].r = base[next].r
				base[i].next = base[next].next
				base[base[next].next].pre = i
			} else {
				i = next
			}
		}
	}
}

let last = base[w + 1].pre
if base[last].r == w {
	print(base[last].v)
} else {
	print(-1)
}
