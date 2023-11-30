//個数が少ないならよいが、多くなるとTLEになる

func readIntArray() -> [Int] {
	readLine()!.split(separator: " ").map { Int(String($0))! }
}

let nm = readIntArray()
let n = nm[0]
let m = nm[1]

var ins = [Set<Int>](repeating: [], count: n + 1)
var outs = [Set<Int>](repeating: [], count: n + 1)

for _ in 1...m {
	let ft = readIntArray()
	let from = ft[0]
	let to = ft[1]
	// 団体A→from→to→団体B
	let fromG = Set([from]).union(ins[from])
	let toG = Set([to]).union(outs[to])
	
	//すでに登録されているものを省く
	let fromG2 = fromG.subtracting(ins[to])
	let toG2 = toG.subtracting(outs[from])
	
	if toG2.isEmpty == false {
		for f in fromG {
			outs[f] = outs[f].union(toG2)
		}
	}
	if fromG2.isEmpty == false {
		for t in toG {
			ins[t] = ins[t].union(fromG2)
		}
	}
}

var counter = 0
for i in 0..<n {
	let both = ins[i].intersection(outs[i]).filter({$0 > i})
	counter += both.count
}

print(counter)
