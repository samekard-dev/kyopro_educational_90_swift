import Foundation

func readInt() -> Int {
	Int(readLine()!)!
}

let k = readInt()
var kSqrt = Int(pow(Double(k), 1.0 / 2.0))
if (kSqrt + 1) * (kSqrt + 1) == k { //x.99999...対策
	kSqrt += 1
}
var kCbrt = Int(pow(Double(k), 1.0 / 3.0))
if (kCbrt + 1) * (kCbrt + 1) * (kCbrt + 1) == k { //x.99999...対策
	kCbrt += 1
}

var dv: [Int] = [] //約数を入れる、1とkも含む
for i in 1...kSqrt {
	if k % i == 0 {
		dv.append(i)
		if i != k / i {
			dv.append(k / i)
		}
	}
}
dv = dv.sorted(by: <)
let dvCnt = dv.count

var counter = 0
var i = 0
while dv[i] <= kCbrt {
	var j = i
	while dv[j] <= kSqrt && dv[j] * dv[j] <= k / dv[i] {
		if k % (dv[i] * dv[j]) == 0 {
			counter += 1
		}
		j += 1
		if j == dvCnt {
			break
		}
	}
	i += 1
	if i == dvCnt {
		break
	}
}
print(counter)
