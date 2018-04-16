
* Name:Jiaxin Li

* Date:Apr 9th 2018
* Lab5
*
* Program description:
* This program is to get a number N from NARR array in the main program, use call-by-value in register 
* and transfer N to the subroutine.
* At subroutine, using stack make it transparent, use Lab4's code to calculate the fib value, 
* and using call-by-value over the stack transfer the result value to the main program.   
*
* Pseudocode of Main Program:
*
*
* unsigned int NARR[]= {1, 2, 5, 10, 20, 128, 254, 255, $00}; //two array store the initial and final value
* unsigned int RESARR[];
*
* unsigned int *p1;
* unsigned int *p2;
*
* p1 = &NARR[0];
* p2 = &RESARR[0];
*
* SENTIN = $00;
*
* while(*p1 != SENTIN)	//when $00, terminate the program
* {
*   
*   
*     *p2 = fbc(*p1); // *p1 use call-by-value in register A, hard to show in the pseudocode
*		
*     p1++;
*     p2 = p2+4;
*		
* }
*
*---------------------------------------
*
* Pseudocode of Subroutine:
*
* unsigned int a[] = {0, 0, 0, 0}; //two variables
* unsigned int b[] = {0, 0, 0, 0};
* unsigned int result[] = {0, 0, 0, 0};
* 
* unsigned int count; //control while loop;
*
*
* result = {0, 0, 0, 1}; //when NARR's value = 1, 2
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
*	result[0] = *(pa);  	//result = a + b; use call-by-value over the stack back to the main program
*			//hard to show in the Pseudocode.
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
NARR	FCB	1, 2, 5, 10, 20, 128, 254, 255, $00
SENTIN	EQU	$00

	ORG 	$B010
RESARR	RMB	32	

* define any variables that your MAIN program might need here
* REMEMBER: Your subroutine must not access any of the main
* program variables including NARR and RESARR.



	ORG 	$C000
	LDS	#$01FF		

* start of your main program

	LDX	#NARR	*//p1 = &NARR[0];
	LDY	#RESARR	*//p2 = &RESARR[0];
	
WHILE1	LDAA	0,X	*// *p1 != $00
	CMPA	#SENTIN
	BEQ	ENDWHILE1

	JSR	SUB	*//*p2 = fbc(*p1);
	
	PULA		*//call by value over the stack
	PULB
	STD	0,Y	*//get *p2 high value
	PULA
	PULB
	STD	2,Y	*//get *p2 low value

	INX		*//p1++

	LDAB	#4	*//p2 = p2+4
	ABY
	BRA	WHILE1

ENDWHILE1

DONE	BRA	DONE



* NOTE: NO STATIC VARIABLES ALLOWED IN SUBROUTINE
*       AND SUBROUTINE MUST BE TRANSPARENT TO MAIN PROGRAM


	ORG $D000
* start of your subroutine
	
SUB

	DES		*//open hole for return address
	DES
	DES
	DES
	
	PSHX		*//make subroutine transparent
	PSHY		*//in main program use A,B,X,Y,CC register
	PSHA
	PSHB
	TPA
	PSHA

	
	

			*//real function start
	
	DES		*//int a[] = {0, 0, 0, 0}
	DES
	DES
	DES			
	
	
	DES		*//int b[] = {0, 0, 0, 0}
	DES
	DES
	DES
	
		
	DES		*//int result[] = {0, 0, 0, 0}	
	DES
	DES
	DES

	
	DES		*//int count = 0

	TSX

	CLR	0,X

	CLR	1,X
	CLR	2,X
	CLR	3,X
	CLR	4,X
	
	CLR	5,X
	CLR	6,X
	CLR	7,X
	CLR	8,X

	CLR	9,X
	CLR	10,X
	CLR	11,X
	CLR	12,X


	LDAA	#1	
	STAA	4,X	*//result = {0, 0, 0, 1}

	STAA	12,X	*//*(pa + 3) = 1
	STAA	8,X	*//*(pb + 3) = 1

	LDAA	#2
	STAA	0,X	*//count = 2 

WHILE2	LDAA	0,X	*//must load again, it will increment at bottom
	CMPA	15,X	*//while(count < N)
	BHS	ENDWHILE2

	
	CLC		*//CF = 0

	LDAA	12,X	*//*pa = *pa + *pb + CF 
	ADCA	8,X
	STAA	12,X

	
	LDAA	11,X
	ADCA	7,X
	STAA	11,X

	LDAA	10,X
	ADCA	6,X
	STAA	10,X

	LDAA	9,X
	ADCA	5,X
	STAA	9,X



	LDD	11,X	*//result = 	a
	STD	3,X
	LDD	9,X
	STD	1,X


	LDD	7,X	*//a = b	
	STD	11,X
	LDD	5,X
	STD	9,X

	LDD	3,X	*//b = result
	STD	7,X
	LDD	1,X
	STD	5,X

	INC	0,X
	BRA	WHILE2
ENDWHILE2
	
	LDY	24,X	*//move up the return address
	STY	20,X
	
	LDD	1,X	*//load the result value in stack:call-by-value over the stack
	STD	22,X	*//the high two bytes
	LDD	3,X
	STD	24,X	*//the low two bytes


	INS
	
	INS
	INS
	INS
	INS

	INS
	INS
	INS
	INS
	
	INS
	INS
	INS
	INS

	PULA		*//regain the initial register value: transparent
	TAP
	PULB
	PULA
	PULY
	PULX
	
	RTS
