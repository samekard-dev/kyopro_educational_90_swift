func readInt() -> Int {
	Int(readLine()!)!
}

func readIntArray() -> [Int] {
	readLine()!.split(separator: " ").map { Int(String($0))! }
}

//y：たて方向のどの位置か指定
//x：よこ方向のどの位置か指定

let hw = readIntArray()
let h = hw[0] + 2 //入力が1スタートなのに合わせると同時に下と右にもマージン
let w = hw[1] + 2
var paint = [Bool](repeating: false, count: h * w)
var root = [Int](repeating: 0, count: h * w)
for i in 0..<root.count {
	root[i] = i
}

func linearN(_ y: Int, _ x: Int) -> Int {
	return y * w + x
}

func checkNeighbors(_ n: Int) -> [Int] {
	var returnArray: [Int] = []
	for offset in [-w, -1, 1, w] {
		if paint[n + offset] {
			returnArray.append(n + offset)
		}
	}
	return returnArray
}

func getRoot(_ n: Int) -> Int {
	if root[n] == n {
		return n
	} else {
		root[n] = getRoot(root[n])
		return root[n]
	}
}

let q = readInt()
for _ in 0..<q {
	let input = readIntArray()
	if input[0] == 1 {
		let y = input[1]
		let x = input[2]
		let n = linearN(y, x)
		paint[n] = true
		let neighbors = checkNeighbors(n)
		var minRoot = getRoot(n)
		for neighbor in neighbors {
			minRoot = min(minRoot, getRoot(neighbor))
		}
		root[n] = minRoot
		for neighbor in neighbors {
			root[root[neighbor]] = minRoot
		}
	} else if input[0] == 2 {
		let n1 = linearN(input[1], input[2])
		let n2 = linearN(input[3], input[4])
		if paint[n1] && paint[n2] {
			let r1 = getRoot(n1)
			let r2 = getRoot(n2)
			if r1 == r2 {
				print("Yes")
			} else {
				print("No")
			}
		} else {
			print("No")
		}
	}	
}
