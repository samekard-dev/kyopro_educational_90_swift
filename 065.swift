import Foundation

let p = 998244353 // NTTに相性の良いmodは998244353．

// 繰り返し二乗法でx^nをmodで割った余りを求める．
func speedPow(x: Int, n: Int, mod: Int) -> Int {
    var n = n
    var p = 1
    var q = x
    while true {
        if n % 2 == 1 {
            p *= q
            p %= mod
        }
        q *= q
        q %= mod
        n /= 2
        if n == 0 {
            break
        }
    }
    return p
}

// modを法とするxの逆元を計算する．
func modInv(x: Int, mod: Int) -> Int {
    return speedPow(x: x, n: mod - 2, mod: mod)
}

// NTTに必要となるrの累乗数を求める．
func makeRoot(mod: Int) -> [Int] {
    var ret: [Int] = []
    var r = speedPow(x: 3, n: 119, mod: mod)
    for _ in 0..<23 {
        ret.append(r)
        r = (r * r) % mod
    }
    return ret.reversed()
}

// NTTに必要となるrの累乗数の逆元を求める．
func makeInvroot(root: [Int], mod: Int) -> [Int] {
    var ret: [Int] = []
    for i in 0..<root.count {
        ret.append(modInv(x: root[i], mod: mod))
    }
    return ret
}

// NTTで必要となるrの累乗数を前計算しておく（これをしないと計算量が悪くなる）．
var root: [Int] = makeRoot(mod: p)
var invroot: [Int] = makeInvroot(root: root, mod: p)

func ntt(source: [Int], depth: Int, inv: Bool) -> [Int] {
    // inv=false ならば普通のNTT，inv=true ならばINTTになるようにする
    let n = source.count
    var ret: [Int] = []
    // aのサイズが1であるときは，それがそのままNTTである．
    if n == 1 {
        return source
    } else {
        var even: [Int] = []
        var odd: [Int] = []
        for i in 0..<n {
            if i % 2 == 0 {
                even.append(source[i])
            } else {
                odd.append(source[i])
            }
        }
        // evenとoddのDFTを，再帰的に求める．
        let d_even = ntt(source: even, depth: depth - 1, inv: inv)
        let d_odd = ntt(source: odd, depth: depth - 1, inv: inv)
        let r = inv ? invroot[depth] : root[depth]
        var now = 1
        for i in 0..<n {
            ret.append((d_even[i % (n / 2)] + (now * d_odd[i % (n / 2)]) % p) % p)
            now = (now * r) % p
        }
    }
    return ret
}

func convolution(a: [Int], b: [Int]) -> [Int] {
    
    // 配列a,bは，それぞれA(x)とB(x)の係数を次数の小さい順に並べたもの．
    let len_a = a.count
    let len_b = b.count
    let len_c = len_a + len_b - 1 //len_cはA(x)*B(x)の項数
    
    var n = 1
    // len_cより大きい最小の2のべき乗の数を求める
    while n <= len_c {
        n *= 2
    }
    
    var longA = a
    var longB = b
    // 配列の長さがnになるまで，配列の末尾に0を追加する
    while longA.count < n {
        longA.append(0)
    }
    while longB.count < n {
        longB.append(0)
    }
    
    /*
     例
     n=8 lon_2n=3
     n=32 lon_2n=5
     */
    var log_2n = 1
    while (1 << log_2n) < n {
        log_2n += 1
    }
    
    // A(x)のNTT DA(t),b(x)のNTT DB(t)を求める．
    // 配列da,dbは，それぞれDA(t),DB(t)の係数を次数の小さい順に並べたもの．
    let da: [Int] = ntt(source: longA, depth: log_2n - 1, inv: false)
    let db: [Int] = ntt(source: longB, depth: log_2n - 1, inv: false)
    
    // C(x)のNTT DC(t).これのk次の係数は，DA(t)とDB(t)のk次の係数を掛け合わせれば求まる．
    var dc = [Int](repeating: 0, count: n)
    for i in 0..<n {
        dc[i] = (da[i] * db[i]) % p
    }
    
    // C(x)はDC(t)をINTTすれば求まる．このようにしてできた配列cは，C(x)の係数を次数の小さい順に並べたものとなっている．
    let c = ntt(source: dc, depth: log_2n - 1, inv: true)
    
    // INTTの後は最後にnで割ることを忘れずに．
    var ret: [Int] = []
    let dn = modInv(x: n, mod: p)
    for i in 0..<n {
        ret.append((c[i] * dn) % p)
    }
    return ret
}

//ここまでNTT
//ここから競プロ典型90問の65

func readInt() -> Int {
    Int(readLine()!)!
}

func readInts() -> [Int] {
    readLine()!.split(separator: " ").map { Int(String($0))! }
}

let ballMax = 200000

let rgbk = readInts()
let rAll = rgbk[0]
let gAll = rgbk[1]
let bAll = rgbk[2]
let k = rgbk[3]
let xyz = readInts()
let x = xyz[0]
let y = xyz[1]
let z = xyz[2]
let minR = k - y
let minG = k - z
let minB = k - x
let maxR = min(rAll, k - minG - minB)
let maxG = min(gAll, k - minB - minR)
let maxB = min(bAll, k - minR - minG)

/*
 rAll = bAll = gAll = 50
 k = 90
 は以下の6つに共通
 
 特徴：ボールの数 < max, min = 0
 x = y = z = 90 のときは
 minR = minG = minB = 0
 maxR = min(50, k - minG - minB) = min(50, 90) = 50
 
 特徴：ボールの数 < max
 x = y = z = 75 のときは
 minR = minG = minB = 15
 maxR = min(50, k - minG - minB) = min(50, 60) = 50
 
 特徴：ボールの数 = max
 x = y = z = 70 のときは 
 minR = minG = minB = 20
 maxR = min(50, k - minG - minB) = min(50, 50) = 50
 
 特徴：ボールの数 > max > min
 x = y = z = 65 のときは
 minR = minG = minB = 25
 maxR = min(50, k - minG - minB) = min(50, 40) = 40
 
 特徴：min = max
 x = y = z = 60 のときは
 minR = minG = minB = 30
 maxR = min(50, k - minG - minB) = min(50, 30) = 30
 
 特徴：min > maxより解なし
 x = y = z = 55 のときは
 minR = minG = minB = 35
 maxR = min(50, k - minG - minB) = min(50, 20) = 20
 */

guard minR <= maxR && minG <= maxG && minB <= maxB else {
    print(0)
    exit(0)
}

var factorial = [Int](repeating: 0, count: ballMax + 1)
var invFactorial = [Int](repeating: 0, count: ballMax + 1)

factorial[0] = 1
invFactorial[0] = 1
for i in 1...ballMax {
    factorial[i] = i * factorial[i - 1] % p
    invFactorial[i] = modInv(x: factorial[i], mod: p)
}

func ncr(n: Int, r: Int) -> Int {
    if r < 0 || n < r {
        return 0
    }
    return (factorial[n] * invFactorial[r] % p) * invFactorial[n - r] % p
}

//Cはcombination
var rC = [Int](repeating: 0, count: rAll + 1)
var bC = [Int](repeating: 0, count: bAll + 1)
var gC = [Int](repeating: 0, count: gAll + 1)

for r in minR...maxR {
    rC[r] = ncr(n: rAll, r: r)
}
for g in minG...maxG {
    gC[g] = ncr(n: gAll, r: g)
}
for b in minB...maxB {
    bC[b] = ncr(n: bAll, r: b)
}

let comvGB: [Int] = convolution(a: gC, b: bC)
var ans = 0
for r in minR...maxR {
    ans += (rC[r] * comvGB[k - r]) % p
    ans %= p
}

print(ans)

