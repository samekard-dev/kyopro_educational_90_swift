func readInt() -> Int {
	Int(readLine()!)!
}

let n = readInt()

func make(pre: [Bool], restAll: Int, restStart: Int) -> [[Bool]] {
	if restAll / 2 < restStart {
		return []
	}
	if restStart == 0 {
		return [pre + [Bool](repeating: false, count: restAll)]
	}
	return (
		make(pre: pre + [true], restAll: restAll - 1, restStart: restStart - 1) +
		make(pre: pre + [false], restAll: restAll - 1, restStart: restStart)
	)
}

if n % 2 == 0 {
	let result = make(pre: [], restAll: n, restStart: n / 2)
	for rr in result {
		for r in rr {
			if r {
				print("(", terminator: "")
			} else {
				print(")", terminator: "")
			}
		}
		print()
	}
}
