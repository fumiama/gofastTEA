//go:build (!go1.17 && amd64) || !amd64
// +build !go1.17,amd64 !amd64

package tea

import (
	"encoding/binary"
	_ "unsafe" // required by go:linkname
)

// Uint32 returns a lock free uint32 value.
//go:linkname Uint32 runtime.fastrand
func Uint32() uint32

// Encrypt tea 加密
// http://bbs.chinaunix.net/thread-583468-1-1.html
// 感谢xichen大佬对TEA的解释

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
