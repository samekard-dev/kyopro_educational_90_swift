func readIntArray() -> [Int] {
	readLine()!.split(separator: " ").map { Int(String($0))! }
}

let nq = readIntArray()
let n = nq[0]
let q = nq[1]
let a = readIntArray()
var d = [Int](repeating: 0, count: n - 1)
var current = 0
for i in 0..<n - 1 {
	d[i] = a[i + 1] - a[i]
	current += abs(d[i])
}

for _ in 1...q {
	let lrv = readIntArray()
	let l = lrv[0] - 1
	let r = lrv[1] - 1
	let v = lrv[2]
	
	if l > 0 {
		current -= abs(d[l - 1])
		d[l - 1] += v
		current += abs(d[l - 1])
	}
	if r < n - 1 {
		current -= abs(d[r])
		d[r] -= v
		current += abs(d[r])
	}
	print(current)
}
