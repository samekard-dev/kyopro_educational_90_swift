import Foundation

func readInt() -> Int {
	Int(readLine()!)!
}

func readIntArray() -> [Int] {
	readLine()!.split(separator: " ").map { Int(String($0))! }
}

let nq = readIntArray()
let n = nq[0]
let q = nq[1]
//以下の4本の斜めの線で全体を最小面積で囲む
var lineTR = -Double.greatestFiniteMagnitude //top right
var lineBL = Double.greatestFiniteMagnitude //bottom left
var lineTL = -Double.greatestFiniteMagnitude //top left
var lineBR = Double.greatestFiniteMagnitude //bottom right

var dots: [(x: Double, y: Double)] = [(x: 0.0, y: 0.0)] //1から始まるので0の分を追加しておく
for _ in 1...n {
	let xy = readIntArray()
	let x = Double(xy[0])
	let y = Double(xy[1])
	dots.append((x: x, y: y))
	let xPy = x + y
	let yMx = y - x
	if xPy > lineTR {
		lineTR = xPy
	}
	if xPy < lineBL {
		lineBL = xPy
	}
	if yMx > lineTL {
		lineTL = yMx
	}
	if yMx < lineBR {
		lineBR = yMx
	}
}

func crossPoint(xPy: Double, yMx: Double) -> (x: Double, y: Double) {
	
	/*
	 x + y = xPy
	 y - x = yMx
	 2x = xPy - yMx
	 2y = xPy + yMx
	 */
	
	return (x: (xPy - yMx) / 2.0, y: (xPy + yMx) / 2.0)
}

let (tx, ty) = crossPoint(xPy: lineTR, yMx: lineTL)
let (bx, by) = crossPoint(xPy: lineBL, yMx: lineBR)
let (rx, ry) = crossPoint(xPy: lineTR, yMx: lineBR)
let (lx, ly) = crossPoint(xPy: lineBL, yMx: lineTL)

if lineTR - lineBL >= lineTL - lineBR {
	//正方形、あるいはスラッシュ方向に長い
	for _ in 1...q {
		let q = readInt()
		var ans = 0.0 
		if dots[q].x >= tx && dots[q].y <= ly {
			//lineTLが遠い
			ans = lineTL - (dots[q].y - dots[q].x)
		} else if dots[q].x <= bx && dots[q].y >= ry {
			//lineBRが遠い
			ans = (dots[q].y - dots[q].x) - lineBR
		} else if dots[q].x + dots[q].y >= (lineTR + lineBL) / 2.0 {
			//lineBLが遠い
			ans = (dots[q].x + dots[q].y) - lineBL
		} else {
			//lineTRが遠い
			ans = lineTR - (dots[q].x + dots[q].y)
		}
		print(Int(ans))
	}
} else {
	//バックスラッシュ方向に長い
	for _ in 1...q {
		let q = readInt()
		var ans = 0.0 
		if dots[q].x <= tx && dots[q].y <= ry {
			//lineTRが遠い
			ans = lineTR - (dots[q].x + dots[q].y)
		} else if dots[q].x >= bx && dots[q].y >= ly {
			//lineBLが遠い
			ans = (dots[q].x + dots[q].y) - lineBL
		} else if dots[q].y - dots[q].x >= (lineTL + lineBR) / 2.0 {
			//lineBRが遠い
			ans = (dots[q].y - dots[q].x) - lineBR
		} else {
			//lineTLが遠い
			ans = lineTL - (dots[q].y - dots[q].x)
		}
		print(Int(ans))
	}
}
