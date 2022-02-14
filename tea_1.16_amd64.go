//go:build !go1.17 && amd64
// +build !go1.17,amd64

package tea

import (
	"encoding/binary"
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
	binary.LittleEndian.PutUint32(dst, randuint32())
	binary.LittleEndian.PutUint32(dst[4:], randuint32())
	binary.LittleEndian.PutUint32(dst[8:], randuint32())
	dst[0] = byte(fill-3) | 0xF8 // 存储pad长度
	copy(dst[fill:], src)
	encrypt(uintptr(*(*unsafe.Pointer)(unsafe.Pointer(&dst)))|uintptr(len(dst)<<40), uintptr(unsafe.Pointer(&t))|(uintptr(len(dst)<<16)&0xffffff00_00000000))
	return dst
}

//go:nosplit
func (t TEA) EncryptTo(src []byte, dst []byte) int {
	lens := len(src)
	fill := 10 - (lens+1)&7
	binary.LittleEndian.PutUint32(dst, randuint32())
	binary.LittleEndian.PutUint32(dst[4:], randuint32())
	binary.LittleEndian.PutUint32(dst[8:], randuint32())
	dst[0] = byte(fill-3) | 0xF8 // 存储pad长度
	copy(dst[fill:], src)
	dstlen := fill + lens + 7
	encrypt(uintptr(*(*unsafe.Pointer)(unsafe.Pointer(&dst)))|uintptr(dstlen<<40), uintptr(unsafe.Pointer(&t))|(uintptr(dstlen<<16)&0xffffff00_00000000))
	return dstlen
}

/*
//go:nosplit
func (t TEA) Decrypt(data []byte) []byte {
	if len(data) < 16 || len(data)&7 != 0 {
		return nil
	}
	dst := make([]byte, len(data))
	decrypt(uintptr(*(*unsafe.Pointer)(unsafe.Pointer(&data)))|uintptr(len(data)<<40), uintptr(*(*unsafe.Pointer)(unsafe.Pointer(&dst)))|(uintptr(len(data)<<16)&0xffffff00_00000000), &t)
	return dst[dst[0]&7+3 : len(dst)-7]
}
*/
