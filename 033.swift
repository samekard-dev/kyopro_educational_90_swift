func readIntArray() -> [Int] {
	readLine()!.split(separator: " ").map { Int(String($0))! }
}

let hw = readIntArray()
let h = hw[0]
let w = hw[1]

if h == 1 || w == 1 {
	print(h * w)
} else {
	print(((h + 1) / 2) * ((w + 1) / 2))
}
