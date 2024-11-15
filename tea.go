// Package tea
// from https://github.com/Mrs4s/MiraiGo/blob/master/binary/tea.go
package tea

import (
	"encoding/binary"
)

type TEA [4]uint32

//go:nosplit
func NewTeaCipher(key []byte) (t TEA) {
	if len(key) == 16 {
		t[3] = binary.BigEndian.Uint32(key[12:16])
		t[2] = binary.BigEndian.Uint32(key[8:12])
		t[1] = binary.BigEndian.Uint32(key[4:8])
		t[0] = binary.BigEndian.Uint32(key[0:4])
	}
	return
}

//go:nosplit
func NewTeaCipherLittleEndian(key []byte) (t TEA) {
	if len(key) == 16 {
		t[3] = binary.LittleEndian.Uint32(key[12:16])
		t[2] = binary.LittleEndian.Uint32(key[8:12])
		t[1] = binary.LittleEndian.Uint32(key[4:8])
		t[0] = binary.LittleEndian.Uint32(key[0:4])
	}
	return
}

func (t TEA) ToBytes() []byte {
	var buf [16]byte
	binary.BigEndian.PutUint32(buf[0:4], t[0])
	binary.BigEndian.PutUint32(buf[4:8], t[1])
	binary.BigEndian.PutUint32(buf[8:12], t[2])
	binary.BigEndian.PutUint32(buf[12:16], t[3])
	return buf[:]
}

func (t TEA) ToBytesLittleEndian() []byte {
	var buf [16]byte
	binary.LittleEndian.PutUint32(buf[0:4], t[0])
	binary.LittleEndian.PutUint32(buf[4:8], t[1])
	binary.LittleEndian.PutUint32(buf[8:12], t[2])
	binary.LittleEndian.PutUint32(buf[12:16], t[3])
	return buf[:]
}
