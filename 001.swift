//001.swift
//羊羹を切る問題
func readInt() -> Int {
	Int(readLine()!)!
}

func readIntArray() -> [Int] {
	readLine()!.split(separator: " ").map { Int(String($0))! }
}

let nl = readIntArray()
let n = nl[0]  //切れ目の数
let l = nl[1]  //羊羹の長さ
let k = readInt()  //採用する切れ目の数
let a = readIntArray()  //各切れ目の左からの長さ

func solve(m: Int) -> Bool {
	var cnt = 0, pre = 0
	for i in 0..<n {  //c++の方では1...nとなっているが俯瞰で見るとやっていることは同じ
		if a[i] - pre >= m && l - a[i] >= m {
			cnt += 1
			pre = a[i]
		}
	}
	if cnt >= k {
		return true
	} 
	return false
}

//この問題だけでなく他の2分探索にも応用できるような初期値の選び方かと
var left = -1  
var right = l + 1
while right - left > 1 {  //最後は隣り合った2つになって抜ける
	let mid = left + (right - left) / 2
	if solve(m: mid) == false {
		right = mid
	} else {
		left = mid
	}
}
print(left)
