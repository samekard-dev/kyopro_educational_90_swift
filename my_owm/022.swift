func readIntArray() -> [Int] {
    readLine()!.split(separator: " ").map { Int(String($0))! }
}

let abc = readIntArray().sorted(by: >)
let a = abc[0]
let b = abc[1]
let c = abc[2]

var store: [Int] = [a, b, c]
var l = 0
var r = 2
while l != r {
    let remain = store[l] % store[r]
    if remain != 0 {
        store.append(remain)
        r += 1
    }
    l += 1
}

let gcd = store[r]
print(a / gcd - 1 + b / gcd - 1 + c / gcd - 1)
