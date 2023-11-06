///広い範囲のデータと狭い範囲のデータを両立させる構造
///範囲が1から4のとき、1-4 1-2 3-4 1 2 3 4の7つ範囲のデータを持つ
///1-4のデータをインデックス[1]に収める、以降は上の順番である。(世の中には0から始まるタイプもある。どちらでもよい)
///インデックスkの範囲の左半分はk*2、右半分はk*2+1

///範囲が1-4 1-2 3-4 1 2 3 4の7つのとき
///(このプログラムでは)1-4側を「上」、1 2 3 4側を「下」と表現する

///名前のLazyとは何か
///書き込み処理(実行したら量が多い)を必要が生じるまで先送りにする
///lazy[k]がinvalid以外の場合、本来はその範囲全部(下のものも含めて)がlazy[k]の値であるべきだが
///書き込み処理が保留されている状態である

///最小値、最大値のどっちが欲しいかは状況によって違うので初期化時に指定する
///中に入れる値は0以上を想定している
///最大値が欲しいとき
///     最強 Int.max
///     最弱(デフォルト値) 0
///     -1　特殊な意味
///最小値が欲しいとき
///     最弱(デフォルト値) Int.max
///     最強 0
///     -1 特殊な意味

class LazySegmentTree {
    
    static let invalid = -1

    let size: Int
    var seg: [Int]
    var lazy: [Int]
    let firstValue: Int
    let compare: (Int, Int) -> Int
    
    init(n: Int, compare: @escaping (Int, Int) -> Int) {
        var s = 1
        while s < n {
            s *= 2
        }
        size = s
        let fv = Int.max - compare(Int.max, 0)
        self.firstValue = fv
        self.compare = compare

        seg = [Int](repeating: fv, count: s * 2)
        lazy = [Int](repeating: LazySegmentTree.invalid, count: s * 2)
    }
    
    private func settleLazy(_ k: Int) {
        //kの範囲に未処理データ(lazy[k]がinvalid以外)がある場合、自分の場所(k)のみ確定させる
        guard lazy[k] != LazySegmentTree.invalid else {
            return
        }
        if k < size {
            lazy[k * 2] = lazy[k]
            lazy[k * 2 + 1] = lazy[k]
        }
        seg[k] = lazy[k]
        lazy[k] = LazySegmentTree.invalid
    }
    
    ///tl,tr:更新したい範囲
    ///x:更新したい値
    ///k:範囲を表すインデックス
    ///l,r:そのkが担当する範囲
    private func update(tl: Int, tr: Int, x: Int, k: Int, l: Int, r: Int) {
        settleLazy(k)
        if tr <= l || r <= tl {
            //重なり部分がないとき
            return
        }
        if tl <= l && r <= tr {
            //更新したい範囲が、扱う範囲(kの範囲)を完全に覆っている
            //kの範囲はsegが決定する。下に対してlazyを書き込む
            lazy[k] = x
            settleLazy(k)
            return
        }
        update(tl: tl, tr: tr, x: x, k: k * 2, l: l, r: (l + r) / 2)
        update(tl: tl, tr: tr, x: x, k: k * 2 + 1, l: (l + r) / 2, r: r)
        seg[k] = compare(seg[k * 2], seg[k * 2 + 1])
    }
    
    ///tl,tr:調べたい範囲
    ///k:範囲を表すインデックス
    ///l,r:そのkが担当する範囲
    private func check(tl: Int, tr: Int, k: Int, l: Int, r: Int) -> Int {
        settleLazy(k)     
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
    
    func update(tl: Int, tr: Int, x: Int) {
        update(tl: tl, tr: tr, x: x, k: 1, l: 0, r: size)
    }
    
    func check(tl: Int, tr: Int) -> Int {
        return check(tl: tl, tr: tr, k: 1, l: 0, r: size)
    }
}

//使用例
//let lst = LazySegmentTree(n: 10000) { max($0, $1) }
