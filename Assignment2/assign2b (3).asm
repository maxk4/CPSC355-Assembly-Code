// Maximilian Kaczmarek
// UCID: 30151219
// Date: 2022-05-17
// Assignment 1 version B

        .text
inputString: 		.string "%d"
outputString: 		.string "%lld\n"
printSum:   		.string "Sum: "
userMessageAscending: 	.string "The numbers are Ascending\n"
userMessageDescending: 	.string "The numbers are Descending\n"
userMessageNotInOrder: 	.string "The numbers are not in order\n"
userMessageNoValues: 	.string "There are no numbers\n"
userMessageOnlyOneDigit:.string "There is only one value\n"
userMessageNegativeValue:.string "No negative values allowed\n"

user_input: 		.string "Enter the number of positive integers you want:\n"

        .global main                            // Makes "main" visible to the linker
        .balign 4                               // Alligns it
main:   stp      x29, x30, [sp, -16]!           // Allocates 16 bytes in stack memory(in RAM)
        mov      x29, sp                        // Updates FP to the current SP

	define(orderLabel, x22)			// defining x22 to orderLabel
	define(loopCounter, x20)		// defining x20 as loopCounter
	define(currentNum, x23)			// defining x23 as currentNum
	define(sum, x21)			// defining x21 to sum

       	ldr	x0, =user_input			// set printf argument to message (loads the address)
	bl      printf                         	// call printf

        // Getting user input using the C function scanf
        ldr     x0, =inputString                // load address of inputString
        ldr     x1, =inputNumber                // load address of inputNumber
        bl      scanf                           // C function scanf
        ldr     x1, =inputNumber                // load address of inputNumber and store value in x1
        ldr     loopCounter, [x1]               // saves the user input, loading the address of x1 into x20

	// negative check
	str     loopCounter, [sp, 28]		// store value of loopCounter to address
      	ldr     w0, [sp, 28]			// load value into register
        cmp     w0, 0				// compare value to 0
        b.ge	tester				// if not negative, jump to tester and continue
        
	ldr	x0, =userMessageNegativeValue   // otherwise, print message
	bl	printf				// calls printf
	b	done				// branch to done to end program

tester:
        mov     orderLabel,0                    // initializing to zero, 4 = ascending
                                                // descending = 2
                                                // not in order = 5

                                                // extra test cases
                                                // no values = 0
                                                // only seen one value = 1

        mov  	sum,0                           // initialize value of sum to 0
	b	test			     	// branch to test
        	                              
check:  
	bl      rand                            // generate random integers
        add     sum, x0, sum                    // summing them up
        cmp     orderLabel,4                    // check if the squence is ascending so far
        b.ne    notAsc                          // moving to notAsc, ne = not equal to
	
        // ascending
        cmp     x0,currentNum                   // comparing the current random number to the previous random number
        b.ge    endSor                          // if greater, branch to endSor
        mov     orderLabel, 5                   // otherwise, set order label to not ascending
        b       endSor                          // no need to do any other condition, so branch to endSor


notAsc:                               
        // descending
        cmp     orderLabel, 2                   // comparing orderLabel to 2
        b.ne    notDes                          // If not equal, branch to notDes
        cmp     x0, currentNum                  // comparing x0 to currentNum
        b.le    endSor                          // if less than or equal to, branch to endSor
        mov     orderLabel, 5                   // comparing orderLabel to not in order(5)
        b       endSor                          // stop checking sort order

notDes:                           

        // not in order
        cmp     orderLabel,5                    // comparing orderLabel, to not in order(5)
        b.eq    endSor                          // eq = equal to, jumping to endSor

        // no values
        cmp     orderLabel,0                    // comparing orderLabel to the no value digit which is 0
        b.ne    value                           // ne = not equal, if it is not equal to value
        mov     orderLabel,1                    // seen only one value so updating orderLabel accordingly
        b       endSor                          // branching to endSor(go to endSor)

value:                      
        // only seen 1 value, check for ascending
        cmp     orderLabel,1                    // compare orderLabel to the only seen one value
        b.ne    endSor                          // done the condition so jumping to endSor
        cmp     x0,currentNum                   // comparing x0 to the current value
        b.le    desce                           // if its less than then jump to descend
        mov     orderLabel, 4                   // setting orderLabel to 4
        b       endSor                          // finished so end it by going to endSor

desce:                           

        // only seen 1 value, check for descending
        cmp     x0,currentNum                   // comparing currentNum to x0
        b.ge    endSor                          // no more conditions to check for so just jump to endSor
        mov     orderLabel,2                    // setting order label to 2
        b       endSor                          // done so go to endSor

endSor:                                 	// short for ending sorting
        mov     currentNum,x0                   // moving x0 to currentNumber, x0 is the random number
        mov     x1, x0                          // moving x0 into x1
        ldr     x0, =outputString               // setting argument for printf to message
        bl      printf                          // calling on printf
        sub     loopCounter,loopCounter,1       // Decrement loop counter by 1

test:	cmp	loopCounter,0			// compare loopCounter to 0
	b.ne	check				// if not equal, branch to check to return to loop
       
end:  
	ldr	x0, =printSum			// setting argument for printf to message
	bl	printf				// calls printf
        ldr     x0, =outputString               // setting the printf argument to message
        mov     x1,sum                          // use the sum as the second argument (for the placeholder)
        bl      printf                          // calls printf

        // ascending print statment
        cmp     orderLabel,4                    // compare order label with 4
        b.ne    desc                            // if not equal branch to desc
        ldr     x0,=userMessageAscending        // only do this instruction (print message) if comparison was equal

desc: 

        // descending print statment
        cmp     orderLabel, 2			// compare order label with 2
        b.ne    notdes				// if not equal, branch to notdes
        ldr     x0,=userMessageDescending	// set printf argument to message (load the address)

notdes:
        //not in order print statemnt
        cmp     orderLabel, 5			// compare order label with 5
        b.ne    order				// if not equal, branch to order
        ldr     x0,=userMessageNotInOrder	// set printf argument to message (load address)

order:
        //no values
        cmp     orderLabel,0			// compare order label with 0
        b.ne    pvalue				// if not equal, branch to pvalue
        ldr     x0,=userMessageNoValues		// set printf argument to message (load address)

pvalue:
        //digit only seen once
        cmp     orderLabel,1			// compare order label with 1
        b.ne    print				// if not equal, branch to print
        ldr     x0,=userMessageOnlyOneDigit	// set printf argument equal to message (load the address)

print:
        bl      printf				// calls printf

        // end of program
done:   ldp     x29, x30, [sp], 16              // Restores the state of fp and lr, deallocates memory
        mov     x0, 0                           // returns code  0 (no errors)
        ret                                     // Returns control to calling code(in OS)

        .data
        inputNumber:    .int    1
