# gofastTEA
TEA 编码算法的 PLAN9 汇编优化实现

## 1.17 版本及以上
速度已经达到最优，代码与[MiraiGo](https://github.com/Mrs4s/MiraiGo/blob/574c4e57b1467225f03936342e477ee0d587a2dc/binary/tea.go)完全相同。

## 1.16 版本及以下
使用 PLAN9 汇编编写`Encrypt`，内联编写`Decrypt`，与[MiraiGo](https://github.com/Mrs4s/MiraiGo/blob/574c4e57b1467225f03936342e477ee0d587a2dc/binary/tea.go)代码相比，在`1.16`版本下编译提升速度如下（new16.txt）。
```css
name         old time/op    new time/op    delta
TEAen/16-8      252ns ± 0%     240ns ± 1%  -4.50%  (p=0.000 n=9+10)
TEAen/256-8    1.77µs ± 1%    1.67µs ± 1%  -5.66%  (p=0.000 n=9+10)
TEAen/4K-8     25.9µs ± 0%    24.8µs ± 0%  -4.00%  (p=0.000 n=10+9)
TEAen/32K-8     208µs ± 1%     201µs ± 0%  -3.34%  (p=0.000 n=10+10)
TEAde/16-8      216ns ± 1%     211ns ± 1%  -2.68%  (p=0.000 n=10+10)
TEAde/256-8    1.71µs ± 1%    1.66µs ± 1%  -2.69%  (p=0.000 n=10+10)
TEAde/4K-8     25.4µs ± 1%    24.7µs ± 1%  -2.73%  (p=0.000 n=10+10)
TEAde/32K-8     206µs ± 0%     200µs ± 0%  -2.59%  (p=0.000 n=9+10)

name         old speed      new speed      delta
TEAen/16-8   63.5MB/s ± 0%  66.5MB/s ± 1%  +4.70%  (p=0.000 n=9+10)
TEAen/256-8   145MB/s ± 1%   153MB/s ± 1%  +5.98%  (p=0.000 n=9+10)
TEAen/4K-8    158MB/s ± 0%   165MB/s ± 0%  +4.16%  (p=0.000 n=10+9)
TEAen/32K-8   158MB/s ± 1%   163MB/s ± 0%  +3.45%  (p=0.000 n=10+10)
TEAde/16-8    148MB/s ± 1%   152MB/s ± 1%  +2.75%  (p=0.000 n=10+10)
TEAde/256-8   160MB/s ± 1%   164MB/s ± 1%  +2.77%  (p=0.000 n=10+10)
TEAde/4K-8    162MB/s ± 1%   167MB/s ± 1%  +2.80%  (p=0.000 n=10+10)
TEAde/32K-8   159MB/s ± 0%   164MB/s ± 0%  +2.66%  (p=0.000 n=9+10)
```
另外升级到`go1.17`后，即与[MiraiGo](https://github.com/Mrs4s/MiraiGo/blob/574c4e57b1467225f03936342e477ee0d587a2dc/binary/tea.go)代码相同时，在`1.16`版本下编译提升速度如下（new17.txt）。
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
可见在编码时，在某些时候`go1.16`版本下速度比`go1.17`版本更快，而整体来看，在优化后`go1.16`版本下的执行效率已经可以与`go1.17`版本持平。