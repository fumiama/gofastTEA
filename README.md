# gofastTEA
TEA 编码算法的 PLAN9 汇编优化实现

## 1.17 版本及以上
代码与[MiraiGo](https://github.com/Mrs4s/MiraiGo/blob/574c4e57b1467225f03936342e477ee0d587a2dc/binary/tea.go)相比，替换了加密算法为`runtime.fastrand`，提升速度如下。
```css
name         old time/op    new time/op    delta
TEAen/16-8      241ns ± 1%     224ns ± 1%  -7.05%  (p=0.000 n=9+9)
TEAen/256-8    1.71µs ± 1%    1.69µs ± 1%  -0.96%  (p=0.000 n=10+10)
TEAen/4K-8     25.0µs ± 1%    24.9µs ± 1%    ~     (p=0.052 n=10+10)
TEAen/32K-8     203µs ± 0%     202µs ± 0%  -0.44%  (p=0.003 n=10+10)
TEAde/16-8      208ns ± 1%     208ns ± 0%    ~     (p=0.857 n=9+10)
TEAde/256-8    1.65µs ± 1%    1.65µs ± 1%    ~     (p=0.859 n=9+10)
TEAde/4K-8     24.7µs ± 1%    24.6µs ± 1%    ~     (p=0.133 n=9+10)
TEAde/32K-8     200µs ± 1%     199µs ± 0%    ~     (p=0.243 n=9+10)

name         old speed      new speed      delta
TEAen/16-8   66.3MB/s ± 1%  71.3MB/s ± 1%  +7.59%  (p=0.000 n=9+9)
TEAen/256-8   150MB/s ± 1%   151MB/s ± 1%  +0.97%  (p=0.000 n=10+10)
TEAen/4K-8    164MB/s ± 1%   164MB/s ± 1%    ~     (p=0.052 n=10+10)
TEAen/32K-8   162MB/s ± 0%   163MB/s ± 0%  +0.44%  (p=0.003 n=10+10)
TEAde/16-8    154MB/s ± 1%   154MB/s ± 0%    ~     (p=0.905 n=9+10)
TEAde/256-8   165MB/s ± 1%   165MB/s ± 1%    ~     (p=0.905 n=9+10)
TEAde/4K-8    167MB/s ± 1%   167MB/s ± 1%    ~     (p=0.133 n=9+10)
TEAde/32K-8   164MB/s ± 1%   165MB/s ± 0%    ~     (p=0.218 n=9+10)
```

## 1.16 版本及以下
使用 PLAN9 汇编编写`Encrypt`，内联编写`Decrypt`，替换了加密算法为`runtime.fastrand`，与[MiraiGo](https://github.com/Mrs4s/MiraiGo/blob/574c4e57b1467225f03936342e477ee0d587a2dc/binary/tea.go)代码同在`go1.16`版本下编译相比，提升速度如下（new16.txt）。
```css
name         old time/op    new time/op    delta
TEAen/16-8      252ns ± 0%     224ns ± 0%  -10.85%  (p=0.000 n=9+8)
TEAen/256-8    1.77µs ± 1%    1.67µs ± 1%   -5.92%  (p=0.000 n=9+9)
TEAen/4K-8     25.9µs ± 0%    24.9µs ± 0%   -3.83%  (p=0.000 n=10+9)
TEAen/32K-8     208µs ± 1%     201µs ± 0%   -3.20%  (p=0.000 n=10+9)
TEAde/16-8      216ns ± 1%     211ns ± 1%   -2.41%  (p=0.000 n=10+10)
TEAde/256-8    1.71µs ± 1%    1.66µs ± 1%   -2.40%  (p=0.000 n=10+10)
TEAde/4K-8     25.4µs ± 1%    24.8µs ± 1%   -2.16%  (p=0.000 n=10+10)
TEAde/32K-8     206µs ± 0%     201µs ± 0%   -2.35%  (p=0.000 n=9+9)

name         old speed      new speed      delta
TEAen/16-8   63.5MB/s ± 0%  71.3MB/s ± 0%  +12.18%  (p=0.000 n=9+8)
TEAen/256-8   145MB/s ± 1%   154MB/s ± 1%   +6.28%  (p=0.000 n=9+9)
TEAen/4K-8    158MB/s ± 0%   165MB/s ± 0%   +3.98%  (p=0.000 n=10+9)
TEAen/32K-8   158MB/s ± 1%   163MB/s ± 0%   +3.31%  (p=0.000 n=10+9)
TEAde/16-8    148MB/s ± 1%   152MB/s ± 1%   +2.46%  (p=0.000 n=10+10)
TEAde/256-8   160MB/s ± 1%   163MB/s ± 1%   +2.46%  (p=0.000 n=10+10)
TEAde/4K-8    162MB/s ± 1%   166MB/s ± 1%   +2.21%  (p=0.000 n=10+10)
TEAde/32K-8   159MB/s ± 0%   163MB/s ± 0%   +2.41%  (p=0.000 n=9+9)
```
另外[MiraiGo](https://github.com/Mrs4s/MiraiGo/blob/574c4e57b1467225f03936342e477ee0d587a2dc/binary/tea.go)本身在`go1.16`版本与在`go1.17`版本下编译相比，提升速度如下（new17.txt）。
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
可见在编码时，在`go1.16`版本下的某些时候（编码大小在`0-16kb`之间），`gofastTEA`比`go1.17`版本的`MiraiGo`实现更快，且整体来看，`gofastTEA`在`go1.16`版本下的执行效率已经可以与`MiraiGo`实现的`go1.17`版本基本持平。