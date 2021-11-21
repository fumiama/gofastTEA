//go:build !go1.17 && amd64
// +build !go1.17,amd64

package tea

import (
	"math/rand"
	"unsafe"
)

// implemented in tea_$GOARCH.s
func encrypt(dstlen uintptr, tlen uintptr)
func decrypt(datalen uintptr, dstlen uintptr, t *TEA)

//go:nosplit
func (t TEA) Encrypt(src []byte) (dst []byte) {
	lens := len(src)
	fill := 10 - (lens+1)&7
	dst = make([]byte, fill+lens+7)
	_, _ = rand.Read(dst[0:fill])
	dst[0] = byte(fill-3) | 0xF8 // 存储pad长度
	copy(dst[fill:], src)
	encrypt(uintptr(*(*unsafe.Pointer)(unsafe.Pointer(&dst)))|uintptr(len(dst)<<40), uintptr(unsafe.Pointer(&t))|(uintptr(len(dst))&0xffffff00_00000000))
	return dst
}
