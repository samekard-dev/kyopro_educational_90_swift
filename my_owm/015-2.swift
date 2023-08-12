//nが30程度までは有効なやりかた

//kが決まれば、選択ボールの間の選択出来ないボールの数が決まる
//選択ボール数が決まれば、選択出来ないボールの合計数が決まる
//選択できるボールから選択を行う「場合の数」を求める

func readInt() -> Int {
	Int(readLine()!)!
}

let mod = 1000000000 + 7
let n = readInt()

for k in 1...n {
	let bMax = (n - 1) / k + 1 //最大ボール数
	var kValue = 0
	for b in 1...bMax {
		let d = (b - 1) * (k - 1) //選択ボールの間の選択されないボールの数
		let s = n - d //選択できるボールの数
		var bSum = 1
		for i in 1...b {
			bSum *= (s - i + 1)
			bSum /= i
		}
		kValue += bSum
	}
	print(kValue)
}
