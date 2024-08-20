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

