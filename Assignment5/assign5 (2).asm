// Maximilian Kaczmarek
// UCID: 30151219
// Date: 2022-06-08
// Assignment 5
		.text				// program code is in .text section
size_prompt:	.string "Enter the size of the table:\n"
int_format:	.string	"%ld"			
output:		.string	" %1d "
newLine:	.string	"\n"
digit_prompt:	.string	"Enter a digit to search for (or press q to quit): "
occurrences:	.string	"Digit %d occurrences:\n"
coordinates:	.string	"%d. In (%d,%d)\n"
pathname:	.string	"assign5.log"

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
	define(logfd,w19)			// Set w19 to logfd			
	define(printBuff,x26)			// Set x26 to printBuff
	

	.global main				// Makes "main" visible to the linker
	.balign 4                               // Alligns instructions
	
	alloc = -(16 + 5*8) & -16		// Allocating memory
	dealloc = -alloc			// Assembler equate for deallocating memory
	
initialize:
	stp      x29, x30, [sp,alloc]!     	// Allocate memory for subroutine in stack memory(in RAM)
        mov      x29, sp                        // Updates FP to the current SP
	
	str	input,[x29,16]			// store input to the part of memory sp is pointing to
	str	row,[x29, 24]			// store row register to specified address
	str	column,[x29,32]			// store column register to specified address
	str	offset,[x29,40]			// store offset to specified memory address
	str	base,[x29,48]			// store base register to address
		
	mov	row,0				// initialize row to 0
	mov	offset,0			// initialize offset to 0
        mov     base,x0                         // gives you an address you can use to access your array
	mov	input,x1			// move value of x1 into input register
	
rowLop:
        cmp     row, input                      // compare row index with input
        b.ge    endRow                          // if greater than or equal to, branch to endRow
        mov     column, 0                       // otherwise, set column to 0

colLop:
        cmp     column, input                   // compare column index to input
        b.ge    endCol                          // if greater than or equal to, branch to endCol

	//random number generator
	bl	randomNum			// branch to randomNum label
        str     w0, [base,offset]               // stores it to base address plus offset, which is storing to the array at that particular offset

        add     offset, offset, 4               // adding offsets to move to the next element
        add     column, column, 1               // move to next element
        b       colLop                          // branch to colLop

endCol:
        add     row,row,1                       // Move to next element
        b       rowLop                          // Branch to rowLop

endRow:
	ldr	input,[x29,16]			// loads value found at memory address into input register
	ldr	row,[x29,24]			// load value of row variable from address
	ldr	column,[x29,32]			// load value of column from address
	ldr	offset,[x29,40]			// load value of offset from specified address
	ldr	base,[x29,48]			// load value of base from address

  	ldp     x29, x30, [sp], dealloc        	// Restores state of fp and lr, deallocates memory
        ret                                     // Returns control to calling code(in OS)	
	alloc2 = -(16 + 1*8) & -16		// Allocate memory for subroutine
        dealloc2 = -alloc2			// Assembler equate for deallocating memory

randomNum:
	stp      x29, x30, [sp,alloc2]!         // Allocate memory for subroutine in stack memory(in RAM)
        mov      x29, sp                        // Updates FP to the current SP

	str	randNum,[x29,16]		// store randNum into specified address

random: bl      rand                            // Calls rand function
        and     randNum,w0,15                   // and bitwise operation on number generated and 15, save into randomNum

        cmp     randNum,10                      // compare randomNum generated with 10
        b.ge    random                          // if greater than or equal to, branch back to random
	
	mov	w0,randNum			// move randNum into w0
	ldr	randNum,[x29,16]		// load value into randNum from address

	ldp     x29, x30, [sp], dealloc2        // Restores state of fp and lr, deallocates memory
        ret                                    	// Returns control to calling code(in OS)
	alloc3 = -(16 + 5*8) & -16		// Allocate memory for subroutine
	dealloc3 = -alloc3			// Assembler equate for deallocating memory

display:
	stp      x29, x30, [sp,alloc3]!         // Allocate memory for subroutine in stack memory(in RAM)
        mov      x29, sp                        // Updates FP to the current SP

	str	input,[x29,16]			// Store value of input into specified address
	str	row,[x29,24]			// Store value of row register to specified address
	str	column,[x29,32]			// Store value of column to memory address
	str	offset,[x29,40]			// Store offset into specified address
	str	base,[x29,48]			// Store value of base into memory address
		
	mov	row,0				// Initialize row to 0
        mov     offset,0			// Initialize offset to 0
        mov     base,x0                         // Gives you an address you can use to access your array
        mov     input,x1			// Move x1 into input
	
rowLop2:
	ldr	x0,=output			// Loads address of output string literal
        cmp     row, input                      // compare row index with input
        b.ge    endRow2                         // if greater than or equal to, branch to endRow
        mov     column, 0                       // otherwise, set column to 0
	
colLop2:
        cmp     column, input                   // compare column index to input
        b.ge    endCol2                         // if greater than or equal to, branch to endCol

	ldr	x0,=output			// Loads address for printing out output message
        ldr     w1, [base,offset]               // Load value found at memory address into w1
	bl	printf				// Calls printf

        add     offset, offset, 4               //adding offsets to move to the next elemnt
        add     column, column, 1               // move to next element
        b       colLop2                         // branch to colLop2
	
endCol2:
        add     row,row,1                       // Move to next element
	ldr	x0,=newLine			// Loads address for new line string
	bl	printf				// Calls printf
        b       rowLop2                         // Branch to rowLop2

endRow2:
	ldr	input,[x29,16]			// Loads value at memory address into input register
	ldr	row,[x29,24]			// Load value into row register
	ldr	column,[x29,32]			// Load value into column register
	ldr	offset,[x29,40]			// Load value into offset from address
	ldr	base,[x29,48]			// Load value from memory address into base

	ldp     x29, x30, [sp], dealloc3        // Restores state of fp and lr, deallocates memory
        ret                                    	// Returns control to calling code(in OS)
	alloc3 = -(16 + 9*8) & -16		// Assembler equate for allocating memory for subroutine
        dealloc3 = -alloc3			// Assembler equate for deallocating memory for subroutine

search: 
	stp      x29, x30, [sp,alloc3]!         // Allocate memory for subroutine in stack memory(in RAM)
        mov      x29, sp                        // Updates FP to the current SP

	str     input,[x29,16]			// Store value of input into memory address 
        str     row,[x29,24]			// Store value of row register to address
        str     column,[x29,32]			// Store value of column into memory address
        str     offset,[x29,40]			// Store value of offset into specified address
        str     base,[x29,48]			// Store value of base into address
	str	digit,[x29,56]			// Store value of digit to its memory address
	str	timesFound,[x29,64]		// Store value of timesFound into memory 
	str	logfd,[x29,72]			// Store the logfile fd into memory address
	str	printBuff,[x29,80]		// Store value of printBuff into address

	mov     row,0				// Set value of row to 0
        mov     offset,0			// Set offset to 0
        mov     base,x0                         // gives you an address you can use to access your array
        mov     input,x1			// Move value of x1 into input
	mov	digit,x2			// Move value of x2 into digit
	mov	timesFound,0			// Set timesFound to 0
	mov	logfd,w3			// Set logfile fd to w3

rowCor:                                         // short for row coordinates
        // looping through the array
        cmp     row,input                       // compare row index with input
        b.ge    endRowC                         // if greater than or equal to, branch to endRowC
        mov     column,0                        // otherwise, set column to 0

columnCor:                                      // short for column coordinates
        cmp     column,input                    // compare column with input
        b.ge    endColC                         // if greater than or equal to, branch to endColC
        ldr     w0, [base,offset]               // loading 32 bytes from the array
        cmp     digit,x0                        // Compare digit with the current element
        b.ne    finish                          // if not equal, branch to finish

        //incrementing timesFound
        add     timesFound, timesFound,1        // otherwise, element has been found and increment count

        // printing the found coordinates
        ldr     x0, =coordinates                // load address of coordinates string literal
        mov     x1,timesFound                   // move value of timesFound into first placeholder
        mov     x2,row                          // move row index into second placeholder
        mov     x3,column                       // move columm index into third placeholder
        bl      printf                          // calls printf
	
	add     sp,sp,-16			// allocate bytes for printing
        mov     printBuff,sp			// set sp to printBuff
        mov     x0,printBuff			// Move printBuff to x0
        ldr     x1,=coordinates			// move coordinates into first placeholder
        mov     x2,timesFound			// move timesFound into second placeholder
	mov	x3,row				// Move value of row index into printf arg
	mov	x4,column			// Move value of column index into printf arg
        bl      sprintf				// Calls sprintf

        mov     x8,64                           // writes to the file
	mov	x2,x0				// Move x0 into x2
        mov     w0,logfd			// Move logfile fd into w0
        mov     x1,printBuff			// Move printBuff to x1
        svc     0				// Call sys function
        sub     sp,sp,-16			// Deallocate memory for printing

finish:
        add     offset,offset,4                 // how you actually access it, offset is the offset in the long sequence
        add     column,column,1                 // increment column counter
        b       columnCor                       // branch to columnCor to repeat loop

endColC:                                        // short for end of the loop for row coordinates
        add     row,row,1                       // incrementing the row index
        b       rowCor                          // branch to rowCor to check for end of row

endRowC:                                        // short for the end of the loop for the column coordinates (columnCor)
	
	ldr     input,[x29,16]			// Loads value of memory address into input
        ldr     row,[x29,24]			// Load value of row
        ldr     column,[x29,32]			// Load value of column
        ldr     offset,[x29,40]			// Load value of offset from memory address
        ldr     base,[x29,48]			// Load value of base from address
	ldr	digit,[x29,56]			// Load value found at memory address into digit register
	ldr	timesFound,[x29,64]		// Load value of timesFound
	ldr	logfd,[x29,72]			// load value of fd for logfile
	ldr	printBuff,[x29,80]		// Load value from memory address into printBuff

	ldp     x29, x30, [sp], dealloc3        // Restores state of fp and lr, deallocates memory
        ret                                    	// Returns control to calling code(in OS)
       	alloc4 = -(16 + 7*8) & -16		// Assembler equate for allocating memory for subroutine
       	dealloc4 = -alloc4			// Assembler equate for deallocating memory for subroutine

logFile:
        stp      x29, x30, [sp,alloc4]!         // Allocates memory for subroutine in stack memory(in RAM)
        mov      x29, sp                        // Updates FP to the current SP

    	str     input,[x29,16]			// Store value of input to address
        str     row,[x29,24]			// Store value of row into memory address
        str     column,[x29,32]			// Store value of column into address
        str     offset,[x29,40]			// Store value of offset into address
        str     base,[x29,48]			// Store value of base into memory address
	str	logfd,[x29,56]			// Store value of fd into specified address
	str	printBuff,[x29,64]		// Store value of printBuff into memory address
	
        mov     row,0				// Set row to 0
        mov     offset,0			// Set offset to 0
        mov     base,x0                         // gives you an address you can use to access your array
        mov     input,x1			// move x1 into input register
	mov	logfd,w2			// move w2 into logfile fd

rowLop3:
        cmp     row, input                      // compare row index with input
        b.ge    endRow3                         // if greater than or equal to, branch to endRow
        mov     column, 0                       // otherwise, set column to 0

colLop3:
        cmp     column, input                   // compare column index to input
        b.ge    endCol3                         // if greater than or equal to, branch to endCol

	add	sp,sp,-16			// allocating bytes for printing
	mov	printBuff,sp			// setting sp to printBuff
	mov	x0,printBuff			// move printBuff as first arg
	ldr	x1,=output			// Loads address of string literal output
	ldr	w2,[base,offset]		// loads value found at address into w2
	bl	sprintf				// calls sprintf

	mov	x8,64				// writes to the file
	mov	w0,logfd			// moves logfile fd into w0
	mov	x1,printBuff			// moves printBuff into x1
	
	mov	x2, x0				
	svc	0				// system call

	sub	sp,sp,-16			// deallocate memory for printing
        add     offset, offset, 4               // adding offsets to move to the next element
        add     column, column, 1               // move to next element
        b       colLop3                         // branch to colLop3

endCol3:
        add     row,row,1                       // Move to next element
        
	mov	w0,logfd			// move logfile fd into w0
	ldr	x1,=newLine			// load address of new line string literal
	mov	x2,1				// move 1 into x2
        mov	x8,64				// service request 64, write to file
	svc	0				// system call
        b       rowLop3                         // Branch to rowLop3
	
endRow3:

        ldr     input,[x29,16]			// Load value of input from specified address
        ldr     row,[x29,24]			// Loads value into row register from memory address
        ldr     column,[x29,32]			// Loads value of column from address
        ldr     offset,[x29,40]			// Loads value of offset from address
        ldr     base,[x29,48]			// Loads value into base register
	ldr	logfd,[x29,56]			// Loads value for logfd from address
	ldr	printBuff,[x29,64]		// Loads value found at address into printBuff

        ldp     x29, x30, [sp], dealloc4        // Restores state of fp and lr, deallocates memory
        ret                                    	// Returns control to calling code(in OS)

main: 	
	stp	 x29, x30, [sp, -16]!		// Allocates 16 bytes in stack memory(in RAM)
	mov 	 x29, sp                        // Updates FP to the current SP
	
	 // open file code
        mov     x8,56				// service request 56 = open file
        mov     x0,-100				// AT_FDCWD = -100
        ldr     x1,=pathname			// loads address of pathname string literal
        mov     x2,01 | 0100 | 01000            // write-only access or optional flag of create file if it doesn't exit, also truncate a existing file
        mov     x3,0700                         // optional argument that specifies UNIX file permissions
        svc     0                               // call system function
        mov     logfd,w0			// move w0 to fd for logfile

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
	add 	sp, sp, size			// allocating bytes for array
	mov	base,sp				// gives you an address you can use to access your array
	mov	x0, base			// move base into x0
	mov	x1,input			// move value of input into x1
	bl	initialize			// branch to initialize 
	
	mov	x0,base				// move base address into x0
	mov	x1,input			// move value of input into x1
	bl	display				// branch to display

	mov	x0,base				// move base into x0
	mov	x1,input			// move input into x1
	mov	w2,logfd			// move logfile fd into w2
	bl	logFile				// branch to logFile label

	// printing the user message
prompt:	ldr	x0, =digit_prompt		// load address of string literal
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
		
	// print statment for result
	ldr	x0, =occurrences		// load address of occurences string literal	
	mov	x1, digit			// Move digit into first arg for printf
	bl	printf				// Calls printf

	add     sp,sp,-32			// allocating bytes for printing
        mov     printBuff,sp			// move sp into printBuff
        mov     x0,printBuff			// move printfBuff into x0
        ldr     x1,=occurrences			// loads address of string literal for first printf arg
        mov	x2,digit			// move value of digit into x2
        bl      sprintf				// branch to sprintf

        mov     x8,64                           // writes to the file
        mov     x2,x0				// set value of x2 to w0
        mov     w0,logfd			// move logfd into w0
        mov     x1,printBuff			// move printBuff into x1
        svc     0				// call sys function
        sub     sp,sp,-32			// deallocating memory for printing

	mov	x0,base				// move base address into x0
	mov	x1,input			// move input into x1
	mov	x2,digit			// move value of digit into x2
	mov	w3,logfd			// move the logfile file descriptor into w3
	bl	search				// branch to search label
	b	prompt				// branch to prompt

	// end of program
done:	
	mov     w0,logfd                        // 1st arg (fd)
        mov     x8,57                           // close I/O request
        svc     0                               // call sys function
	sub	sp,sp,size			// releasing the space allocated for the array
	ldp 	x29, x30, [sp], 16              // Restores state of fp and lr, deallocates memory
        mov     x0, 0                           // return code is 0(no errors)
	ret                                     // Returns control to calling code(in OS)

	.data
	inputNum:	.long	1
