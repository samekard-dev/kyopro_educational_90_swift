/*
056は答が複数ある問題で、運営からすべての正解が出されていないので
自分で確かめる用のプログラム

3 34
3 14
15 9
26 5
BAB

の様に入力する
*/

func readInts() -> [Int] {
    readLine()!.split(separator: " ").map { Int(String($0))! }
}

let ns = readInts()
let n = ns[0]
let s = ns[1]
var a = [Int](repeating: 0, count: n)
var b = [Int](repeating: 0, count: n)
for i in 0..<n {
    let ab = readInts()
    a[i] = ab[0]
    b[i] = ab[1]
}

let answer = Array(readLine()!)
var total = 0
for i in 0..<n {
    switch answer[i] {
        case "A":
            total += a[i]
        case "B":
            total += b[i]
        default:
            break
    }
}

print("")
print("**************************************")
print("")

if total == s {
    print("Your answer is correct.")
} else {
    print("Your answer is wrong.")
}

print("")
print("**************************************")
print("")
