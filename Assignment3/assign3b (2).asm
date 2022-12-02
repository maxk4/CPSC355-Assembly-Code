// Maximilian Kaczmarek
// UCID: 30151219
// Date: 2022-05-24
// Assignment 3 version B

	.text
first_input:.string "Enter the first character of your hex number: "
next_input: .string "Enter the next character of your hex number: "

hex_val:    .string " %c"
binary_val: .string "\nYour number in binary: "
result:	    .string "%d\n"

	define(hexChar, x20)			// define x20 as hexChar
	define(loopCount, x21)			// define x21 as loop counter
	define(binary_N, x22)			// define x22 as binary_N
	define(quotient, x23)			// define x21 as quotient variable
	define(i, x24)				// define x24 as i
	define(remainder,x25)			// define x25 as remainder
	define(two, x26)			// define x26 to hold value 2

	.global main				// Makes "main" visible to the linker
	.balign 4                               // Aligns instructions
main: 	
	stp	x29, x30, [sp, -16]!		// Allocates 16 bytes in stack memory(in RAM)
	mov	x29, sp                        	// Updates FP to the current SP

	mov	loopCount, 0			// initialize i to 0 (loop counter)
	ldr	x0, =first_input		// set argument for printf to message (loads address)
	bl      printf                         	// call printf

	// for loop to receive user input one char at a time and convert it
top:	
	ldr	x0, =hex_val			// load address of inputString
        ldr     x1, =inputNumber		// load address of inputNumber
	bl      scanf				// C function scanf
	ldr	x1, =inputNumber		// load address of inputNumber
	ldr	hexChar, [x1]			// saves the user input to x20, loading the value at address of x1 into x20 
	
	b	convert				// branch to convert

convert:
	cmp	hexChar,0x39			// start of if statment, cmp input with 9
	b.le	decimal				// if less than or equal to, branch to decimal
	
	cmp	hexChar, 0x41			// start of if statment, cmp comparison  
	b.ne	setTo11				// if not equal to, branch to setTo11
	mov	hexChar, 10			// updates 10 into hexChar

setTo11:
	cmp	hexChar, 0x42			// start of if statment, cmp comparison
	b.ne	setTo12				// if not equal to, branch to setTo12
	mov	hexChar, 11			// updates 11 into hexChar

setTo12:
	cmp	hexChar, 0x43			// start of if statment, cmp comparison
	b.ne	setTo13				// if not equal to, branch to setTo13
	mov	hexChar, 12			// updates 12 into hexChar

setTo13:
	cmp	hexChar, 0x43			// start of if statment, cmp comparison	
	b.ne	setTo14				// if not equal to, branch to setTo14
	mov	hexChar, 13			// updates 13 into hexChar

setTo14:
	cmp	hexChar, 0x44			// start of if statment, cmp comparison
	b.ne	setTo15				// if not equal to, branch to setTo15
	mov	hexChar, 14			// updates 14 into hexChar

setTo15:
	mov	hexChar, 15			// updates 15 into hexChar
	b	initialize			// branch to initialize

decimal: 
	sub	hexChar,hexChar,0x30		// subtraction hexChar - 0x30
		
initialize:
	ldr	binary_N,0			// initialize binary_N to 0	
	mov	quotient, hexChar		// set value of quotient to hexChar
	ldr	i,0				// initialize i to 0
	mov	two, 2				// set value of two to 2

binLoop:	
	cmp	quotient,0			// compare quotient to 0
	b.le	increment			// if less than or equal to, branch to increment
		
	udiv	quotient,quotient,two		// divide quotient by 2
	sdiv	quotient, binary_N, two		// signed division
	msub	remainder, quotient, two, binary_N // multiply and subtract
	lsl	remainder, remainder, i		// left shit remainder by 1
	orr	binary_N, binary_N, remainder	// perform orr operation on binary_N with remainder
	add	i, i, 1				// increment i by 1
	
	b	binLoop				// repeat loop

increment:
	add	loopCount, loopCount, 1		// increment outer loop counter by 1

check:	
	cmp	loopCount, 4			// cmp loop counter with 4
	b.lt	next				// if still less than, branch to next
	b	end				// otherwise, branch to end

next:
	ldr	x0, =next_input			// load address for printing out next input prompt
	bl	printf				// calls printf
	b	top				// branch to top to repeat loop

	// end user input and converting loop 

end:
	// print out result
	ldr	x0, =binary_val			// load address for printing out binary result
	bl	printf				// calls printf
	ldr	x0, =result			// load address for printing out answer
	mov	x1, binary_N			// set value of x1 to binary_N
	bl	printf				// calls printf

	// end of program
done:	
	ldp 	x29, x30, [sp], 16              // Restores state of fp and lr, deallocates memory
        mov     x0, 0                           // return code is 0(no errors)
	ret                                     // Returns control to calling code(in OS)

	.data
	inputNumber:	.int	1
