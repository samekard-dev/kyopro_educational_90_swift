func readInts() -> [Int] {
    readLine()!.split(separator: " ").map { Int(String($0))! }
}

let mod = 1000000007

let nbk = readInts()
let n = nbk[0]//上限10^18
let b = nbk[1]//上限1000
let k = nbk[2]
let c = readInts()

/*配列がいくつか出てくる。indexの意味を共通にする。すべての配列は
[0] 数字なしに該当
[1] 1に該当
[2] 10に該当 1桁シフトの意味も持つ
[3] 100に該当 2桁シフトの意味も持つ
[4] 10000に該当 4桁シフトの意味も持つ
[5] 100000000に該当 8桁シフトの意味も持つ
:
:
[63] 100...000 ← 0が2305843009213693952個 = 2.3.. * 10^18個
とする 
 */

//まずは0, 1, 10, 100, 10000, 100000000...をbで割った値を求める
//64個目は0の数が2.3.. * 10^18なのでこの問題の範囲の10^18桁を超える。

var power10 = [Int](repeating: 0, count: 64)
power10[0] = 0
power10[1] = 1
power10[2] = 10 % b
for i in 3..<64 {
    power10[i] = power10[i - 1] * power10[i - 1] % b
}

//○桁を使ってできる組み合わせの数を求める。
//○には0,1,2,4,8...
var dp = [[Int]](repeating: [Int](repeating: 0, count: b), count: 64)
for i in 0..<k {
    dp[1][c[i] % b] += 1
}

for i in 2..<64 {
    for j in 0..<b {
        for k in 0..<b {
            //1桁の情報を2つ使って2桁の情報を作る。片方を1桁シフト。
            //2桁の情報を2つ使って4桁の情報を作る。片方を2桁シフト。
            //4桁の情報を2つ使って8桁の情報を作る。片方を4桁シフト。
            let next = (j * power10[i] + k) % b
            dp[i][next] += dp[i - 1][j] * dp[i - 1][k]
            dp[i][next] %= mod            
        }
    }  
}

var ans = [[Int]](repeating: [Int](repeating: 0, count: b), count: 64)

ans[0][0] = 1
var nn = n
for i in 1...62 {
    if nn % 2 == 1 {
        for j in 0..<b {
            for k in 0..<b {
                //x桁の情報を追加するなら既存の情報をx桁左にずらしてから追加する
                //1桁の情報を追加するなら既存の情報を1桁左にずらして(x10)から追加する
                //2桁の情報を追加するなら既存の情報を2桁左にずらして(x100)から追加する
                //4桁の情報を追加するなら既存の情報を4桁左にずらして(x10000)から追加する
                let next = (j * power10[i + 1] + k) % b
                ans[i][next] += ans[i - 1][j] * dp[i][k]
                ans[i][next] %= mod
            }
        }
    } else {
        for j in 0..<b {
            ans[i][j] = ans[i - 1][j]
        }
    }
    nn /= 2
}

print(ans[62][0])
