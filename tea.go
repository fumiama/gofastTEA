// Package tea
// from https://github.com/Mrs4s/MiraiGo/blob/master/binary/tea.go
package tea

import (
	"encoding/binary"
	_ "unsafe" // required by go:linkname
)

type TEA [4]uint32

// randuint32 returns a lock free uint32 value.
//go:linkname randuint32 runtime.fastrand
func randuint32() uint32

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
