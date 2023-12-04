func readInts() -> [Int] {
    readLine()!.split(separator: " ").map { Int(String($0))! }
}

let tenEighteen = 1_000_000_000_000_000_000

let ab = readInts()
let a = ab[0]
let b = ab[1]

let larger = max(a, b)
let smaller = min(a, b)

func getLCD(_ l: Int, _ s: Int) -> Int {
    if l % s == 0 {
        return s
    } else {
        return getLCD(s, l % s)
    }
}

let lcd = getLCD(larger, smaller)

let c = a / lcd

/*
 a = lcd * c
 b = lcd * d
 c = a / lcd
 */

//b*cがtenEighteenを超えるならtenEighteen/cはbより下
if b <= tenEighteen / c {
    print(b * c)
} else {
    print("Large")
}

