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
    return [Int](a[0..<l])
}

let nk = readInts()
let n = nk[0]
let k = nk[1]
var dp = [[Int]](repeating: [], count: k + 1)
dp[k] = [1, 1, 1]
for i in stride(from: k - 1, through: 0, by: -1) {
    let limit = i == 0 ? n : min(k / i, n)
    var c = [Int](repeating: 0, count: dp[i + 1].count)
    c[0] = 1
    for j in 1..<c.count {
        c[j] = (p - dp[i + 1][j]) % p //dp[i + 1][j] == 0を考慮する
    }
    dp[i] = polynomialInverse(c: c, l: limit + 2)
}
print(dp[0][n + 1])

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
