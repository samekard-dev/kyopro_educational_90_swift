struct Point {
    var x: Int
    var y: Int
}

func +(left: Point, right: Point) -> Point {
    Point(x: left.x + right.x, y: left.y + right.y)
}

func -(left: Point, right: Point) -> Point {
    Point(x: left.x - right.x, y: left.y - right.y)
}

func *(left: Point, right: Point) -> Int {
    //ここでは内積は使わないので外積に*を使う
    //視覚的にはrightを時計回りに90度動かして内積を計算するのと同じ
    left.x * right.y - left.y * right.x
}

func <(left: Point, right: Point) -> Bool {
    if left.x != right.x {
        return right.x > left.x
    } else {
        return right.y > left.y
    }
}

func gcd(a: Int, b: Int) -> Int {
    if b == 0 {
        return a
    }
    return gcd(a: b, b: a % b)
}

func readInt() -> Int {
    Int(readLine()!)!
}

func readInts() -> [Int] {
    readLine()!.split(separator: " ").map { Int(String($0))! }
}

let n = readInt()

var p: [Point] = []
for _ in 0..<n {
    let i = readInts()
    p.append(Point(x: i[0], y: i[1]))
}

p.sort(by: <)

//上ライン、下ラインを求める

var topLine: [Point] = []
var bottomLine: [Point] = []

topLine.append(contentsOf: [p[0], p[1]])
bottomLine.append(contentsOf: [p[0], p[1]])

for i in 2..<n {
    while topLine.count >= 2 {
        let last = topLine.count - 1
        if (topLine[last] - topLine[last - 1]) * (p[i] - topLine[last]) >= 0 {
            //vの形
            topLine.removeLast()
        } else {
            break
        }
    }
    topLine.append(p[i])
    while bottomLine.count >= 2 {
        let last = bottomLine.count - 1
        if (bottomLine[last] - bottomLine[last - 1]) * (p[i] - bottomLine[last]) <= 0 {
            //への形
            bottomLine.removeLast()
        } else {
            break
        }
    }
    bottomLine.append(p[i])
}

var circle = topLine
for i in stride(from: bottomLine.count - 2, through: 1, by: -1) {
    circle.append(bottomLine[i])
}

//辺上の格子点の数を求める
var b = 0
for i in 0..<circle.count {
    let dx = circle[(i + 1) % circle.count].x - circle[i].x
    let dy = circle[(i + 1) % circle.count].y - circle[i].y
    b += gcd(a: abs(dx), b: abs(dy))
}

//面積を求める
var area2 = 0
for i in 0..<circle.count {
    let dx = circle[(i + 1) % circle.count].x - circle[i].x
    let sumY = circle[(i + 1) % circle.count].y + circle[i].y
    area2 += dx * sumY
}

/*
 S = i + b / 2 - 1 ピックの定理 S:面積 i:内部の点 b:輪郭上の点
 2S = 2i + b - 2
 2S = 2i + 2b - b - 2
 2i + 2b = 2S + b + 2
 i + b = (2S + b + 2) / 2
 */

print((area2 + b + 2) / 2 - n)

