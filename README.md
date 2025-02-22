# gofastTEA
TEA 编码算法的优化实现

## 1.17 版本及以上
代码与[MiraiGo](https://github.com/Mrs4s/MiraiGo/blob/574c4e57b1467225f03936342e477ee0d587a2dc/binary/tea.go)相比，替换了随机算法为`runtime.fastrand`，且简化了`Decrypt`，提升速度如下。
```css
name         old time/op    new time/op    delta
TEAen/16-8      241ns ± 1%     225ns ± 1%  -6.97%  (p=0.000 n=9+10)
TEAen/256-8    1.71µs ± 1%    1.68µs ± 1%  -1.31%  (p=0.000 n=10+9)
TEAen/4K-8     25.0µs ± 1%    25.0µs ± 1%    ~     (p=0.497 n=10+9)
TEAen/32K-8     203µs ± 0%     202µs ± 0%    ~     (p=0.079 n=10+9)
TEAde/16-8      208ns ± 1%     208ns ± 0%    ~     (p=0.914 n=9+9)
TEAde/256-8    1.65µs ± 1%    1.65µs ± 1%    ~     (p=0.429 n=9+10)
TEAde/4K-8     24.7µs ± 1%    24.5µs ± 1%  -0.44%  (p=0.026 n=9+10)
TEAde/32K-8     200µs ± 1%     199µs ± 0%  -0.37%  (p=0.001 n=9+9)

name         old speed      new speed      delta
TEAen/16-8   66.3MB/s ± 1%  71.3MB/s ± 1%  +7.50%  (p=0.000 n=9+10)
TEAen/256-8   150MB/s ± 1%   152MB/s ± 1%  +1.31%  (p=0.000 n=10+9)
TEAen/4K-8    164MB/s ± 1%   164MB/s ± 1%    ~     (p=0.497 n=10+9)
TEAen/32K-8   162MB/s ± 0%   162MB/s ± 0%    ~     (p=0.075 n=10+9)
TEAde/16-8    154MB/s ± 1%   154MB/s ± 0%    ~     (p=0.982 n=9+9)
TEAde/256-8   165MB/s ± 1%   165MB/s ± 1%    ~     (p=0.399 n=9+10)
TEAde/4K-8    167MB/s ± 1%   168MB/s ± 1%  +0.44%  (p=0.026 n=9+10)
TEAde/32K-8   164MB/s ± 1%   165MB/s ± 0%  +0.37%  (p=0.001 n=9+9)
```

## 1.16 版本及以下
[MiraiGo](https://github.com/Mrs4s/MiraiGo/blob/574c4e57b1467225f03936342e477ee0d587a2dc/binary/tea.go)本身在`go1.16`版本与在`go1.17`版本下编译相比，提升速度如下。
```css
name         old time/op    new time/op    delta
TEAen/16-8      252ns ± 0%     241ns ± 1%  -4.09%  (p=0.000 n=9+10)
TEAen/256-8    1.77µs ± 1%    1.70µs ± 0%  -3.85%  (p=0.000 n=9+10)
TEAen/4K-8     25.9µs ± 0%    24.9µs ± 1%  -3.59%  (p=0.000 n=10+10)
TEAen/32K-8     208µs ± 1%     200µs ± 1%  -3.78%  (p=0.000 n=10+10)
TEAde/16-8      216ns ± 1%     208ns ± 1%  -3.80%  (p=0.000 n=10+10)
TEAde/256-8    1.71µs ± 1%    1.65µs ± 1%  -3.44%  (p=0.000 n=10+10)
TEAde/4K-8     25.4µs ± 1%    24.5µs ± 0%  -3.40%  (p=0.000 n=10+10)
TEAde/32K-8     206µs ± 0%     199µs ± 0%  -3.36%  (p=0.000 n=9+10)

name         old speed      new speed      delta
TEAen/16-8   63.5MB/s ± 0%  66.3MB/s ± 1%  +4.27%  (p=0.000 n=9+10)
TEAen/256-8   145MB/s ± 1%   150MB/s ± 0%  +4.01%  (p=0.000 n=9+10)
TEAen/4K-8    158MB/s ± 0%   164MB/s ± 1%  +3.73%  (p=0.000 n=10+10)
TEAen/32K-8   158MB/s ± 1%   164MB/s ± 1%  +3.93%  (p=0.000 n=10+10)
TEAde/16-8    148MB/s ± 1%   154MB/s ± 1%  +3.95%  (p=0.000 n=10+10)
TEAde/256-8   160MB/s ± 1%   165MB/s ± 1%  +3.55%  (p=0.000 n=10+10)
TEAde/4K-8    162MB/s ± 1%   168MB/s ± 0%  +3.52%  (p=0.000 n=10+10)
TEAde/32K-8   159MB/s ± 0%   165MB/s ± 0%  +3.45%  (p=0.000 n=9+9)
```
