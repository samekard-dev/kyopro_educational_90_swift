import Foundation

//TLEになる

func readIntArray() -> [Int] {
	readLine()!.split(separator: " ").map { Int(String($0))! }
}

struct RangeInfo {
	var v: Int
	var l: Int
	var r: Int
}

enum State {
	case start
	case end
}

let wn = readIntArray()
let w = wn[0]
let n = wn[1]

var dp = [[RangeInfo]](repeating: [], count: n + 1)
dp[0].append(RangeInfo(v: 0, l: 0, r: 0))

var values: [Int] = [] //出現した価値をヒープソートで管理
//ヒープソート 追加
func addValue(_ v: Int) {
	values.append(v)
	var p = values.count - 1
	while p != 0 {
		if values[p] > values[(p - 1) / 2] {
			let temp = values[(p - 1) / 2]
			values[(p - 1) / 2] = values[p]
			values[p] = temp
			p = (p - 1) / 2
		} else {
			break
		}
	}
}

//ヒープソート 削除
func popValue() -> Int? {
	if values.isEmpty {
		return nil
	} else {
		let returnValue = values[0]
		values[0] = values[values.count - 1]
		var p = 0
		while p <= values.count / 2 - 1  {
			var compared = p * 2 + 1
			if compared + 1 <= values.count - 1 {
				if values[compared + 1] > values[compared] {
					compared = compared + 1
				}
			}
			if values[p] < values[compared] {
				let temp = values[compared]
				values[compared] = values[p]
				values[p] = temp
				p = compared
			} else {
				break
			}
		}
		values.removeLast()
		return returnValue
	}
}

dishesLoop:
for i in 1...n {
	let lrv = readIntArray()
	let l = lrv[0]
	let r = lrv[1]
	let v = lrv[2]
	var changes: [Int: [(s: State, v: Int)]] = [:]
	for d in dp[i - 1] {
		changes[d.l, default: []].append((.start, d.v))
		changes[d.r + 1, default: []].append((.end, d.v))
		changes[d.l + l, default: []].append((.start, d.v + v))
		changes[d.r + r + 1, default: []].append((.end, d.v + v))
	}
	//スタートやエンドの情報は境目に収まっていると考える
	//2から4の領域の場合、1と2の間にスタート、4と5の間にエンドの情報を収める
	
	values = [] //出現した価値をヒープソートで管理
	var valueCounter: [Int : Int] = [:]
	var current: (v: Int, s: Int)? = nil
	for p in changes.keys.sorted(by: <) {
		if p >= w + 1 {
			if let c = current {
				dp[i].append(RangeInfo(v: c.v, l: c.s, r: w))
				current = nil
			}
			continue dishesLoop
		}
		for c in changes[p]! {
			switch c.s {
				case .start:
					if valueCounter[c.v] == nil {
						addValue(c.v)
						valueCounter[c.v] = 0
					}
					valueCounter[c.v]! += 1
				case .end:
					valueCounter[c.v]! -= 1
			}
		}
		while values.isEmpty == false && valueCounter[values[0]] == 0 {
			valueCounter[values[0]] = nil
			_ = popValue()
		}
		
		let oldValue = current == nil ? -1 : current?.v
		let newValue = values.isEmpty ? -1 : values[0]
		if oldValue != newValue {
			if let c = current {
				dp[i].append(RangeInfo(v: c.v, l: c.s, r: p - 1))
				current = nil
			}
			if values.isEmpty == false {
				current = (v: values[0], s: p)
			}
		}
	}
}

var hit = -1
for i in dp[n] {
	if i.r < w {
		continue
	}
	if i.l <= w {
		hit = i.v
	}
	break
}
print(hit)
