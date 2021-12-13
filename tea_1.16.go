//go:build (!go1.17 && amd64) || !amd64
// +build !go1.17,amd64 !amd64

package tea

import (
	"encoding/binary"
	_ "unsafe" // required by go:linkname
)

// randuint32 returns a lock free uint32 value.
//go:linkname randuint32 runtime.fastrand
func randuint32() uint32

// Encrypt tea 加密
// http://bbs.chinaunix.net/thread-583468-1-1.html
// 感谢xichen大佬对TEA的解释
//go:nosplit
func (t TEA) EncryptLittleEndian(src []byte, sumtable [0x10]uint32) (dst []byte) {
	lens := len(src)
	fill := 10 - (lens+1)&7
	dst = make([]byte, fill+lens+7)
	binary.LittleEndian.PutUint32(dst, randuint32())
	binary.LittleEndian.PutUint32(dst[4:], randuint32())
	binary.LittleEndian.PutUint32(dst[8:], randuint32())
	dst[0] = byte(fill-3) | 0xF8 // 存储pad长度
	copy(dst[fill:], src)

	var iv1, iv2, holder uint64
	var v0, v1 uint32
	for i := 0; i < len(dst); i += 8 {
		holder = binary.LittleEndian.Uint64(dst[i:]) ^ iv1
		v0, v1 = uint32(holder>>32), uint32(holder)
		for i := 0; i < 0x10; i++ {
			v0 += (v1 + sumtable[i]) ^ ((v1 << 4) + t[0]) ^ ((v1 >> 5) + t[1])
			v1 += (v0 + sumtable[i]) ^ ((v0 << 4) + t[2]) ^ ((v0 >> 5) + t[3])
		}
		iv1 = (uint64(v0)<<32 | uint64(v1)) ^ iv2
		iv2 = holder
		binary.LittleEndian.PutUint64(dst[i:], iv1)
	}

	return dst
}

//go:nosplit
func (t TEA) DecryptLittleEndian(data []byte, sumtable [0x10]uint32) []byte {
	if len(data) < 16 || len(data)&7 != 0 {
		return nil
	}
	dst := make([]byte, len(data))

	var iv1, iv2, holder uint64
	var v0, v1 uint32
	for i := 0; i < len(dst); i += 8 {
		iv1 = binary.LittleEndian.Uint64(data[i:])
		iv2 ^= iv1
		v0, v1 = uint32(iv2>>32), uint32(iv2)
		for i := 0xf; i >= 0; i-- {
			v1 -= (v0 + sumtable[i]) ^ ((v0 << 4) + t[2]) ^ ((v0 >> 5) + t[3])
			v0 -= (v1 + sumtable[i]) ^ ((v1 << 4) + t[0]) ^ ((v1 >> 5) + t[1])
		}
		iv2 = uint64(v0)<<32 | uint64(v1)
		binary.LittleEndian.PutUint64(dst[i:], iv2^holder)
		holder = iv1
	}

	return dst[dst[0]&7+3 : len(data)-7]
}

//go:nosplit
func NewTeaCipher(key []byte) (t TEA) {
	if len(key) == 16 {
		t[3] = binary.BigEndian.Uint32(key[12:])
		t[2] = binary.BigEndian.Uint32(key[8:])
		t[1] = binary.BigEndian.Uint32(key[4:])
		t[0] = binary.BigEndian.Uint32(key[0:])
	}
	return
}

//go:nosplit
func NewTeaCipherLittleEndian(key []byte) (t TEA) {
	if len(key) == 16 {
		t[3] = binary.LittleEndian.Uint32(key[12:])
		t[2] = binary.LittleEndian.Uint32(key[8:])
		t[1] = binary.LittleEndian.Uint32(key[4:])
		t[0] = binary.LittleEndian.Uint32(key[0:])
	}
	return
}
