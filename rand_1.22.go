//go:build go1.22

package tea

import (
	"math/rand/v2"
)

func randuint32() uint32 {
	return rand.Uint32()
}
