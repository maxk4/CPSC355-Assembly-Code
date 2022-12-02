// Maximilian Kaczmarek
// UCID 30151219
// CPSC 355 Assignment 1

#include <stdio.h>
#include <stdlib.h>

/**
 * Main method of program
 * 
 * @param argc the number of arguments passed to the program
 * @param argv the array of arguments passed to the program
 */
void main(int argc, char *argv[]) {
    FILE *outFile; // create file pointer for output file
    outFile = fopen("assign1.log", "w"); // open output file

    // get input from user from command line
    int arraySize = atoi(argv[1]);  // atoi function converts string to integer

    // check for valid input
    if (arraySize < 1 || argc != 2) {
        printf("Invalid input\n");
        exit(1);
    }

    // declare 2D array for table with arraySize rows and arraySize columns
    int table[arraySize][arraySize];

    // populate 2D array with random numbers by calling helper method
    for (int i = 0; i < arraySize; i++) {
        for (int j = 0; j < arraySize; j++) {
            table[i][j] = randomNum(0,9);
        }
    }
    
    // display 2D array
    for (int i = 0; i < arraySize; i++) {
        for (int j = 0; j < arraySize; j++) {
            fprintf(outFile, "%d ", table[i][j]); // write to file 
            printf("%d ", table[i][j]);
        }
        logToFile(outFile, "\n"); // write to file
        printf("\n");
    }

    // initialize variables for while loop
    int digitToSearchFor;
    char input[100];

    while (1) {
        printf("\nEnter a digit to search for (or press q to quit): ");
        logToFile(outFile, "Enter a digit to search for (or press q to quit): \n"); // write to file
        scanf("%s", input);
	fscanf(outFile,"%c",input);
	fputs(input,outFile);

        // check if user wants to quit
        if ( input[0] == 'q' ) {
            printf("Exiting!\n");
            logToFile(outFile, "Exiting!\n"); // write to file
            break;
        }

        // otherwise receive input from user for digit to search for
        if (sscanf(input, "%d", &digitToSearchFor) == 1) {

		if (digitToSearchFor < 0) {
			printf("No negative numbers allowed");
			logToFile(outFile, "No negative numbers allowed\n"); // write to file
			continue;
		}

            int timesFound = 0; // declare variable to hold number of times digit is found
            int coordinate = 0; // declare variable to hold coordinate of digit found

            printf("\n");
            // loop through 2d array and check if digit is found and save its coordinates
            for (int i = 0; i < arraySize; i++) {
                for (int j = 0; j < arraySize; j++) {
                    if (table[i][j] == digitToSearchFor) {
                        // increment variables if digit found
                        timesFound++;
                        coordinate++;

                        // print out the coordinates of the digit
                        printf("%d: %s %d, %d\n", coordinate, "Digit found at coordinate", i, j);
                        fprintf(outFile, "%d: %s %d, %d\n", coordinate, "Digit found at coordinate", i, j); // write to file
                    }
                }
            }

            // print number of times digit is found
            printf("\n%s %d %s\n", "Your digit occurs", timesFound, "times.");
            fprintf(outFile, "%s %d %s\n", "Your digit occurs", timesFound, "times."); // write to file

            // variables for percentage calculation
            int totalElements = arraySize * arraySize;
            double percentage;

            // calculate what percentage of the matrix the digit makes up
            percentage = (double) timesFound / (double) totalElements * 100;
            // convert percentage to integer
            int percentageInt = (int) percentage; 

            // print what percentage of the matrix the digit is
            printf("%s %d %s %d %s\n", "The digit", digitToSearchFor, "is", percentageInt, "% of the matrix.");
            fprintf(outFile, "%s %d %s %d %s\n", "The digit", digitToSearchFor, "is", percentageInt, "% of the matrix.\n"); // write to file
        }

        // if input is not a digit or q
        else {  
            printf("Invalid input\n");
            logToFile(outFile, "Invalid input!"); // write to file
        }
    } 

    fclose(outFile); // close file
    exit(0); // exit program successfully 
}

/** 
 * Helper method to generate random number
 * 
 * @param m the minimum value of the random number (0)
 * @param n the maximum value of the random number (9)
 * @return the random number
 */
int randomNum(int m, int n) {
    // generate random number between min and max using rand() function
    return rand() % (m - n + 1) + m; 
}

/** 
 * Helper method to write to file
 * 
 * @param outFile the file pointer to the output file
 * @param string the message to write to the file
 */
void logToFile(FILE *outFile, char *string) {
    // write to file
    fprintf(outFile, "%s", string);
}
