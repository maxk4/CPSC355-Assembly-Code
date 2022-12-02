// Maximilian Kaczmarek
// UCID: 30151219
// Date: 2022-06-06
// Assignment 4
		.text				// program code is in .text section
size_prompt:	.string "Enter the size of the table:\n"
int_format:	.string	"%ld"			
output:		.string	" %1d "
newLine:	.string	"\n"
digit_prompt:	.string	"Enter a digit to search for (or press q to quit): "
occurrences:	.string	"Digit %d occurrences:\n"
coordinates:	.string	"%d. In (%d,%d)\n"

	// define macros
	define(input, x20)			// Set x20 to input variable
        define(row,x21)				// Set x21 to row variable
	define(column,x22)			// Set x22 to column variable
	define(offset,x23)			// Set x23 to offset variable
	define(base,x24)			// Set x24 to base variable
	define(size,x25)			// Set x25 to size variable
	define(randNum,w26)			// Set 32-bit register w26 to randNum variable
	define(digit,x27)			// Set x27 to digit variable
	define(timesFound,x28)			// Set x28 to timesFound

	.global main				// Makes "main" visible to the linker
	.balign 4                               // Aligns instructions
main: 	
	stp	 x29, x30, [sp, -16]!		// Allocates 16 bytes in stack memory(in RAM)
	mov 	 x29, sp                        // Updates FP to the current SP

	mov	row,0				// Initialize row to 0
	mov	offset,0			// Initialize offset to 0
	
	bl	clock				// gives round a starting value to start off with 
	bl	srand				// Calls srand C function

	//print statment
	ldr	x0, =size_prompt		// Loads the address of message
	bl	printf				// Calls printf

	
	//getting user input
	ldr	x0, =int_format			// Load address of int_format 	
	ldr	x1, =inputNum			// Load inputNum into arg for scanf
	bl	scanf				// Calls scanf function
	ldr	x1, =inputNum			// Load address for inputNum
	ldr	input, [x1]			// Save user input to input register
	
	// computing the size
	mul	size,input,input		// multiplying input by input and storing into size		
	mov	x0,-4				// setting x0 to -4
	mul	size,size,x0			// multiplying size by x0 and storing into size
	and	size,size,-16			// comparing size to -16 using the and operand


	// allocating space for the array, calculating base address
	add 	sp, sp, size
	mov	base,sp				//gives you an address you can use to access your array
	

rowLop: 
	cmp	row, input			// compare row index with input
	b.ge	endRow				// if greater than or equal to, branch to endRow
	mov	column, 0			// otherwise, set column to 0
	
colLop: 
	cmp	column, input			// compare column index to input
	b.ge	endCol	 			// if greater than or equal to, branch to endCol
	
random:	
	bl	rand				// Calls rand function
	and	randNum,w0,15			// and bitwise operation on number generated and 15, save into randomNum
	
	cmp	randNum,10			// compare randomNum generated with 10
	b.ge	random				// if greater than or equal to, branch back to random

	str	randNum, [base,offset]		// stores it to base address plus offset, which is storing to the array at that particular offset	
	ldr	x0, =output			// load address of output format string
	mov	w1, randNum			// move randNum into printf arg 
	bl	printf				// calls printf

	add	offset, offset, 4		//adding offsets to move to the next elemnt
	add	column, column, 1		// move to next element
	b	colLop				// branch to colLop

endCol:	
	ldr	x0, =newLine			// Loads address of format string
	bl	printf				// Calls printf
	
	add	row,row,1			// Move to next element
	b	rowLop				// Branch to rowLop


endRow:	
	// printing the user message
	ldr	x0, =digit_prompt		// load address of string literal
	bl	printf				// calls printf
	
	// getting user input
	ldr	x0, =int_format			// load address of int_format
	ldr	x1, =inputNum			// load address of inputNum
	bl	scanf				// calls scanf function

	// checks if scanf failed to read a numbers(if someone inputs nothing,exits)
	cmp	w0,0				// compare result of scanf with 0
	b.eq	done				// if equal, branch to done
	ldr	x1, =inputNum			// otherwise, load address of inputNum
	ldr	digit,[x1]			// save input into digit register

	// initializing
	mov	row, 0				// Set row to 0
	mov	column,0			// Set column to 0
	mov	offset,0			// Set offset to 0
	mov	timesFound,0			// Set timesFound to 0

	// print statment for result
	ldr	x0, =occurrences		// load address of occurences string literal	
	mov	x1, digit			// Move digit into first arg for printf
	bl	printf				// Calls printf
	 
rowCor:						// short for row coordinates
	// looping through the array		
	cmp	row,input			// compare row index with input
	b.ge	endRowC				// if greater than or equal to, branch to endRowC
	mov	column,0			// otherwise, set column to 0

columnCor:					// short for column coordinates
	cmp	column,input			// compare column with input
	b.ge	endColC				// if greater than or equal to, branch to endColC
	ldr	w0, [base,offset]		// loading 32 bytes from the array
	cmp	digit,x0			// Compare digit with the current element
	b.ne	finish				// if not equal, branch to finish

	//incrementing timesFound
	add	timesFound, timesFound,1	// otherwise, element has been found and increment count

	// printing the found coordinates
	ldr	x0, =coordinates		// load address of coordinates string literal
	mov	x1,timesFound			// move value of timesFound into first placeholder
	mov	x2,row				// move row index into second placeholder
	mov	x3,column			// move columm index into third placeholder
	bl	printf				// calls printf

finish: 
	add	offset,offset,4			// how you actually access it, offset is the offset in the long sequence
	add	column,column,1			// increment column counter
	b	columnCor			// branch to columnCor to repeat loop
	
endColC:					// short for end of the loop for row coordinates
	add 	row,row,1			// incrementing the row index
	b	rowCor				// branch to rowCor to check for end of row
	
endRowC:					// short for the end of the loop for the column coordinates (columnCor)
	b	endRow				// branch to endRow to repeat loop

	// end of program
done:	
	sub	sp,sp,size			// releasing the space allocated for the array
	ldp 	x29, x30, [sp], 16              // Restores state of fp and lr, deallocates memory
        mov     x0, 0                           // return code is 0(no errors)
	ret                                     // Returns control to calling code(in OS)

	.data
	inputNum:	.long	1
