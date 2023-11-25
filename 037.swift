///広い範囲のデータと狭い範囲のデータを両立させる構造
///範囲が1から4のとき、1-4 1-2 3-4 1 2 3 4の7つ範囲のデータを持つ
///1-4のデータをインデックス[1]に収める、以降は上の順番である。(世の中には0から始まるタイプもある。どちらでもよい)
///インデックスkの範囲の左半分はk*2、右半分はk*2+1

///範囲の指定方法は`a..<b`の形。よって連続した部分は前の終了と後の開始が同じ

struct SegmentTree {
    
    let size: Int
    var seg: [Int]
    let firstValue: Int
    let compare: (Int, Int) -> Int //強い方の値を返す
    
    init(n: Int, compare: @escaping (Int, Int) -> Int) {
        var s = 1
        while s < n {
            s *= 2
        }
        size = s
        let fv = compare(Int.max, Int.min) == Int.max ? Int.min : Int.max
        self.firstValue = fv
        self.compare = compare
        
        seg = [Int](repeating: fv, count: s * 2)
    }
    
    ///tl,tr:調べたい範囲
    ///k:範囲を表すインデックス
    ///l,r:そのkが担当する範囲
    private func check(tl: Int, tr: Int, k: Int, l: Int, r: Int) -> Int {
        if tr <= l || r <= tl {
            //重なり部分がないとき
            return firstValue
        }        
        if tl <= l && r <= tr {
            //更新したい範囲が、扱う範囲(kの範囲)を完全に覆っている
            return seg[k]
        }
        let lc = check(tl: tl, tr: tr, k: k * 2, l: l, r: (l + r) / 2)
        let rc = check(tl: tl, tr: tr, k: k * 2 + 1, l: (l + r) / 2, r: r)
        return compare(lc, rc)
    }
    
    mutating func update(pos: Int, x: Int) {
        var p = pos
        p += size
        seg[p] = x
        while (p >= 2) {
            p >>= 1
            seg[p] = compare(seg[p * 2], seg[p * 2 + 1])
        }
    }
    
    func check(tl: Int, tr: Int) -> Int {
        return check(tl: tl, tr: tr, k: 1, l: 0, r: size)
    }
}

//ここから競プロ典型90問の37

func readInts() -> [Int] {
    readLine()!.split(separator: " ").map { Int(String($0))! }
}

let wn = readInts()
let w = wn[0]
let n = wn[1]

var st = SegmentTree(n: w + 1) { max($0, $1) }
st.update(pos: 0, x: 0)

var data = [Int](repeating: Int.min, count: w + 1)
data[0] = 0

for _ in 1...n {
    let lrv = readInts()
    let l = lrv[0]
    let r = lrv[1]
    let v = lrv[2]
    
    for j in 0...w {
        
        //例
        //3から5の香辛料
        //jが10のとき
        //ひとつ前の5から7が対象範囲になる
        
        let preL = j - r
        let preR = j - l + 1 //区間はa..<bの指定をするので+1
        if preR > 0 {
            let maxValue = st.check(tl: max(preL, 0), tr: preR)
            if maxValue != Int.min {
                data[j] = max(data[j], maxValue + v)
            }
        }
    }
    for j in 0...w {
        st.update(pos: j, x: data[j])
    }
}

if data[w] == Int.min {
    print(-1)
} else {
    print(data[w])
}
