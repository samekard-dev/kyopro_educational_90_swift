///広い範囲のデータと狭い範囲のデータを両立させる構造
///範囲が1から4のとき、1-4 1-2 3-4 1 2 3 4の7つ範囲のデータを持つ
///1-4のデータをインデックス[1]に収める、以降は上の順番である。(世の中には0から始まるタイプもある。どちらでもよい)
///インデックスkの範囲の左半分はk*2、右半分はk*2+1

///範囲の指定方法は`a..<b`の形。よって連続した部分は前の終了と後の開始が同じ

///最小値、最大値のどっちが欲しいかは状況によって違うので初期化時に指定する

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

//使用例
//let st = SegmentTree(n: 10000) { max($0, $1) }

