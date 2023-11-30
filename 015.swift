let tenNineSeven = 1000000007

func modPow(a: Int, b: Int, m: Int) -> Int {
    //a ^ b % m を求める
    var value = 1
    var seed = a
    var mul = b
    while mul != 0 {
        if mul % 2 != 0 {
            value *= seed
            value %= m
        }
        seed *= seed
        seed %= m
        mul /= 2
    }
    return value
}

func modDiv(a: Int, b: Int, m: Int) -> Int {
    // a/b の mod m での逆元を求める
    return a * modPow(a: b, b: m - 2, m: m) % m
}

//ここから競プロ典型90問の15

func readInt() -> Int {
    Int(readLine()!)!
}

let n = readInt()

var fact = [Int](repeating: 0, count: n + 1)
var factInv = [Int](repeating: 0, count: n + 1)
fact[0] = 1

for i in 1...n {
    fact[i] = i * fact[i - 1] % tenNineSeven
    factInv[i] = modDiv(a: 1, b: fact[i], m: tenNineSeven)
}

func ncr(n: Int, r: Int) -> Int {
    if n == r {
        return 1
    }
    return fact[n] * factInv[n - r] % tenNineSeven * factInv[r] % tenNineSeven
}

for k in 1...n {
    let maxB = (n - 1) / k + 1
    var sum = 0
    for b in 1...maxB { //bは選ぶボールの数
        let selectable = n - (k - 1) * (b - 1)
        sum += ncr(n: selectable, r: b) 
        sum %= tenNineSeven
    }
    print(sum)
}

/*
 n = 10
 k = 3
 のとき選ぶボールの数は1or2or3or4個
 
 選ぶボール1個
 10C1
 
 選ぶボール2個
 x●○○x●x
 のxに残りの○6個を入れる
 xは3ヶ所(仕切りが2つ)なので
 6個の○と2つの仕切りの並べ方は8C2
 
 選ぶボール3個
 x●○○x●○○x●x
 のxに残りの○3個を入れる
 xは4ヶ所なので
 3個の○と3つの仕切りの並べ方は6C3
 
 選ぶボール4個
 x●○○x●○○x●○○x●x
 のxに残りの○0個を入れる
 xは5ヶ所なので
 0個の○と4つの仕切りの並べ方は4C4
 */
