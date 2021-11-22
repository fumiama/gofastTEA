//go:build !go1.17 && amd64
// +build !go1.17,amd64

#include "textflag.h"

// func encrypt(dstlen uintptr, t uintptr)
TEXT ·encrypt(SB), NOSPLIT, $0-16
	MOVQ	·dstlen+0(FP), AX	// go:<1.17 dst
	MOVQ	·teaptr+8(FP), DI	// go:<1.17 t
	MOVQ	AX, BX		// len(dst) low 24 bits
	MOVQ	DI, R8		// len(dst) middle 24 bits
	SHRQ	$40, BX		// unpack len
	SHLQ	$24, AX
	SHRQ	$24, AX
	SHLQ	$24, DI
	SHRQ	$24, DI
	MOVQ	(DI), DX	// t0
	MOVQ	4(DI), R12	// t1
	MOVQ	8(DI), R10	// t2
	MOVQ	12(DI), SI	// t3
	SHRQ	$40, R8
	SHLQ	$24, R8
	ORQ		R8, BX		// len(dst) has 48 bits
	ADDQ	BX, AX		// dst += len(dst)
	NOTQ	BX			// i = -i - 1
	INCQ	BX			// i++
	// XORQ	R11, R11	// holder
	XORQ	R13, R13	// iv1
	XORQ	DI, DI		// iv2
enclop:
	MOVQ	(AX)(BX*1), R11		// holder = Uint64(dst[i:])
	BSWAPQ	R11					// holder = BE(block)
	XORQ	R13, R11			// holder ^= iv1
	MOVQ	R11, R13			// iv1 = holder
	// Use Register CX(v1), DX(t0), SI(t3), R8(tmp), R10(t2), R12(t1), R13(v0/ret)
	////////////////iv1 = encrypt(iv1)////////////////
	MOVQ	R11, CX					// v1
	SHRQ	$32, R13				// v0

	LEAQ	-1640531527(CX), R8		// R8 = v1 + 0x...
	MOVQ	CX, R9					// R9 = v1
	SHLQ	$4, R9					// R9 <<= 4
	ADDQ	DX, R9					// R9 += t0
	XORQ	R9, R8					// R8 ^= R9
	MOVQ	CX, R9					// R9 = v1
	SHRL	$5, R9					// R9 >>= 5
	ADDQ	R12, R9					// R9 += t1
	XORQ	R9, R8					// R8 ^= R9
	ADDQ	R8, R13					// v0 += R8
	LEAQ	-1640531527(R13), R8	// R8 = v0 + 0x...
	MOVQ	R13, R9					// R9 = v0
	SHLQ	$4, R9					// R9 <<= 4
	ADDQ	R10, R9					// R9 += t2
	XORQ	R9, R8					// R8 ^= R9
	MOVQ	R13, R9					// R9 = v0
	SHRL	$5, R9					// R9 >>= 5
	ADDQ	SI, R9					// R9 += t3
	XORQ	R9, R8					// R8 ^= R9
	ADDL	R8, CX					// v0 += R8

	LEAQ	1013904242(CX), R8		// R8 = v1 + 0x...
	MOVQ	CX, R9					// R9 = v1
	SHLQ	$4, R9					// R9 <<= 4
	ADDQ	DX, R9					// R9 += t0
	XORQ	R9, R8					// R8 ^= R9
	MOVQ	CX, R9					// R9 = v1
	SHRL	$5, R9					// R9 >>= 5
	ADDQ	R12, R9					// R9 += t1
	XORQ	R9, R8					// R8 ^= R9
	ADDQ	R8, R13					// v0 += R8
	LEAQ	1013904242(R13), R8		// R8 = v0 + 0x...
	MOVQ	R13, R9					// R9 = v0
	SHLQ	$4, R9					// R9 <<= 4
	ADDQ	R10, R9					// R9 += t2
	XORQ	R9, R8					// R8 ^= R9
	MOVQ	R13, R9					// R9 = v0
	SHRL	$5, R9					// R9 >>= 5
	ADDQ	SI, R9					// R9 += t3
	XORQ	R9, R8					// R8 ^= R9
	ADDL	R8, CX					// v0 += R8

	LEAQ	-626627285(CX), R8		// R8 = v1 + 0x...
	MOVQ	CX, R9					// R9 = v1
	SHLQ	$4, R9					// R9 <<= 4
	ADDQ	DX, R9					// R9 += t0
	XORQ	R9, R8					// R8 ^= R9
	MOVQ	CX, R9					// R9 = v1
	SHRL	$5, R9					// R9 >>= 5
	ADDQ	R12, R9					// R9 += t1
	XORQ	R9, R8					// R8 ^= R9
	ADDQ	R8, R13					// v0 += R8
	LEAQ	-626627285(R13), R8		// R8 = v0 + 0x...
	MOVQ	R13, R9					// R9 = v0
	SHLQ	$4, R9					// R9 <<= 4
	ADDQ	R10, R9					// R9 += t2
	XORQ	R9, R8					// R8 ^= R9
	MOVQ	R13, R9					// R9 = v0
	SHRL	$5, R9					// R9 >>= 5
	ADDQ	SI, R9					// R9 += t3
	XORQ	R9, R8					// R8 ^= R9
	ADDL	R8, CX					// v0 += R8
	
	LEAQ	2027808484(CX), R8		// R8 = v1 + 0x...
	MOVQ	CX, R9					// R9 = v1
	SHLQ	$4, R9					// R9 <<= 4
	ADDQ	DX, R9					// R9 += t0
	XORQ	R9, R8					// R8 ^= R9
	MOVQ	CX, R9					// R9 = v1
	SHRL	$5, R9					// R9 >>= 5
	ADDQ	R12, R9					// R9 += t1
	XORQ	R9, R8					// R8 ^= R9
	ADDQ	R8, R13					// v0 += R8
	LEAQ	2027808484(R13), R8		// R8 = v0 + 0x...
	MOVQ	R13, R9					// R9 = v0
	SHLQ	$4, R9					// R9 <<= 4
	ADDQ	R10, R9					// R9 += t2
	XORQ	R9, R8					// R8 ^= R9
	MOVQ	R13, R9					// R9 = v0
	SHRL	$5, R9					// R9 >>= 5
	ADDQ	SI, R9					// R9 += t3
	XORQ	R9, R8					// R8 ^= R9
	ADDL	R8, CX					// v0 += R8
	
	LEAQ	387276957(CX), R8		// R8 = v1 + 0x...
	MOVQ	CX, R9					// R9 = v1
	SHLQ	$4, R9					// R9 <<= 4
	ADDQ	DX, R9					// R9 += t0
	XORQ	R9, R8					// R8 ^= R9
	MOVQ	CX, R9					// R9 = v1
	SHRL	$5, R9					// R9 >>= 5
	ADDQ	R12, R9					// R9 += t1
	XORQ	R9, R8					// R8 ^= R9
	ADDQ	R8, R13					// v0 += R8
	LEAQ	387276957(R13), R8		// R8 = v0 + 0x...
	MOVQ	R13, R9					// R9 = v0
	SHLQ	$4, R9					// R9 <<= 4
	ADDQ	R10, R9					// R9 += t2
	XORQ	R9, R8					// R8 ^= R9
	MOVQ	R13, R9					// R9 = v0
	SHRL	$5, R9					// R9 >>= 5
	ADDQ	SI, R9					// R9 += t3
	XORQ	R9, R8					// R8 ^= R9
	ADDL	R8, CX					// v0 += R8
	
	LEAQ	-1253254570(CX), R8		// R8 = v1 + 0x...
	MOVQ	CX, R9					// R9 = v1
	SHLQ	$4, R9					// R9 <<= 4
	ADDQ	DX, R9					// R9 += t0
	XORQ	R9, R8					// R8 ^= R9
	MOVQ	CX, R9					// R9 = v1
	SHRL	$5, R9					// R9 >>= 5
	ADDQ	R12, R9					// R9 += t1
	XORQ	R9, R8					// R8 ^= R9
	ADDQ	R8, R13					// v0 += R8
	LEAQ	-1253254570(R13), R8		// R8 = v0 + 0x...
	MOVQ	R13, R9					// R9 = v0
	SHLQ	$4, R9					// R9 <<= 4
	ADDQ	R10, R9					// R9 += t2
	XORQ	R9, R8					// R8 ^= R9
	MOVQ	R13, R9					// R9 = v0
	SHRL	$5, R9					// R9 >>= 5
	ADDQ	SI, R9					// R9 += t3
	XORQ	R9, R8					// R8 ^= R9
	ADDL	R8, CX					// v0 += R8
	
	LEAQ	1401181199(CX), R8		// R8 = v1 + 0x...
	MOVQ	CX, R9					// R9 = v1
	SHLQ	$4, R9					// R9 <<= 4
	ADDQ	DX, R9					// R9 += t0
	XORQ	R9, R8					// R8 ^= R9
	MOVQ	CX, R9					// R9 = v1
	SHRL	$5, R9					// R9 >>= 5
	ADDQ	R12, R9					// R9 += t1
	XORQ	R9, R8					// R8 ^= R9
	ADDQ	R8, R13					// v0 += R8
	LEAQ	1401181199(R13), R8		// R8 = v0 + 0x...
	MOVQ	R13, R9					// R9 = v0
	SHLQ	$4, R9					// R9 <<= 4
	ADDQ	R10, R9					// R9 += t2
	XORQ	R9, R8					// R8 ^= R9
	MOVQ	R13, R9					// R9 = v0
	SHRL	$5, R9					// R9 >>= 5
	ADDQ	SI, R9					// R9 += t3
	XORQ	R9, R8					// R8 ^= R9
	ADDL	R8, CX					// v0 += R8
	
	LEAQ	-239350328(CX), R8		// R8 = v1 + 0x...
	MOVQ	CX, R9					// R9 = v1
	SHLQ	$4, R9					// R9 <<= 4
	ADDQ	DX, R9					// R9 += t0
	XORQ	R9, R8					// R8 ^= R9
	MOVQ	CX, R9					// R9 = v1
	SHRL	$5, R9					// R9 >>= 5
	ADDQ	R12, R9					// R9 += t1
	XORQ	R9, R8					// R8 ^= R9
	ADDQ	R8, R13					// v0 += R8
	LEAQ	-239350328(R13), R8		// R8 = v0 + 0x...
	MOVQ	R13, R9					// R9 = v0
	SHLQ	$4, R9					// R9 <<= 4
	ADDQ	R10, R9					// R9 += t2
	XORQ	R9, R8					// R8 ^= R9
	MOVQ	R13, R9					// R9 = v0
	SHRL	$5, R9					// R9 >>= 5
	ADDQ	SI, R9					// R9 += t3
	XORQ	R9, R8					// R8 ^= R9
	ADDL	R8, CX					// v0 += R8
	
	LEAQ	-1879881855(CX), R8		// R8 = v1 + 0x...
	MOVQ	CX, R9					// R9 = v1
	SHLQ	$4, R9					// R9 <<= 4
	ADDQ	DX, R9					// R9 += t0
	XORQ	R9, R8					// R8 ^= R9
	MOVQ	CX, R9					// R9 = v1
	SHRL	$5, R9					// R9 >>= 5
	ADDQ	R12, R9					// R9 += t1
	XORQ	R9, R8					// R8 ^= R9
	ADDQ	R8, R13					// v0 += R8
	LEAQ	-1879881855(R13), R8	// R8 = v0 + 0x...
	MOVQ	R13, R9					// R9 = v0
	SHLQ	$4, R9					// R9 <<= 4
	ADDQ	R10, R9					// R9 += t2
	XORQ	R9, R8					// R8 ^= R9
	MOVQ	R13, R9					// R9 = v0
	SHRL	$5, R9					// R9 >>= 5
	ADDQ	SI, R9					// R9 += t3
	XORQ	R9, R8					// R8 ^= R9
	ADDL	R8, CX					// v0 += R8
	
	LEAQ	774553914(CX), R8		// R8 = v1 + 0x...
	MOVQ	CX, R9					// R9 = v1
	SHLQ	$4, R9					// R9 <<= 4
	ADDQ	DX, R9					// R9 += t0
	XORQ	R9, R8					// R8 ^= R9
	MOVQ	CX, R9					// R9 = v1
	SHRL	$5, R9					// R9 >>= 5
	ADDQ	R12, R9					// R9 += t1
	XORQ	R9, R8					// R8 ^= R9
	ADDQ	R8, R13					// v0 += R8
	LEAQ	774553914(R13), R8		// R8 = v0 + 0x...
	MOVQ	R13, R9					// R9 = v0
	SHLQ	$4, R9					// R9 <<= 4
	ADDQ	R10, R9					// R9 += t2
	XORQ	R9, R8					// R8 ^= R9
	MOVQ	R13, R9					// R9 = v0
	SHRL	$5, R9					// R9 >>= 5
	ADDQ	SI, R9					// R9 += t3
	XORQ	R9, R8					// R8 ^= R9
	ADDL	R8, CX					// v0 += R8
	
	LEAQ	-865977613(CX), R8		// R8 = v1 + 0x...
	MOVQ	CX, R9					// R9 = v1
	SHLQ	$4, R9					// R9 <<= 4
	ADDQ	DX, R9					// R9 += t0
	XORQ	R9, R8					// R8 ^= R9
	MOVQ	CX, R9					// R9 = v1
	SHRL	$5, R9					// R9 >>= 5
	ADDQ	R12, R9					// R9 += t1
	XORQ	R9, R8					// R8 ^= R9
	ADDQ	R8, R13					// v0 += R8
	LEAQ	-865977613(R13), R8		// R8 = v0 + 0x...
	MOVQ	R13, R9					// R9 = v0
	SHLQ	$4, R9					// R9 <<= 4
	ADDQ	R10, R9					// R9 += t2
	XORQ	R9, R8					// R8 ^= R9
	MOVQ	R13, R9					// R9 = v0
	SHRL	$5, R9					// R9 >>= 5
	ADDQ	SI, R9					// R9 += t3
	XORQ	R9, R8					// R8 ^= R9
	ADDL	R8, CX					// v0 += R8
	
	LEAQ	1788458156(CX), R8		// R8 = v1 + 0x...
	MOVQ	CX, R9					// R9 = v1
	SHLQ	$4, R9					// R9 <<= 4
	ADDQ	DX, R9					// R9 += t0
	XORQ	R9, R8					// R8 ^= R9
	MOVQ	CX, R9					// R9 = v1
	SHRQ	$5, R9					// R9 >>= 5
	ADDQ	R12, R9					// R9 += t1
	XORQ	R9, R8					// R8 ^= R9
	ADDL	R8, R13					// v0 += R8
	LEAQ	1788458156(R13), R8		// R8 = v0 + 0x...
	MOVQ	R13, R9					// R9 = v0
	SHLQ	$4, R9					// R9 <<= 4
	ADDQ	R10, R9					// R9 += t2
	XORQ	R9, R8					// R8 ^= R9
	MOVQ	R13, R9					// R9 = v0
	SHRQ	$5, R9					// R9 >>= 5
	ADDQ	SI, R9					// R9 += t3
	XORQ	R9, R8					// R8 ^= R9
	ADDL	R8, CX					// v0 += R8
	
	LEAQ	147926629(CX), R8		// R8 = v1 + 0x...
	MOVQ	CX, R9					// R9 = v1
	SHLQ	$4, R9					// R9 <<= 4
	ADDQ	DX, R9					// R9 += t0
	XORQ	R9, R8					// R8 ^= R9
	MOVQ	CX, R9					// R9 = v1
	SHRL	$5, R9					// R9 >>= 5
	ADDQ	R12, R9					// R9 += t1
	XORQ	R9, R8					// R8 ^= R9
	ADDQ	R8, R13					// v0 += R8
	LEAQ	147926629(R13), R8		// R8 = v0 + 0x...
	MOVQ	R13, R9					// R9 = v0
	SHLQ	$4, R9					// R9 <<= 4
	ADDQ	R10, R9					// R9 += t2
	XORQ	R9, R8					// R8 ^= R9
	MOVQ	R13, R9					// R9 = v0
	SHRL	$5, R9					// R9 >>= 5
	ADDQ	SI, R9					// R9 += t3
	XORQ	R9, R8					// R8 ^= R9
	ADDL	R8, CX					// v0 += R8
	
	LEAQ	-1492604898(CX), R8		// R8 = v1 + 0x...
	MOVQ	CX, R9					// R9 = v1
	SHLQ	$4, R9					// R9 <<= 4
	ADDQ	DX, R9					// R9 += t0
	XORQ	R9, R8					// R8 ^= R9
	MOVQ	CX, R9					// R9 = v1
	SHRL	$5, R9					// R9 >>= 5
	ADDQ	R12, R9					// R9 += t1
	XORQ	R9, R8					// R8 ^= R9
	ADDQ	R8, R13					// v0 += R8
	LEAQ	-1492604898(R13), R8	// R8 = v0 + 0x...
	MOVQ	R13, R9					// R9 = v0
	SHLQ	$4, R9					// R9 <<= 4
	ADDQ	R10, R9					// R9 += t2
	XORQ	R9, R8					// R8 ^= R9
	MOVQ	R13, R9					// R9 = v0
	SHRL	$5, R9					// R9 >>= 5
	ADDQ	SI, R9					// R9 += t3
	XORQ	R9, R8					// R8 ^= R9
	ADDL	R8, CX					// v0 += R8
	
	LEAQ	1161830871(CX), R8		// R8 = v1 + 0x...
	MOVQ	CX, R9					// R9 = v1
	SHLQ	$4, R9					// R9 <<= 4
	ADDQ	DX, R9					// R9 += t0
	XORQ	R9, R8					// R8 ^= R9
	MOVQ	CX, R9					// R9 = v1
	SHRL	$5, R9					// R9 >>= 5
	ADDQ	R12, R9					// R9 += t1
	XORQ	R9, R8					// R8 ^= R9
	ADDQ	R8, R13					// v0 += R8
	LEAQ	1161830871(R13), R8		// R8 = v0 + 0x...
	MOVQ	R13, R9					// R9 = v0
	SHLQ	$4, R9					// R9 <<= 4
	ADDQ	R10, R9					// R9 += t2
	XORQ	R9, R8					// R8 ^= R9
	MOVQ	R13, R9					// R9 = v0
	SHRL	$5, R9					// R9 >>= 5
	ADDQ	SI, R9					// R9 += t3
	XORQ	R9, R8					// R8 ^= R9
	ADDL	R8, CX					// v0 += R8
	
	LEAQ	-478700656(CX), R8		// R8 = v1 + 0x...
	MOVQ	CX, R9					// R9 = v1
	SHLQ	$4, R9					// R9 <<= 4
	ADDQ	DX, R9					// R9 += t0
	XORQ	R9, R8					// R8 ^= R9
	MOVQ	CX, R9					// R9 = v1
	SHRL	$5, R9					// R9 >>= 5
	ADDQ	R12, R9					// R9 += t1
	XORQ	R9, R8					// R8 ^= R9
	ADDQ	R8, R13					// v0 += R8
	LEAQ	-478700656(R13), R8		// R8 = v0 + 0x...
	MOVQ	R13, R9					// R9 = v0
	SHLQ	$4, R9					// R9 <<= 4
	ADDQ	R10, R9					// R9 += t2
	XORQ	R9, R8					// R8 ^= R9
	MOVQ	R13, R9					// R9 = v0
	SHRL	$5, R9					// R9 >>= 5
	ADDQ	SI, R9					// R9 += t3
	XORQ	R9, R8					// R8 ^= R9
	ADDL	R8, CX					// v0 += R8

	SHLQ	$32, R13				// v0 <<= 32
	ORQ		CX, R13					// v0 |= v1
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	XORQ	DI, R13				// iv1 ^= iv2
	MOVQ	R11, DI				// iv2 = holder
	MOVQ	R13, R11			// holder = iv1
	BSWAPQ	R11					// holder = BE(holder)
	MOVQ	R11, (AX)(BX*1)		// PutUint64(dst[i:], holder)
	ADDQ	$8, BX				// i += 8
	JNZ		enclop
	RET

// func decrypt(datalen uintptr, dst uintptr, t *TEA)
TEXT ·decrypt(SB), NOSPLIT, $0-24
	MOVQ	·data+0(FP), AX		// go:<1.17 data
	MOVQ	·dst+8(FP), DI		// go:<1.17 dst
	MOVQ	·teaptr+16(FP), SI	// go:<1.17 t
	MOVQ	AX, BX		// len(data) low 24 bits
	MOVQ	DI, R8		// dst middle 24 bits
	SHRQ	$40, BX		// unpack len
	SHLQ	$24, AX
	SHRQ	$24, AX
	SHLQ	$24, DI
	SHRQ	$24, DI
	MOVQ	(SI), DX	// t0
	MOVQ	4(SI), R12	// t1
	MOVQ	8(SI), R10	// t2
	MOVQ	12(SI), R13	// t3
	SHRQ	$40, R8
	SHLQ	$24, R8
	ORQ		R8, BX		// len(data) has 48 bits
	ADDQ	BX, AX		// data += len(data)
	ADDQ	BX, DI		// dst += len(data)
	NOTQ	BX			// i = -len - 1
	INCQ	BX			// i++
	XORQ	SI, SI		// iv1
	XORQ	R15, R15	// iv2
	XORQ	R11, R11	// holder
declop:
	MOVQ	(AX)(BX*1), SI		// iv1 = Uint64(data[i:])
	BSWAPQ	SI					// iv1 = BE(block)
	XORQ	SI, R15				// iv2 ^= iv1
	// Use Register R15(v0/ret), R12(t1), CX(v1), DX(t0), R13(t3), R8, R9, R10(t2)
	///////////////iv2 = decrypt(iv2)///////////////
	MOVQ	R15, CX				// v1
	SHRQ	$32, R15			// v0

	LEAQ	-478700656(R15), R8	// R8 = v0 + 0x...
	MOVQ	R15, R9				// R9 = v0
	SHLQ	$4, R9				// R9 <<= 4
	ADDQ	R10, R9				// R9 += t2
	XORQ	R9, R8				// R8 ^= R9
	MOVQ	R15, R9				// R9 = v0
	SHRQ	$5, R9				// R9 >>= 5
	ADDQ	R13, R9				// R9 += t3
	XORQ	R9, R8				// R8 ^= R9
	SUBL	R8, CX				// v1 -= R8
	LEAQ	-478700656(CX), R8	// R8 = v1 + 0x...
	MOVQ	CX, R9				// R9 = v1
	SHLQ	$4, R9				// R9 <<= 4
	ADDQ	DX, R9				// R9 += t0
	XORQ	R9, R8				// R8 ^= R9
	MOVQ	CX, R9				// R9 = v1
	SHRQ	$5, R9				// R9 >>= 5
	ADDQ	R12, R9				// R9 += t1
	XORQ	R9, R8				// R8 ^= R9
	SUBL	R8, R15				// v0 -= R8

	LEAQ	1161830871(R15), R8	// R8 = v0 + 0x...
	MOVQ	R15, R9				// R9 = v0
	SHLQ	$4, R9				// R9 <<= 4
	ADDQ	R10, R9				// R9 += t2
	XORQ	R9, R8				// R8 ^= R9
	MOVQ	R15, R9				// R9 = v0
	SHRQ	$5, R9				// R9 >>= 5
	ADDQ	R13, R9				// R9 += t3
	XORQ	R9, R8				// R8 ^= R9
	SUBL	R8, CX				// v1 -= R8
	LEAQ	1161830871(CX), R8	// R8 = v1 + 0x...
	MOVQ	CX, R9				// R9 = v1
	SHLQ	$4, R9				// R9 <<= 4
	ADDQ	DX, R9				// R9 += t0
	XORQ	R9, R8				// R8 ^= R9
	MOVQ	CX, R9				// R9 = v1
	SHRQ	$5, R9				// R9 >>= 5
	ADDQ	R12, R9				// R9 += t1
	XORQ	R9, R8				// R8 ^= R9
	SUBL	R8, R15				// v0 -= R8

	LEAQ	-1492604898(R15), R8	// R8 = v0 + 0x...
	MOVQ	R15, R9				// R9 = v0
	SHLQ	$4, R9				// R9 <<= 4
	ADDQ	R10, R9				// R9 += t2
	XORQ	R9, R8				// R8 ^= R9
	MOVQ	R15, R9				// R9 = v0
	SHRQ	$5, R9				// R9 >>= 5
	ADDQ	R13, R9				// R9 += t3
	XORQ	R9, R8				// R8 ^= R9
	SUBL	R8, CX				// v1 -= R8
	LEAQ	-1492604898(CX), R8	// R8 = v1 + 0x...
	MOVQ	CX, R9				// R9 = v1
	SHLQ	$4, R9				// R9 <<= 4
	ADDQ	DX, R9				// R9 += t0
	XORQ	R9, R8				// R8 ^= R9
	MOVQ	CX, R9				// R9 = v1
	SHRQ	$5, R9				// R9 >>= 5
	ADDQ	R12, R9				// R9 += t1
	XORQ	R9, R8				// R8 ^= R9
	SUBL	R8, R15				// v0 -= R8

	LEAQ	147926629(R15), R8	// R8 = v0 + 0x...
	MOVQ	R15, R9				// R9 = v0
	SHLQ	$4, R9				// R9 <<= 4
	ADDQ	R10, R9				// R9 += t2
	XORQ	R9, R8				// R8 ^= R9
	MOVQ	R15, R9				// R9 = v0
	SHRQ	$5, R9				// R9 >>= 5
	ADDQ	R13, R9				// R9 += t3
	XORQ	R9, R8				// R8 ^= R9
	SUBL	R8, CX				// v1 -= R8
	LEAQ	147926629(CX), R8	// R8 = v1 + 0x...
	MOVQ	CX, R9				// R9 = v1
	SHLQ	$4, R9				// R9 <<= 4
	ADDQ	DX, R9				// R9 += t0
	XORQ	R9, R8				// R8 ^= R9
	MOVQ	CX, R9				// R9 = v1
	SHRQ	$5, R9				// R9 >>= 5
	ADDQ	R12, R9				// R9 += t1
	XORQ	R9, R8				// R8 ^= R9
	SUBL	R8, R15				// v0 -= R8

	LEAQ	1788458156(R15), R8	// R8 = v0 + 0x...
	MOVQ	R15, R9				// R9 = v0
	SHLQ	$4, R9				// R9 <<= 4
	ADDQ	R10, R9				// R9 += t2
	XORQ	R9, R8				// R8 ^= R9
	MOVQ	R15, R9				// R9 = v0
	SHRQ	$5, R9				// R9 >>= 5
	ADDQ	R13, R9				// R9 += t3
	XORQ	R9, R8				// R8 ^= R9
	SUBL	R8, CX				// v1 -= R8
	LEAQ	1788458156(CX), R8	// R8 = v1 + 0x...
	MOVQ	CX, R9				// R9 = v1
	SHLQ	$4, R9				// R9 <<= 4
	ADDQ	DX, R9				// R9 += t0
	XORQ	R9, R8				// R8 ^= R9
	MOVQ	CX, R9				// R9 = v1
	SHRQ	$5, R9				// R9 >>= 5
	ADDQ	R12, R9				// R9 += t1
	XORQ	R9, R8				// R8 ^= R9
	SUBL	R8, R15				// v0 -= R8

	LEAQ	-865977613(R15), R8	// R8 = v0 + 0x...
	MOVQ	R15, R9				// R9 = v0
	SHLQ	$4, R9				// R9 <<= 4
	ADDQ	R10, R9				// R9 += t2
	XORQ	R9, R8				// R8 ^= R9
	MOVQ	R15, R9				// R9 = v0
	SHRQ	$5, R9				// R9 >>= 5
	ADDQ	R13, R9				// R9 += t3
	XORQ	R9, R8				// R8 ^= R9
	SUBL	R8, CX				// v1 -= R8
	LEAQ	-865977613(CX), R8	// R8 = v1 + 0x...
	MOVQ	CX, R9				// R9 = v1
	SHLQ	$4, R9				// R9 <<= 4
	ADDQ	DX, R9				// R9 += t0
	XORQ	R9, R8				// R8 ^= R9
	MOVQ	CX, R9				// R9 = v1
	SHRQ	$5, R9				// R9 >>= 5
	ADDQ	R12, R9				// R9 += t1
	XORQ	R9, R8				// R8 ^= R9
	SUBL	R8, R15				// v0 -= R8

	LEAQ	774553914(R15), R8	// R8 = v0 + 0x...
	MOVQ	R15, R9				// R9 = v0
	SHLQ	$4, R9				// R9 <<= 4
	ADDQ	R10, R9				// R9 += t2
	XORQ	R9, R8				// R8 ^= R9
	MOVQ	R15, R9				// R9 = v0
	SHRQ	$5, R9				// R9 >>= 5
	ADDQ	R13, R9				// R9 += t3
	XORQ	R9, R8				// R8 ^= R9
	SUBL	R8, CX				// v1 -= R8
	LEAQ	774553914(CX), R8	// R8 = v1 + 0x...
	MOVQ	CX, R9				// R9 = v1
	SHLQ	$4, R9				// R9 <<= 4
	ADDQ	DX, R9				// R9 += t0
	XORQ	R9, R8				// R8 ^= R9
	MOVQ	CX, R9				// R9 = v1
	SHRQ	$5, R9				// R9 >>= 5
	ADDQ	R12, R9				// R9 += t1
	XORQ	R9, R8				// R8 ^= R9
	SUBL	R8, R15				// v0 -= R8

	LEAQ	-1879881855(R15), R8	// R8 = v0 + 0x...
	MOVQ	R15, R9				// R9 = v0
	SHLQ	$4, R9				// R9 <<= 4
	ADDQ	R10, R9				// R9 += t2
	XORQ	R9, R8				// R8 ^= R9
	MOVQ	R15, R9				// R9 = v0
	SHRQ	$5, R9				// R9 >>= 5
	ADDQ	R13, R9				// R9 += t3
	XORQ	R9, R8				// R8 ^= R9
	SUBL	R8, CX				// v1 -= R8
	LEAQ	-1879881855(CX), R8	// R8 = v1 + 0x...
	MOVQ	CX, R9				// R9 = v1
	SHLQ	$4, R9				// R9 <<= 4
	ADDQ	DX, R9				// R9 += t0
	XORQ	R9, R8				// R8 ^= R9
	MOVQ	CX, R9				// R9 = v1
	SHRQ	$5, R9				// R9 >>= 5
	ADDQ	R12, R9				// R9 += t1
	XORQ	R9, R8				// R8 ^= R9
	SUBL	R8, R15				// v0 -= R8

	LEAQ	-239350328(R15), R8	// R8 = v0 + 0x...
	MOVQ	R15, R9				// R9 = v0
	SHLQ	$4, R9				// R9 <<= 4
	ADDQ	R10, R9				// R9 += t2
	XORQ	R9, R8				// R8 ^= R9
	MOVQ	R15, R9				// R9 = v0
	SHRQ	$5, R9				// R9 >>= 5
	ADDQ	R13, R9				// R9 += t3
	XORQ	R9, R8				// R8 ^= R9
	SUBL	R8, CX				// v1 -= R8
	LEAQ	-239350328(CX), R8	// R8 = v1 + 0x...
	MOVQ	CX, R9				// R9 = v1
	SHLQ	$4, R9				// R9 <<= 4
	ADDQ	DX, R9				// R9 += t0
	XORQ	R9, R8				// R8 ^= R9
	MOVQ	CX, R9				// R9 = v1
	SHRQ	$5, R9				// R9 >>= 5
	ADDQ	R12, R9				// R9 += t1
	XORQ	R9, R8				// R8 ^= R9
	SUBL	R8, R15				// v0 -= R8

	LEAQ	1401181199(R15), R8	// R8 = v0 + 0x...
	MOVQ	R15, R9				// R9 = v0
	SHLQ	$4, R9				// R9 <<= 4
	ADDQ	R10, R9				// R9 += t2
	XORQ	R9, R8				// R8 ^= R9
	MOVQ	R15, R9				// R9 = v0
	SHRQ	$5, R9				// R9 >>= 5
	ADDQ	R13, R9				// R9 += t3
	XORQ	R9, R8				// R8 ^= R9
	SUBL	R8, CX				// v1 -= R8
	LEAQ	1401181199(CX), R8	// R8 = v1 + 0x...
	MOVQ	CX, R9				// R9 = v1
	SHLQ	$4, R9				// R9 <<= 4
	ADDQ	DX, R9				// R9 += t0
	XORQ	R9, R8				// R8 ^= R9
	MOVQ	CX, R9				// R9 = v1
	SHRQ	$5, R9				// R9 >>= 5
	ADDQ	R12, R9				// R9 += t1
	XORQ	R9, R8				// R8 ^= R9
	SUBL	R8, R15				// v0 -= R8

	LEAQ	-1253254570(R15), R8	// R8 = v0 + 0x...
	MOVQ	R15, R9				// R9 = v0
	SHLQ	$4, R9				// R9 <<= 4
	ADDQ	R10, R9				// R9 += t2
	XORQ	R9, R8				// R8 ^= R9
	MOVQ	R15, R9				// R9 = v0
	SHRQ	$5, R9				// R9 >>= 5
	ADDQ	R13, R9				// R9 += t3
	XORQ	R9, R8				// R8 ^= R9
	SUBL	R8, CX				// v1 -= R8
	LEAQ	-1253254570(CX), R8	// R8 = v1 + 0x...
	MOVQ	CX, R9				// R9 = v1
	SHLQ	$4, R9				// R9 <<= 4
	ADDQ	DX, R9				// R9 += t0
	XORQ	R9, R8				// R8 ^= R9
	MOVQ	CX, R9				// R9 = v1
	SHRQ	$5, R9				// R9 >>= 5
	ADDQ	R12, R9				// R9 += t1
	XORQ	R9, R8				// R8 ^= R9
	SUBL	R8, R15				// v0 -= R8

	LEAQ	387276957(R15), R8	// R8 = v0 + 0x...
	MOVQ	R15, R9				// R9 = v0
	SHLQ	$4, R9				// R9 <<= 4
	ADDQ	R10, R9				// R9 += t2
	XORQ	R9, R8				// R8 ^= R9
	MOVQ	R15, R9				// R9 = v0
	SHRQ	$5, R9				// R9 >>= 5
	ADDQ	R13, R9				// R9 += t3
	XORQ	R9, R8				// R8 ^= R9
	SUBL	R8, CX				// v1 -= R8
	LEAQ	387276957(CX), R8	// R8 = v1 + 0x...
	MOVQ	CX, R9				// R9 = v1
	SHLQ	$4, R9				// R9 <<= 4
	ADDQ	DX, R9				// R9 += t0
	XORQ	R9, R8				// R8 ^= R9
	MOVQ	CX, R9				// R9 = v1
	SHRQ	$5, R9				// R9 >>= 5
	ADDQ	R12, R9				// R9 += t1
	XORQ	R9, R8				// R8 ^= R9
	SUBL	R8, R15				// v0 -= R8

	LEAQ	2027808484(R15), R8	// R8 = v0 + 0x...
	MOVQ	R15, R9				// R9 = v0
	SHLQ	$4, R9				// R9 <<= 4
	ADDQ	R10, R9				// R9 += t2
	XORQ	R9, R8				// R8 ^= R9
	MOVQ	R15, R9				// R9 = v0
	SHRQ	$5, R9				// R9 >>= 5
	ADDQ	R13, R9				// R9 += t3
	XORQ	R9, R8				// R8 ^= R9
	SUBL	R8, CX				// v1 -= R8
	LEAQ	2027808484(CX), R8	// R8 = v1 + 0x...
	MOVQ	CX, R9				// R9 = v1
	SHLQ	$4, R9				// R9 <<= 4
	ADDQ	DX, R9				// R9 += t0
	XORQ	R9, R8				// R8 ^= R9
	MOVQ	CX, R9				// R9 = v1
	SHRQ	$5, R9				// R9 >>= 5
	ADDQ	R12, R9				// R9 += t1
	XORQ	R9, R8				// R8 ^= R9
	SUBL	R8, R15				// v0 -= R8

	LEAQ	-626627285(R15), R8	// R8 = v0 + 0x...
	MOVQ	R15, R9				// R9 = v0
	SHLQ	$4, R9				// R9 <<= 4
	ADDQ	R10, R9				// R9 += t2
	XORQ	R9, R8				// R8 ^= R9
	MOVQ	R15, R9				// R9 = v0
	SHRQ	$5, R9				// R9 >>= 5
	ADDQ	R13, R9				// R9 += t3
	XORQ	R9, R8				// R8 ^= R9
	SUBL	R8, CX				// v1 -= R8
	LEAQ	-626627285(CX), R8	// R8 = v1 + 0x...
	MOVQ	CX, R9				// R9 = v1
	SHLQ	$4, R9				// R9 <<= 4
	ADDQ	DX, R9				// R9 += t0
	XORQ	R9, R8				// R8 ^= R9
	MOVQ	CX, R9				// R9 = v1
	SHRQ	$5, R9				// R9 >>= 5
	ADDQ	R12, R9				// R9 += t1
	XORQ	R9, R8				// R8 ^= R9
	SUBL	R8, R15				// v0 -= R8

	LEAQ	1013904242(R15), R8	// R8 = v0 + 0x...
	MOVQ	R15, R9				// R9 = v0
	SHLQ	$4, R9				// R9 <<= 4
	ADDQ	R10, R9				// R9 += t2
	XORQ	R9, R8				// R8 ^= R9
	MOVQ	R15, R9				// R9 = v0
	SHRQ	$5, R9				// R9 >>= 5
	ADDQ	R13, R9				// R9 += t3
	XORQ	R9, R8				// R8 ^= R9
	SUBL	R8, CX				// v1 -= R8
	LEAQ	1013904242(CX), R8	// R8 = v1 + 0x...
	MOVQ	CX, R9				// R9 = v1
	SHLQ	$4, R9				// R9 <<= 4
	ADDQ	DX, R9				// R9 += t0
	XORQ	R9, R8				// R8 ^= R9
	MOVQ	CX, R9				// R9 = v1
	SHRQ	$5, R9				// R9 >>= 5
	ADDQ	R12, R9				// R9 += t1
	XORQ	R9, R8				// R8 ^= R9
	SUBL	R8, R15				// v0 -= R8

	LEAQ	-1640531527(R15), R8	// R8 = v0 + 0x...
	MOVQ	R15, R9				// R9 = v0
	SHLQ	$4, R9				// R9 <<= 4
	ADDQ	R10, R9				// R9 += t2
	XORQ	R9, R8				// R8 ^= R9
	MOVQ	R15, R9				// R9 = v0
	SHRQ	$5, R9				// R9 >>= 5
	ADDQ	R13, R9				// R9 += t3
	XORQ	R9, R8				// R8 ^= R9
	SUBL	R8, CX				// v1 -= R8
	LEAQ	-1640531527(CX), R8	// R8 = v1 + 0x...
	MOVQ	CX, R9				// R9 = v1
	SHLQ	$4, R9				// R9 <<= 4
	ADDQ	DX, R9				// R9 += t0
	XORQ	R9, R8				// R8 ^= R9
	MOVQ	CX, R9				// R9 = v1
	SHRQ	$5, R9				// R9 >>= 5
	ADDQ	R12, R9				// R9 += t1
	XORQ	R9, R8				// R8 ^= R9
	SUBL	R8, R15				// v0 -= R8

	SHLQ	$32, R15
	ORQ		CX, R15
	///////////////////////////////////////////////
	XORQ	R15, R11			// holder ^= iv2
	BSWAPQ	R11					// holder = BE(holder)
	MOVQ	R11, (DI)(BX*1)		// PutUint64(dst[i:], holder)
	MOVQ	SI, R11				// holder = iv1
	ADDQ	$8, BX				// i += 8
	JNZ		declop
	RET
