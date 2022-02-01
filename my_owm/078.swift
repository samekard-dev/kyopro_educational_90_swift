func readIntArray() -> [Int] {
	readLine()!.split(separator: " ").map { Int(String($0))! }
}

let nm = readIntArray()
let n = nm[0]
let m = nm[1]

//頂点は1から始まるので要素数をn+1にする
var countYoungerSiblings = [Int](repeating: 0, count: n + 1)

for _ in 1...m {
	let ab = readIntArray()
	
	//単純グラフなのでa=bを考えなくていい
	countYoungerSiblings[ab.max()!] += 1
}

print(countYoungerSiblings.filter{$0 == 1}.count)
