// Maximilian Kaczmarek
// UCID: 30151219
// Date: 2022-05-17
// Assignment 1 version A

	.text
inputString: 		.string "%d"
outputString: 		.string "%lld\n"
printSum:		.string "Sum: "
userMessageAscending: 	.string "The numbers are Ascending\n"
userMessageDescending: 	.string "The numbers are Descending\n"
userMessageNotInOrder: 	.string "The numbers are not in order\n"
userMessageNoValues: 	.string "There are no numbers\n"
userMessageOnlyOneDigit:.string "There is only one value\n" 
userMessageNegativeValue:.string "No negative values allowed\n"

user_input: 		.string "Enter the number of positive integers you want:\n"

	.global main				// Makes "main" visible to the linker
	.balign 4                               // Aligns instructions
main: 	stp	 x29, x30, [sp, -16]!		// Allocates 16 bytes in stack memory(in RAM)
	mov 	 x29, sp                        // Updates FP to the current SP

	ldr	x0, =user_input			// set argument for printf to message (loads address)
	bl      printf                         	// call printf

	// Getting user input using the C function scanf
	ldr	x0, =inputString		// load address of inputString
        ldr     x1, =inputNumber		// load address of inputNumber
	bl      scanf				// C function scanf
	ldr	x1, =inputNumber		// load address of inputNumber
	ldr	x20, [x1]			// saves the user input to x20, loading the value at address of x1 into x20 

	// negative check
	str     x20, [sp, 28]			// store value of x20 to address specified	
        ldr     w0, [sp, 28]			// load value into register
        cmp     w0, 0				// compare value with 0
        b.ge    continue			// if greater, branch to continue

	ldr	x0, =userMessageNegativeValue	// set argument of printf to message
        bl      printf				// Calls printf
        b       done				// branch to done to end program

continue:
	mov     x22,0				// initializing to zero, 4 = ascending
						// descending = 2
						// not in order = 5

						// extra test cases
						// no values = 0
						// only seen one value = 1
							
	// loop test
	mov     x21,0                           // making a variable x21 for the sum
test:  	cmp     x20, 0  			// comparing 0 to x20(start of the loop)
	b.le    end				// exit condition(end of the loop), le = less than or equal to
	// end of the loop test
	bl      rand				// generate random integers
	add     x21, x0, x21			// summing them up
	cmp     x22,4				// if the sequence is ascending so far
	b.ne    notAsc			        // moving to notAsc, ne = not equal to
	
	// ascending
	cmp 	x0,x23				// comparing the current random number to the previous random number
	b.ge    endSor				// ending when it is greater, going to endSor
	mov     x22, 5				// otherwise, set x22 (order label) to 5
	b       endSor				// no need to do any other condition, so end it

notAsc: 			
	// descending
	cmp     x22, 2				// comparing x22 to 2
	b.ne    notDes				// moving to notDes
	cmp     x0, x23				// comparing x0 to x23
	b.le    endSor				// le is <=,  ending it
	mov     x22, 5				// comparing x22(the current value)to not in order(5)
	b       endSor				// stop checking sort order
	
notDes: 				
	// not in order
	cmp	x22,5				// comparing x22, to not in order(5)
	b.eq	endSor				// eq = equal to, jumping to endSor
	
	// no values
	cmp	x22,0				// comparing x22, to the no value digit which is 0
	b.ne    value				// ne = not equal, if value does exist, branch to value
	mov     x22,1				// seen only one value so updating x22 accordingly	
	b 	endSor				// branching to endSor(go to endSor)

value:
	// only seen 1 value, check for ascending 
	cmp 	x22,1				// compare x22 to the only seen one value
	b.ne	endSor				// done the condition so jumping to endSor
	cmp	x0,x23				// comparing x0 to the current value(x23)
	b.le	desce				// if its less than then jump to descend
	mov	x22, 4				// setting value of x22 to 4
	b	endSor				// finished so end it by going to endSor

desce: 
	// only seen 1 value, check for descending
	cmp	x0,x23				// comparing x23 to x0
	b.ge	endSor				// no more conditions to check for so just jump to endSor
	mov	x22,2				// set value of x22 to 2
	b	endSor				// done so go to endSor				

endSor:			
	mov	x23,x0				// moving x0 to x23, x0 is the random number  
	mov     x1, x0				// moving the register from x0 to x1
	ldr     x0, =outputString		// setting argument for printf
	bl      printf				// calling on printf
	sub     x20,x20,1			// decrementing x20 by 1 (loop counter)
	
	b       test				// branch to test to check for loop continue
	
end:
	ldr	x0, =printSum			// set argument for printf
	bl	printf				// calls printf

	ldr     x0, =outputString		// setting argument for printf to message
	mov     x1,x21				// set second argument for printf to the sum (x21)
	bl      printf				// calls printf
	
	// ascending print statment
	cmp 	x22,4				// making the if statment for ascending (cmp to 4)
	b.ne	desc				// if not equal jump to desc
	ldr	x0,=userMessageAscending 	// only do this instruction (print message) if the comparison was equal
	
desc:  				
	// descending print statment
	cmp 	x22, 2				// compare x22 to 2
	b.ne	notdes				// if not equal, branch to notdes
	ldr	x0,=userMessageDescending	// set printf argument to message (loads from address)

notdes:
	//not in order print statemnt
	cmp	x22, 5				// compare x22 with 5
	b.ne	order				// if not equal, branch to order
	ldr	x0,=userMessageNotInOrder	// set printf argument to message

order:
	//no values
	cmp	x22,0				// compare x22 to 0
	b.ne	pvalue				// if not equal, branch to pvalue
	ldr	x0,=userMessageNoValues		// set printf argument (loads address)

pvalue:
	//digit only seen once
	cmp 	x22,1				// compare x22 with 1
	b.ne	print				// if not equal, branch to print
	ldr	x0,=userMessageOnlyOneDigit	// set printf argument (loads from address)
	
print:
	bl	printf				// calls printf

	// end of program
done:	ldp 	x29, x30, [sp], 16              // Restores state of fp and lr, deallocates memory
        mov     x0, 0                           // return code is 0(no errors)
	ret                                     // Returns control to calling code(in OS)

	.data
	inputNumber:	.int 	1
