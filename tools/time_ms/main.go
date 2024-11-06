package main

import (
	"fmt"
	"runtime"
	"runtime/debug"
	"time"
)

func main() {
	debug.SetGCPercent(-1)
	runtime.GOMAXPROCS(1)

	now := time.Now()
	fmt.Println(now.Format("2006-01-02 15:04:05.000"))
}
