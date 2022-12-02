// Maximilian Kaczmarek
// UCID: 30151219
// Date: 2022-05-24
// Assignment 3 version A

	.text
user_input: .string "Enter a decimal value:\n"
binary_val: .string "%ld"
hex_val:    .string "Your number in hexadecimal: "
result:	    .string "0x%016lX\n"		// 0x is just a string, % is a format specifier to say what's coming, 0 means pad with zeros not with spaces, 16 how many digits to print
neg_sign:   .string "-"
pos_sign:   .string "+"

	define(input, x20)			// define x20 as input

	.global main				// Makes "main" visible to the linker
	.balign 4                               // Aligns instructions
main: 	stp	 x29, x30, [sp, -16]!		// Allocates 16 bytes in stack memory(in RAM)
	mov 	 x29, sp                        // Updates FP to the current SP

	ldr	x0, =user_input			// set argument for printf to message (loads address)
	bl      printf                         	// call printf

	ldr	x0, =binary_val			// load address of inputString
        ldr     x1, =inputNumber		// load address of inputNumber
	bl      scanf				// C function scanf
	ldr	x1, =inputNumber		// load address of inputNumber
	ldr	input, [x1]			// saves the user input to x20, loading the value at address of x1 into x20 
	
	
	// handle negative numbers properly. If the binary number is negative, then convert it to its absolute value	
	
	cmp	input, 0			//comapring user input if it is less than 0
	b.ge	isPos				// if it is greater than or equal to then branch to Ispos

								
	// changing to 2's complement
	mvn	input,input			// movn instruction inverts input
	add	input,input,1			// adding 1
								

	ldr	x0, =neg_sign			// load address for printing out negative sign
	bl	printf				// calls printf
	b	isNeg				// branch to isNeg


isPos:			
	
	ldr	x0, =pos_sign			// otherwise, print out positive sign
	bl	printf				// calls printf


isNeg:						
	ldr	x0,=result			// loads address for printing out final result
	mov	x1,input			// set printf argument to input
	bl	printf				// calls printf

	
	// end of program
done:	ldp 	x29, x30, [sp], 16              // Restores state of fp and lr, deallocates memory
        mov     x0, 0                           // return code is 0(no errors)
	ret                                     // Returns control to calling code(in OS)

	.data
	inputNumber:	.long 	1
