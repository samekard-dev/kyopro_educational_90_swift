import Foundation

let p = 998244353 // NTTに相性の良いmodは998244353．

// 繰り返し二乗法でx^nをmodで割った余りを求める．
func speedPow(x: Int, n: Int, mod: Int) -> Int {
    var n = n
    var p = 1
    var q = x
    while n != 0 {
        if n % 2 == 1 {
            p *= q
            p %= mod
        }
        q *= q
        q %= mod
        n /= 2
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

func ntt(source: [Int], inv: Bool) -> [Int] {
    // inv=false ならば普通のNTT，inv=true ならばINTTになるようにする
    
    let length = source.count
    var dir = 1
    var source1 = source
    var source2 = [Int](repeating: 0, count: length)
    
    var depth = 0
    var loop = 1
    var kind = length / 2
    var step = length / 2
   
    /* 例
     0 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 loop 8 kind1 step 1 
     0   2   4   6   8   10    12    14    loop 4 kind2 step 2 
     0       4       8         12          loop 2 kind4 step 4 
     0               8                     loop 1 kind8 step 8 
     */

    while step > 0 {
        let r = inv ? invroot[depth] : root[depth]
        var now = 1
        for l in 0..<loop {
            let rE = l * 2 * step //re:read even
            let rO = l * 2 * step + step //ro:read odd
            let w1 = l * step //w:write
            let w2 = length / 2 + l * step
            for k in 0..<kind {
                if dir == 1 {
                    source2[w1 + k] = (source1[rE + k] + (source1[rO + k] * now) % p) % p
                    source2[w2 + k] = (source1[rE + k] + (source1[rO + k] * (((p - 1) * now) % p)) % p) % p
                } else {
                    source1[w1 + k] = (source2[rE + k] + (source2[rO + k] * now)) % p % p
                    source1[w2 + k] = (source2[rE + k] + (source2[rO + k] * (((p - 1) * now) % p)) % p) % p
                }
            }
            now = (now * r) % p
        }
        depth += 1
        loop *= 2
        kind /= 2
        step /= 2
        dir = 3 - dir
    }
    
    if dir == 1 {
        return source1
    } else {
        return source2
    }
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
    longA.append(contentsOf: [Int](repeating: 0, count: n - longA.count))
    longB.append(contentsOf: [Int](repeating: 0, count: n - longB.count))

    // A(x)のNTT DA(t),b(x)のNTT DB(t)を求める．
    // 配列da,dbは，それぞれDA(t),DB(t)の係数を次数の小さい順に並べたもの．
    let da = ntt(source: longA, inv: false)
    let db = ntt(source: longB, inv: false)
    
    // C(x)のNTT DC(t).これのk次の係数は，DA(t)とDB(t)のk次の係数を掛け合わせれば求まる．
    var dc = [Int](repeating: 0, count: n)
    for i in 0..<n {
        dc[i] = (da[i] * db[i]) % p
    }
    
    // C(x)はDC(t)をINTTすれば求まる．このようにしてできた配列cは，C(x)の係数を次数の小さい順に並べたものとなっている．
    let dd = ntt(source: dc, inv: true)
    
    // INTTの後は最後にnで割ることを忘れずに．
    var ret = [Int](repeating: 0, count: n)
    let dn = modInv(x: n, mod: p)
    for i in 0..<n {
        ret[i] = (dd[i] * dn) % p
    }

    return ret
}

//ここまでNTT
//ここから競プロ典型90問の90

func readInts() -> [Int] {
    readLine()!.split(separator: " ").map { Int(String($0))! }
}

func polynomialInverse(c: [Int], l: Int) -> [Int] {
    // 1/(C[0] + C[1] * x + ... * C[N-1] * x^(N-1)) = P(x) つまり
    // P(x) * (C[0] + C[1] * x + ... * C[N-1] * x^(N-1)) == 1 (mod x^L) を満たす、l-1 次以下の多項式 P(x) を計算量 O(N log N) で求める
    // 制約: C[0] == 1 でなければならない
    let n = c.count
    var a = [1, 0] //2桁からスタート
    var level = 0
    while (1 << level) < l { //1<<levelは答が確定している桁数
        let cs = min(2 << level, n) //Cは少しづつ使う量を増やす。csはCをいくつ使うか。はじめは2。
        let ac = convolution(a: a, b: [Int](c[0..<cs]))
        var q = [Int](repeating: 0, count: 2 << level)
        q[0] = 1
        for j in (1 << level)..<(2 << level) {
            q[j] = (p - ac[j]) % p //ac[j] == 0を考慮する
        }
        a = convolution(a: a, b: q)
        a.append(contentsOf: [Int](repeating: 0, count: (4 << level) - a.count))
        level += 1
    }
    a.removeLast(a.count - l)
    return a
}

func bostanMori(a: [Int], b: [Int], n: Int) -> Int {
    var a = a
    var b = b
    var n = n
    while n > 0 {
        var bBar = b
        for i in stride(from: 1, to: bBar.count, by: 2) {
            bBar[i] = (p - b[i]) % p
        }
        let aa = convolution(a: a, b: bBar)
        let bb = convolution(a: b, b: bBar)
        a = [Int](repeating: 0, count: (aa.count + 1) / 2)
        for i in stride(from: n % 2, to: aa.count, by: 2) {
            a[i / 2] = aa[i]
        }
        b = [Int](repeating: 0, count: bb.count / 2)
        for i in stride(from: 0, to: bb.count, by: 2) {
            b[i / 2] = bb[i]
        }
        n /= 2
    }
    let bInv = modInv(x: b[0], mod: p)
    return (a[0] * bInv) % p
}

let nk = readInts()
let n = nk[0]
let k = nk[1]
var ans = [1, 1, 1]
for i in stride(from: k - 1, through: 1, by: -1) {
    let limit = i == 0 ? n : min(k / i, n)
    var c = [Int](repeating: 0, count: ans.count)
    c[0] = 1
    for j in 1..<c.count {
        c[j] = (p - ans[j]) % p //ans[j] == 0を考慮する
    }
    ans = polynomialInverse(c: c, l: limit + 2)
}
var c = [Int](repeating: 0, count: ans.count)
c[0] = 1
for j in 1..<c.count {
    c[j] = (p - ans[j]) % p //ans[j] == 0を考慮する
}

print(bostanMori(a: [1], b: c, n: n + 1))

/*
 k+1の段p(x)とkの段f(x)の掛け算は
 f(x)=1+{(p(x)-1)/x}{f(x)}x
 f(x)=1+(p(x)-1)f(x)
 f(x){1-(p(x)-1)}=1
 f(x){2-p(x)}=1
 f(x)=1/{2-p(x)}
 p(x)の2項目移行をp'(x)とすると
 f(x)=1/{2-(1+p'(x))}
 f(x)=1/{1-p'(x)}
 */
