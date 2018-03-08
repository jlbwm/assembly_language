
*
* Name:Jiaxin Li
* ID:
* Date:March 6th 2018
* Lab3
*
* Program description: generate the Nth number in the Fibonacci sequence. Use 4 Byte array a, b and result to add and store. have two loops.
* The Do-until loop charge of add with carry flag. And the while loop charge of add from the 3th number to Nth number. All stored as unsigned  
* int data type.  
*
* Pseudocode:
*
* #define N 10
*
* unsigned int a[] = {0, 0, 0, 0}; //two variables
* unsigned int b[] = {0, 0, 0, 0};
* unsigned int result[] = {0, 0, 0, 0};
* 
* unsigned int count; //control while loop;
*
*
* result = {0, 0, 0, 1}; //when N = 1, 2
*
* unsigned int *pa;//two pointer, operate the array
* unsigned int *pb;
* 
* *(pa + 3) = 1; //give a and b inital value 1 of number 1 and 2
* *(pb + 3) = 1;
*
* *int CF; //carry flag
*
*
* count = 2;
*
* while(count < N)
* {
*	unsigned int arraycount = 4;
*
*	pa+3; //go to high position
*	pb+3; 
*	CF = 0;
*
*	do
*	{
*		*pa = *pa + *pb + CF; //array add, store in array a
*		pa--;
*		pa--;
*		arraycount--;
*
*	}while(arraycount != 0)
*
*	pa = &a[0];
*	pb = &b[0];
*
*	result[0] = *(pa);  	//result = a + b;
*	result[1] = *(pa+1);
*	result[2] = *(pa+2);
*	result[3] = *(pa+3);
*
*	*pb = *pa;			//a = b;
*	*(pb+1) = *(pa+1);
*	*(pb+2) = *(pa+2);
*	*(pb+3) = *(pa+3);
*
*	*pa = result[0];		//b = result;
*	*(pa+1) = result[1];
*	*(pa+2) = result[2];
*	*(pa+3) = result[3];
*	
*	count++;
*  }





**************************************

* start of data section


	ORG 	$B000
N       	FCB    	40 

	ORG 	$B010
RESULT  	RMB     	4

* define any other variables that you might need here

DATAA	RMB	4
DATAB	RMB	4
COUNT	RMB	1


* start of your program
 
	ORG  	$C000

	LDX	#DATAA	*int a[] = {0, 0, 0, 0}*
	LDY	#DATAB 	*int b[] = {0, 0, 0, 0}*

	CLR	0,X 	
	CLR	1,X
	CLR	2,X
	CLR	3,X

	CLR	0,Y
	CLR	1,Y
	CLR	2,Y
	CLR	3,Y

	CLR	RESULT	*int result[] = {0, 0, 0, 0}*	
	CLR	RESULT+2

	CLR	COUNT	*int count = 0*
	

	LDAA	#1	
	STAA	RESULT+3	*result = {0, 0, 0, 1}*
	
	STAA	3,X	*(pa + 3) = 1*
	STAA	3,Y	*(pb + 3) = 1*

	LDAA	#$02
	STAA	COUNT	*count = 2 *


WHILE	LDAA	COUNT	*must load again, it will increment at bottom*
	CMPA	N	*while(count < N)*
	BHS	ENDWHILE
	
	LDAB	#4	*int arraycount = 4*
	
	LDX	#DATAA+3	*pa+3*
	LDY	#DATAB+3	*pb+3*
	
	CLC		*CF = 0*

DO	LDAA	0,X	* *pa = *pa + *pb + CF *
	ADCA	0,Y
	STAA	0,X

	DEX		* pa-- *
	DEY		* pb-- *

	DECB		* arraycount-- * *DECB will set the z flag, no need to have CMP()*

UNTIL	BNE	DO
ENDDO

	LDX	#DATAA	*pa = &a[0]*  *set again to exchange value later*
	LDY	#DATAB	*pb = &b[0]*

	LDD	0,X	*result = a + b*
	STD	RESULT
	LDD	2,X
	STD	RESULT+2

	LDD	DATAB	*a = b*	
	STD	DATAA
	LDD	DATAB+2
	STD	DATAA+2

	LDD	RESULT	*b = result*
	STD	DATAB
	LDD	RESULT+2
	STD	DATAB+2

	INC	COUNT
	BRA	WHILE
ENDWHILE


DONE	BRA	DONE
	END
	
	







