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

//**************************************************
// ここから使用例
//**************************************************

/*

func readInts() -> [Int] {
    readLine()!.split(separator: " ").map { Int(String($0))! }
}

func main() {
    let na = readInt()
    let nb = readInt()
    
    // a は A(x) の係数を次数の小さい順に並べたもの． b は B(x) の係数を次数の小さい順に並べたもの．
    var a = readInts()
    var b = readInts()
    
    // convolution 関数で A(x) と B(x) の多項式乗算を行い，C(x) = A(x) * B(x) の係数を小さい順に並べた配列 c を返す．
    let c: [Int] = convolution(a: a, b: b)
    for i in 0..<na + nb - 1 {
        print(c[i])
    }
}

*/

