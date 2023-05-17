/*
64ビットのDoubleを使うと細かい部分が落ちてしまってWAになるように
問題とテストケースが作成されているので
Intの64ビットを使う

a * log(b)は、log(b ^ a)に変換できる（in基礎解析、今でいう数2）
*/

func readIntArray() -> [Int] {
	readLine()!.split(separator: " ").map { Int(String($0))! }
}

let abc = readIntArray()
let a = Int64(abc[0])
let b = Int64(abc[1])
let c = Int64(abc[2])

var d: Int64 = 1
for _ in 1...b {
	d *= c
}

//底の2が1より大なので不等号の向きがそのまま
if a < d {
	print("Yes")
} else {
	print("No")
}
