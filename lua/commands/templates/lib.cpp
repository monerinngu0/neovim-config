/**
 *    author:  ${AUTHOR}
 *    created: ${CREATED}
**/
#include <bits/stdc++.h>
using namespace std;
#ifndef ONLINE_JUDGE
#define _GLIBCXX_DEBUG
#endif
using ll = long long;
template<class T>
istream& operator>>(istream& i, vector<T>& v) {
    for (auto& x : v) {
        i >> x;
    }
    return i;
}
template<class T>
istream& operator>>(istream& i, vector<vector<T>>& v) {
    for (auto& x : v) {
        i >> x;
    }
    return i;
}
template<class T>
ostream& operator<<(ostream& o, const vector<T>& v) {
    for (const auto& x : v) {
        o << x;
        if (&x != &v.back()) {
            o << ' ';
        }
    }
    return o;
}
template<class T>
ostream& operator<<(ostream& o, const vector<vector<T>>& v) {
    for (const auto& x : v) {
        o << x;
        if (&x != &v.back()) {
            o << '\n';
        }
    }
    return o;
}

template <class T, class U>
bool chmax(T& a, U b) {
    if (a < b) {
        a = b;
        return true;
    }
    return false;
}
template <class T, class U>
bool chmin(T& a, U b) {
    if (a > b) {
        a = b;
        return true;
    }
    return false;
}

class UnionFind {
    public:
        explicit UnionFind(int n)
            :m_parent_size(n, -1) {}
        int find(int i) {
            if (m_parent_size[i] < 0) {
                return i;
            }
            return (m_parent_size[i] = find(m_parent_size[i]));
        }
        bool merge(int a, int b) {
            a = find(a);
            b = find(b);
            if (a == b) return false;
            if (m_parent_size[a] > m_parent_size[b]) swap(a, b);
            m_parent_size[a] += m_parent_size[b];
            m_parent_size[b] = a;
            return true;
        }
        bool same(int a, int b) {
            return (find(a) == find(b));
        }
        int size(int i) {
            return -m_parent_size[find(i)];
        }
        vector<vector<int>> groups() {
            int n = m_parent_size.size();
            vector<int> root(n);
            vector<int> group_size(n, 0);
            for (int i = 0; i < n; i++) {
                root[i] = find(i);
                group_size[root[i]]++;
            }
            vector<vector<int>> result(n);
            for (int i = 0; i < n; i++) {
                result[i].reserve(group_size[i]);
            }
            for (int i = 0; i < n; i++) {
                result[root[i]].push_back(i);
            }
            result.erase(
                    remove_if(result.begin(), result.end(),
                        [](const vector<int>& v) { return v.empty(); }),
                    result.end()
                );
            return result;
        }
    private:
        vector<int> m_parent_size;
};

template<class T>
class WeightedUnionFind {
    public:
        explicit WeightedUnionFind(int n)
            :m_parent_size(n ,-1)
            ,m_diff_weight(n, 0) {}

        int find(int i) {
            if (m_parent_size[i] < 0) {
                return i;
            }
            int root = find(m_parent_size[i]);
            m_diff_weight[i] += m_diff_weight[m_parent_size[i]];
            return (m_parent_size[i] = root);
        }
        bool merge(int a, int b, T w) {
            w += weight(a);
            w -= weight(b);
            a = find(a);
            b = find(b);
            if (a == b) return (w == 0);
            if (m_parent_size[a] > m_parent_size[b]) {
                swap(a, b);
                w = -w;
            }
            m_parent_size[a] += m_parent_size[b];
            m_parent_size[b] = a;
            m_diff_weight[b] = w;
            return true;
        }
        T diff(int a, int b) {
            assert(same(a, b));
            return (weight(b) - weight(a));
        }
        bool same(int a, int b) {
            return (find(a) == find(b));
        }
        int size(int i) {
            return -m_parent_size[find(i)];
        }
    private:
        vector<int> m_parent_size;
        vector<T> m_diff_weight;
        T weight(int i) {
            find(i);
            return m_diff_weight[i];
        }
};

template<class T>
class FenwickTree {
    public:
        explicit FenwickTree(int n)
            : _n(n), m_bit(n + 1, 0) {}
        explicit FenwickTree(const vector<T>& v)
            : FenwickTree(static_cast<int>(v.size())) {
                for (int i = 0; i < static_cast<int>(v.size()); ++i) {
                    add(i, v[i]);
                }
            }
        T sum(int r) const {
            assert(r <= _n);
            T res = 0;
            for (; 0 < r; r -= (r & -r)) {
                res += m_bit[r];
            }
            return res;
        }
        T sum(int l, int r) const {
            assert(l <= r && r <= _n);
            return (sum(r) - sum(l));
        }
        void add(int i, T value) {
            assert(i < _n);
            for (++i; i <= _n; i += (i & -i)) {
                m_bit[i] += value;
            }
        }
    private:
        int _n;
        vector<T> m_bit;
};

template<class T>
class FenwickTree_RAQ {
    public:
        explicit FenwickTree_RAQ(int n)
            :m_bit0(n), m_bit1(n), _n(n) {}
        explicit FenwickTree_RAQ(const vector<T>& v)
            :FenwickTree_RAQ(static_cast<int>(v.size())) {
                for (int i = 0; i < static_cast<int>(v.size()); ++i) {
                    add(i, i + 1, v[i]);
                }
            }
        T sum(int r) const {
            return (m_bit0.sum(r) + m_bit1.sum(r) * r);
        }
        T sum(int l, int r) const {
            return (sum(r) - sum(l));
        }
        void add(int l, int r, T value) {
            assert(0 <= l && l <= r && r <= _n);
            m_bit0.add(l, (-value * l));
            m_bit0.add(r, (value * r));
            m_bit1.add(l, value);
            m_bit1.add(r, -value);
        }
    private:
        int _n;
        FenwickTree<T> m_bit0;
        FenwickTree<T> m_bit1;
};

template<class T, auto op, auto e>
class SegTree {
    public:
        explicit SegTree(int n)
            :SegTree(vector<T>(n, e())) {}
        explicit SegTree(const vector<T>& v)
            :_n(static_cast<int>(v.size())) {
                size = bit_ceil(_n);
                log = __builtin_ctz(size);
                d = vector<T>(2 * size, e());
                for (int i = 0; i < _n; ++i) d[size + i] = v[i];
                for (int i = size - 1; 1 <= i; i--) {
                    update(i);
                }
            }
        void set(int r, T val) {
            assert(0 <= r && r < _n);
            r += size;
            d[r] = val;
            while (r >>= 1) {
                update(r);
            }
        }
        T get(int i) const {
            assert(0 <= i && i < _n);
            return d[i + size];
        }
        // [L, R) = L <= x < R , close = [] = <= >= , open = () = < >
        T prod(int l, int r) const {
            assert(0 <= l && l <= r && r <= _n);
            T sml = e(), smr = e();
            l += size;
            r += size;
            while (l < r) {
                if (l & 1) sml = op(sml, d[l++]);
                if (r & 1) smr = op(d[--r], smr);
                l >>= 1;
                r >>= 1;    
            }
            return op(sml, smr);
        }
    private:
        int _n, size, log;
        vector<T> d;
        unsigned int bit_ceil(unsigned int n) {
            unsigned int x = 1;
            while (x < n) x <<= 1;
            return x;
        }
        void update(int k) {
            d[k] = op(d[2 * k], d[2 * k + 1]);
        }
};

void solve() {   
}

int main() {
    ios::sync_with_stdio(false);
    cin.tie(nullptr);
    cout.setf(ios::fixed);
    cout.precision(16);
    
    int T = 1;
    //cin >> T;
    while (T--) solve();
    return 0;
}
