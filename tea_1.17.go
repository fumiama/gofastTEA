//go:build go1.17 && amd64
// +build go1.17,amd64

package tea

import "encoding/binary"

// Encrypt tea 加密
// http://bbs.chinaunix.net/thread-583468-1-1.html
// 感谢xichen大佬对TEA的解释
func (t TEA) Encrypt(src []byte) (dst []byte) {
	lens := len(src)
	fill := 10 - (lens+1)%8
	dst = make([]byte, fill+lens+7)
	binary.LittleEndian.PutUint32(dst, randuint32())
	binary.LittleEndian.PutUint32(dst[4:], randuint32())
	binary.LittleEndian.PutUint32(dst[8:], randuint32())
	dst[0] = byte(fill-3) | 0xF8 // 存储pad长度
	copy(dst[fill:], src)

	var iv1, iv2, holder uint64
	for i := 0; i < len(dst); i += 8 {
		block := binary.BigEndian.Uint64(dst[i:])
		holder = block ^ iv1
		iv1 = t.encode(holder)
		iv1 = iv1 ^ iv2
		iv2 = holder
		binary.BigEndian.PutUint64(dst[i:], iv1)
	}

	return dst
}

func (t TEA) EncryptTo(src []byte, dst []byte) int {
	lens := len(src)
	fill := 10 - (lens+1)%8
	binary.LittleEndian.PutUint32(dst, randuint32())
	binary.LittleEndian.PutUint32(dst[4:], randuint32())
	binary.LittleEndian.PutUint32(dst[8:], randuint32())
	dst[0] = byte(fill-3) | 0xF8 // 存储pad长度
	copy(dst[fill:], src)

	var iv1, iv2, holder uint64
	for i := 0; i < fill+lens+7; i += 8 {
		block := binary.BigEndian.Uint64(dst[i:])
		holder = block ^ iv1
		iv1 = t.encode(holder)
		iv1 = iv1 ^ iv2
		iv2 = holder
		binary.BigEndian.PutUint64(dst[i:], iv1)
	}

	return fill + lens + 7
}

func (t TEA) EncryptLittleEndian(src []byte, sumtable [0x10]uint32) (dst []byte) {
	lens := len(src)
	fill := 10 - (lens+1)%8
	dst = make([]byte, fill+lens+7)
	binary.LittleEndian.PutUint32(dst, randuint32())
	binary.LittleEndian.PutUint32(dst[4:], randuint32())
	binary.LittleEndian.PutUint32(dst[8:], randuint32())
	dst[0] = byte(fill-3) | 0xF8 // 存储pad长度
	copy(dst[fill:], src)

	var iv1, iv2, holder uint64
	for i := 0; i < len(dst); i += 8 {
		block := binary.LittleEndian.Uint64(dst[i:])
		holder = block ^ iv1
		iv1 = t.encodeTable(holder, sumtable)
		iv1 = iv1 ^ iv2
		iv2 = holder
		binary.LittleEndian.PutUint64(dst[i:], iv1)
	}

	return dst
}

func (t TEA) EncryptLittleEndianTo(src []byte, sumtable [0x10]uint32, dst []byte) int {
	lens := len(src)
	fill := 10 - (lens+1)%8
	binary.LittleEndian.PutUint32(dst, randuint32())
	binary.LittleEndian.PutUint32(dst[4:], randuint32())
	binary.LittleEndian.PutUint32(dst[8:], randuint32())
	dst[0] = byte(fill-3) | 0xF8 // 存储pad长度
	copy(dst[fill:], src)

	var iv1, iv2, holder uint64
	for i := 0; i < fill+lens+7; i += 8 {
		block := binary.LittleEndian.Uint64(dst[i:])
		holder = block ^ iv1
		iv1 = t.encodeTable(holder, sumtable)
		iv1 = iv1 ^ iv2
		iv2 = holder
		binary.LittleEndian.PutUint64(dst[i:], iv1)
	}

	return fill + lens + 7
}

func (t TEA) Decrypt(data []byte) []byte {
	if len(data) < 16 || len(data)%8 != 0 {
		return nil
	}
	dst := make([]byte, len(data))
	var iv1, iv2, holder uint64
	for i := 0; i < len(dst); i += 8 {
		iv1 = binary.BigEndian.Uint64(data[i:])
		iv2 ^= iv1
		iv2 = t.decode(iv2)
		binary.BigEndian.PutUint64(dst[i:], iv2^holder)
		holder = iv1
	}
	return dst[dst[0]&7+3 : len(data)-7]
}

func (t TEA) DecryptTo(data []byte, dst []byte) (from, to int) {
	if len(data) < 16 || len(data)%8 != 0 {
		return -1, -1
	}
	var iv1, iv2, holder uint64
	for i := 0; i < len(data); i += 8 {
		iv1 = binary.BigEndian.Uint64(data[i:])
		iv2 ^= iv1
		iv2 = t.decode(iv2)
		binary.BigEndian.PutUint64(dst[i:], iv2^holder)
		holder = iv1
	}
	return int(dst[0]&7 + 3), len(data) - 7
}

func (t TEA) DecryptLittleEndian(data []byte, sumtable [0x10]uint32) []byte {
	if len(data) < 16 || len(data)%8 != 0 {
		return nil
	}
	dst := make([]byte, len(data))
	var iv1, iv2, holder uint64
	for i := 0; i < len(dst); i += 8 {
		iv1 = binary.LittleEndian.Uint64(data[i:])
		iv2 ^= iv1
		iv2 = t.decodeTable(iv2, sumtable)
		binary.LittleEndian.PutUint64(dst[i:], iv2^holder)
		holder = iv1
	}
	return dst[dst[0]&7+3 : len(data)-7]
}

func (t TEA) DecryptLittleEndianTo(data []byte, sumtable [0x10]uint32, dst []byte) (from, to int) {
	if len(data) < 16 || len(data)%8 != 0 {
		return -1, -1
	}
	var iv1, iv2, holder uint64
	for i := 0; i < len(data); i += 8 {
		iv1 = binary.LittleEndian.Uint64(data[i:])
		iv2 ^= iv1
		iv2 = t.decodeTable(iv2, sumtable)
		binary.LittleEndian.PutUint64(dst[i:], iv2^holder)
		holder = iv1
	}
	return int(dst[0]&7 + 3), len(data) - 7
}

//go:nosplit
func (t *TEA) encode(n uint64) uint64 {
	v0, v1 := uint32(n>>32), uint32(n)
	t0, t1, t2, t3 := t[0], t[1], t[2], t[3]

	v0 += (v1 + 0x9e3779b9) ^ ((v1 << 4) + t0) ^ ((v1 >> 5) + t1)
	v1 += (v0 + 0x9e3779b9) ^ ((v0 << 4) + t2) ^ ((v0 >> 5) + t3)
	v0 += (v1 + 0x3c6ef372) ^ ((v1 << 4) + t0) ^ ((v1 >> 5) + t1)
	v1 += (v0 + 0x3c6ef372) ^ ((v0 << 4) + t2) ^ ((v0 >> 5) + t3)
	v0 += (v1 + 0xdaa66d2b) ^ ((v1 << 4) + t0) ^ ((v1 >> 5) + t1)
	v1 += (v0 + 0xdaa66d2b) ^ ((v0 << 4) + t2) ^ ((v0 >> 5) + t3)
	v0 += (v1 + 0x78dde6e4) ^ ((v1 << 4) + t0) ^ ((v1 >> 5) + t1)
	v1 += (v0 + 0x78dde6e4) ^ ((v0 << 4) + t2) ^ ((v0 >> 5) + t3)
	v0 += (v1 + 0x1715609d) ^ ((v1 << 4) + t0) ^ ((v1 >> 5) + t1)
	v1 += (v0 + 0x1715609d) ^ ((v0 << 4) + t2) ^ ((v0 >> 5) + t3)
	v0 += (v1 + 0xb54cda56) ^ ((v1 << 4) + t0) ^ ((v1 >> 5) + t1)
	v1 += (v0 + 0xb54cda56) ^ ((v0 << 4) + t2) ^ ((v0 >> 5) + t3)
	v0 += (v1 + 0x5384540f) ^ ((v1 << 4) + t0) ^ ((v1 >> 5) + t1)
	v1 += (v0 + 0x5384540f) ^ ((v0 << 4) + t2) ^ ((v0 >> 5) + t3)
	v0 += (v1 + 0xf1bbcdc8) ^ ((v1 << 4) + t0) ^ ((v1 >> 5) + t1)
	v1 += (v0 + 0xf1bbcdc8) ^ ((v0 << 4) + t2) ^ ((v0 >> 5) + t3)
	v0 += (v1 + 0x8ff34781) ^ ((v1 << 4) + t0) ^ ((v1 >> 5) + t1)
	v1 += (v0 + 0x8ff34781) ^ ((v0 << 4) + t2) ^ ((v0 >> 5) + t3)
	v0 += (v1 + 0x2e2ac13a) ^ ((v1 << 4) + t0) ^ ((v1 >> 5) + t1)
	v1 += (v0 + 0x2e2ac13a) ^ ((v0 << 4) + t2) ^ ((v0 >> 5) + t3)
	v0 += (v1 + 0xcc623af3) ^ ((v1 << 4) + t0) ^ ((v1 >> 5) + t1)
	v1 += (v0 + 0xcc623af3) ^ ((v0 << 4) + t2) ^ ((v0 >> 5) + t3)
	v0 += (v1 + 0x6a99b4ac) ^ ((v1 << 4) + t0) ^ ((v1 >> 5) + t1)
	v1 += (v0 + 0x6a99b4ac) ^ ((v0 << 4) + t2) ^ ((v0 >> 5) + t3)
	v0 += (v1 + 0x08d12e65) ^ ((v1 << 4) + t0) ^ ((v1 >> 5) + t1)
	v1 += (v0 + 0x08d12e65) ^ ((v0 << 4) + t2) ^ ((v0 >> 5) + t3)
	v0 += (v1 + 0xa708a81e) ^ ((v1 << 4) + t0) ^ ((v1 >> 5) + t1)
	v1 += (v0 + 0xa708a81e) ^ ((v0 << 4) + t2) ^ ((v0 >> 5) + t3)
	v0 += (v1 + 0x454021d7) ^ ((v1 << 4) + t0) ^ ((v1 >> 5) + t1)
	v1 += (v0 + 0x454021d7) ^ ((v0 << 4) + t2) ^ ((v0 >> 5) + t3)
	v0 += (v1 + 0xe3779b90) ^ ((v1 << 4) + t0) ^ ((v1 >> 5) + t1)
	v1 += (v0 + 0xe3779b90) ^ ((v0 << 4) + t2) ^ ((v0 >> 5) + t3)

	return uint64(v0)<<32 | uint64(v1)
}

//go:nosplit
func (t *TEA) encodeTable(n uint64, s [0x10]uint32) uint64 {
	v0, v1 := uint32(n>>32), uint32(n)
	t0, t1, t2, t3 := t[0], t[1], t[2], t[3]

	for i := 0; i < 0x10; i++ {
		v0 += (v1 + s[i]) ^ ((v1 << 4) + t0) ^ ((v1 >> 5) + t1)
		v1 += (v0 + s[i]) ^ ((v0 << 4) + t2) ^ ((v0 >> 5) + t3)
	}

	return uint64(v0)<<32 | uint64(v1)
}

// 每次8字节
//go:nosplit
func (t *TEA) decode(n uint64) uint64 {
	v0, v1 := uint32(n>>32), uint32(n)
	t0, t1, t2, t3 := t[0], t[1], t[2], t[3]

	v1 -= (v0 + 0xe3779b90) ^ ((v0 << 4) + t2) ^ ((v0 >> 5) + t3)
	v0 -= (v1 + 0xe3779b90) ^ ((v1 << 4) + t0) ^ ((v1 >> 5) + t1)
	v1 -= (v0 + 0x454021d7) ^ ((v0 << 4) + t2) ^ ((v0 >> 5) + t3)
	v0 -= (v1 + 0x454021d7) ^ ((v1 << 4) + t0) ^ ((v1 >> 5) + t1)
	v1 -= (v0 + 0xa708a81e) ^ ((v0 << 4) + t2) ^ ((v0 >> 5) + t3)
	v0 -= (v1 + 0xa708a81e) ^ ((v1 << 4) + t0) ^ ((v1 >> 5) + t1)
	v1 -= (v0 + 0x08d12e65) ^ ((v0 << 4) + t2) ^ ((v0 >> 5) + t3)
	v0 -= (v1 + 0x08d12e65) ^ ((v1 << 4) + t0) ^ ((v1 >> 5) + t1)
	v1 -= (v0 + 0x6a99b4ac) ^ ((v0 << 4) + t2) ^ ((v0 >> 5) + t3)
	v0 -= (v1 + 0x6a99b4ac) ^ ((v1 << 4) + t0) ^ ((v1 >> 5) + t1)
	v1 -= (v0 + 0xcc623af3) ^ ((v0 << 4) + t2) ^ ((v0 >> 5) + t3)
	v0 -= (v1 + 0xcc623af3) ^ ((v1 << 4) + t0) ^ ((v1 >> 5) + t1)
	v1 -= (v0 + 0x2e2ac13a) ^ ((v0 << 4) + t2) ^ ((v0 >> 5) + t3)
	v0 -= (v1 + 0x2e2ac13a) ^ ((v1 << 4) + t0) ^ ((v1 >> 5) + t1)
	v1 -= (v0 + 0x8ff34781) ^ ((v0 << 4) + t2) ^ ((v0 >> 5) + t3)
	v0 -= (v1 + 0x8ff34781) ^ ((v1 << 4) + t0) ^ ((v1 >> 5) + t1)
	v1 -= (v0 + 0xf1bbcdc8) ^ ((v0 << 4) + t2) ^ ((v0 >> 5) + t3)
	v0 -= (v1 + 0xf1bbcdc8) ^ ((v1 << 4) + t0) ^ ((v1 >> 5) + t1)
	v1 -= (v0 + 0x5384540f) ^ ((v0 << 4) + t2) ^ ((v0 >> 5) + t3)
	v0 -= (v1 + 0x5384540f) ^ ((v1 << 4) + t0) ^ ((v1 >> 5) + t1)
	v1 -= (v0 + 0xb54cda56) ^ ((v0 << 4) + t2) ^ ((v0 >> 5) + t3)
	v0 -= (v1 + 0xb54cda56) ^ ((v1 << 4) + t0) ^ ((v1 >> 5) + t1)
	v1 -= (v0 + 0x1715609d) ^ ((v0 << 4) + t2) ^ ((v0 >> 5) + t3)
	v0 -= (v1 + 0x1715609d) ^ ((v1 << 4) + t0) ^ ((v1 >> 5) + t1)
	v1 -= (v0 + 0x78dde6e4) ^ ((v0 << 4) + t2) ^ ((v0 >> 5) + t3)
	v0 -= (v1 + 0x78dde6e4) ^ ((v1 << 4) + t0) ^ ((v1 >> 5) + t1)
	v1 -= (v0 + 0xdaa66d2b) ^ ((v0 << 4) + t2) ^ ((v0 >> 5) + t3)
	v0 -= (v1 + 0xdaa66d2b) ^ ((v1 << 4) + t0) ^ ((v1 >> 5) + t1)
	v1 -= (v0 + 0x3c6ef372) ^ ((v0 << 4) + t2) ^ ((v0 >> 5) + t3)
	v0 -= (v1 + 0x3c6ef372) ^ ((v1 << 4) + t0) ^ ((v1 >> 5) + t1)
	v1 -= (v0 + 0x9e3779b9) ^ ((v0 << 4) + t2) ^ ((v0 >> 5) + t3)
	v0 -= (v1 + 0x9e3779b9) ^ ((v1 << 4) + t0) ^ ((v1 >> 5) + t1)

	return uint64(v0)<<32 | uint64(v1)
}

// 每次8字节
//go:nosplit
func (t *TEA) decodeTable(n uint64, s [0x10]uint32) uint64 {
	v0, v1 := uint32(n>>32), uint32(n)
	t0, t1, t2, t3 := t[0], t[1], t[2], t[3]

	for i := 0xf; i >= 0; i-- {
		v1 -= (v0 + s[i]) ^ ((v0 << 4) + t2) ^ ((v0 >> 5) + t3)
		v0 -= (v1 + s[i]) ^ ((v1 << 4) + t0) ^ ((v1 >> 5) + t1)
	}

	return uint64(v0)<<32 | uint64(v1)
}
