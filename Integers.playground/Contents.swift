/*:
### Swift Integer Quick Guide

  Created by Keith Harrison https://useyourloaf.com
  Copyright (c) 2017-2020 Keith Harrison. All rights reserved.

  See: [Swift Integer Quick Guide](https://useyourloaf.com/blog/swift-integer-quick-guide/)
 */

/*:
### Integer Types
 */
Int8(42)   // 8-bit signed
UInt8(42)  // 8-bit unsigned
Int16(42)  // 16-bit signed
UInt16(42) // 16-bit unsigned
Int32(42)  // 32-bit signed
UInt32(42) // 32-bit unsigned
Int64(42)  // 64-bit signed
UInt64(42) // 64-bit unsigned
Int(42)    // platform word size signed
UInt(44)   // platform word size unsigned

/*:
 ### Max and min values of each type
*/
Int8.min   // -128
Int8.max   //  127
UInt8.min  // 0
UInt8.max  // 255
Int16.min  // -32768
Int16.max  //  32767
UInt16.min // 0
UInt16.max // 65535
Int32.min  // -2147483648
Int32.max  //  2147483647
UInt32.min // 0
UInt32.max // 4294967295
Int64.min  // -9223372036854775808
Int64.max  //  9223372036854775807
UInt64.min //  0
UInt64.max //  18446744073709551615
Int.min    // platform dependent (32/64 bit)
Int.max    // platform dependent (32/64 bit)
UInt.min   // 0
UInt.max   // platform dependent (32/64 bit)

/*:
 ### Integer literals
 */
let decimal = 42              // 42
let binary  = 0b101010        // 42
let octal = 0o52              // 42
let hex = 0x2A                // 42
let hex2bytes = 0x00_ff       // 255
let downloads = 1_000_000_000 // 1000000000

/*:
 ### Initializers
 */
let someInt = 42           // Int
let int8 = Int8(127)       // 8-bit signed integer
let unit8 = UInt8(255)     // 8-bit unsigned integer

// let tooBig = Int8(128)     // Integer overflow

/*:
 Initializing with a `String` can fails so returns an Optional
 */
let zip = Int("95014")             // 95014
let unzip = Int("XYZ 30")          // nil
let rad16 = Int("FF", radix: 16)   // 255
let bitrot = Int8("020", radix: 2) // nil

/*:
 Doubles are truncated
 */
let pi = Int(3.14)   // 3

/*:
  Endian
 */
let fromBigEnd = Int.init(bigEndian: 0x4000_0000_0000_0000) // 0x40
let fromLittleEnd = Int.init(littleEndian: 0x40)            // 0x40

/*:
 Swapping bytes
 */
let aa:UInt16 = 0x00AA       // 0x00AA (170)
let swapped = aa.byteSwapped // 0xAA00 (43520)

/*:
 Bit Patterns when you need to convert between signed and unsigned
 maintaining an exact bit pattern
 */
let bits: UInt8 = 0b1000_0000        // 128
// let topBit = Int8(bits)           // error - overflows
let topBit = Int8(bitPattern: bits)  // -128 = 0b10000000
let back = UInt8(bitPattern: topBit) //  128 = 0b10000000
let full16 = 0xAA05
let lower8 = UInt8(truncatingIfNeeded: full16) // 5

/*:
 ### Conversion Between Types

 Conversions must be explicit, you cannot perform operations on different types:
 */
let height = Int8(5)
let width = 10

// let area = height * width   // error operands are Int8 and Int
let area = Int(height) * width // 50

/*:
 Overflow is an error
 */
let h = UInt8(25)     // UInt8(25)
let x = 10 * h        // UInt8(250)
// let y = 100 * h    // error
let y = 100 * Int(h)  // Int(2500)

/*:
 ### Failable Initializers

  You cannot initialize an integer type with a value that does not fit. If that is likely use one of
 the failable initializers.
 */

// let tooBig = Int8(128)
let input = 128
let tooBig = Int8(exactly: input)  // nil
let fits = Int16(exactly: input)   // 128

/*:
 ### Overflow Operators
 */
let maxInt32 = Int32.max  // 2147483647
let minInt32 = Int32.min  // -2147483648

/*:
 The following overflows a 32-bit integer
  causing an exception
 */
// let moreThan32 = maxInt32 + 1
// let lessThan32 = minInt32 - 1
// let twiceAsBig = maxInt32 * 2

/*:
 Swift has three overflow operators
 overflowing causes the result to wrap around
 from the maximum to minimum value (or vice versa for underflow)
 */
// Overflow addition: &+
let overflowAdd = maxInt32 &+ 1 // -2147483648

// Overflow substraction: &-
let overflowSub = minInt32 &- 1 // 2147483647

// Overflow multiplication: &*
let overflowMult = maxInt32 &* 2 // -2

/*:
 If you want to know if an under/overflow happened:
 returns a tuple (Int32, Bool)
 */
let wrapAdd = maxInt32.addingReportingOverflow(maxInt32)        // (-2, true)
let wrapSub = Int8(-127).subtractingReportingOverflow(2)        // (127, true)
let wrapMult = UInt8(128).multipliedReportingOverflow(by: 2)    // (0, true)
let remainder = 127.remainderReportingOverflow(dividingBy: 10)  // (7, false)

/*:
 At time of writing a compiler bug [SR-5964](https://bugs.swift.org/browse/SR-5964) means that the `dividedReportingOverflow` may fail to compile when it detects an overflow will happen.
 */
// let bug = Int.min.dividedReportingOverflow(by: -1)

/*:
 ### Bitwise Operators

 As with C bitwise operators

+ ~ NOT
+ & AND
+ | OR
+ ^ XOR
 */
let byte:UInt8 = 0b1010_0000     // 160 (0b1010_0000)
let mask:UInt8 = 0b0011_0011     //  51 (0b0011_0011)
let notByte = ~byte              //  95 (0b0101_1111)
let andByte = byte & mask        //  32 (0b0010_0000)
let orByte = byte | mask         // 179 (0b1011_0011)
let xorByte = byte ^ mask        // 147 (0b1001_0011)

/*:
 Bit shifting unsigned integers discards bits shifted beyond the bounds, empty bits are filled with zeroes
 */
let pattern:UInt8 = 0b1100_0011
pattern << 2     // 0b0000_1100
pattern >> 2     // 0b0011_0000

/*:
 rotating an unsigned integer
 */
let rotateLeft = pattern << 2 | pattern >> 6  // 0b0000_1111
let rotateRight = pattern << 6 | pattern >> 2 // 0b1111_0000

/*:
 When bit shifting signed integers to the right, empty bits on the left are filled with the sign bit.

 For an 8-bit integer, top bit is the sign and seven bits the value
 using 2's complement for negative values so subtract from 2^7 = 128

     -10 => 128 - 10 = 118 = 0b111_0110
 */
let minus10 = Int8(bitPattern: 0b1_111_0110) // -10
minus10 << 2 // -40
minus10 >> 2 // -3
let minus40 = Int8(bitPattern: 0b1_101_1000) // -40
let minus3  = Int8(bitPattern: 0b1_111_1101) // -3
