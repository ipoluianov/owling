package main

import "C"

//export Increment
func Increment(value C.int) C.int {
	return value + 1
}

func main() {}
