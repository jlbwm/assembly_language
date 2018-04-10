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
* unsigned int NARR[]= {1, 2, 5, 10, 20, 40, 50, 60, $FF}; //two array store the initial and final value
* unsigned int RESARR[];
*
* unsigned int *p1;
* unsigned int *p2;
*
* p1 = &NARR[0];
* p2 = &RESARR[0];
*
* while(*p1 != SENTIN && *p1 != 0)	//when $FF and $00, terminate the program
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
NARR	FCB	1, 2, 5, 10, 20, 40, 50, 60, $FF
SENTIN	EQU	$FF

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
	
WHILE1	LDAA	0,X	*// *p1 != $FF
	CMPA	#SENTIN
	BEQ	ENDWHILE1
	CMPA	#$00	*// *p1 != $00
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


DATAA	RMB	4
DATAB	RMB	4
RESULT	RMB	4
COUNT	RMB	1
N	RMB	1



	ORG $D000
* start of your subroutine
	
SUB	STAA	N	*//call-by-value in register A call-by-value in register A

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
	
	LDX	#DATAA	*//int a[] = {0, 0, 0, 0}
	LDY	#DATAB 	*//int b[] = {0, 0, 0, 0}
	
	CLR	0,X 	
	CLR	1,X
	CLR	2,X
	CLR	3,X

	CLR	0,Y
	CLR	1,Y
	CLR	2,Y
	CLR	3,Y

	CLR	RESULT	*//int result[] = {0, 0, 0, 0}	
	CLR	RESULT+1
	CLR	RESULT+2
	CLR	RESULT+3
	
	CLR	COUNT	*//int count = 0


	LDAA	#1	
	STAA	RESULT+3	*//result = {0, 0, 0, 1}

	STAA	3,X	*//(pa + 3) = 1
	STAA	3,Y	*//(pb + 3) = 1

	LDAA	#2
	STAA	COUNT	*//count = 2 

WHILE2	LDAA	COUNT	*//must load again, it will increment at bottom
	CMPA	N	*//while(count < N)
	BHS	ENDWHILE2

	LDAB	#4	*//int arraycount = 4

	LDX	#DATAA+3	*//pa+3
	LDY	#DATAB+3	*//pb+3

	CLC		*//CF = 0

DO	LDAA	0,X	*//*pa = *pa + *pb + CF 
	ADCA	0,Y
	STAA	0,X

	DEX		*//pa-- 
	DEY		*//pb-- 

	DECB		*//arraycount-- 

UNTIL	BNE	DO	*//DECB will set the z flag, no need to have CMP
ENDDO

	LDX	#DATAA	*//pa = &a[0] set again to exchange value later	
	LDY	#DATAB	*//pb = &b[0]

	LDD	0,X	*//result = a + b
	STD	RESULT
	LDD	2,X
	STD	RESULT+2

	LDD	DATAB	*//a = b	
	STD	DATAA
	LDD	DATAB+2
	STD	DATAA+2

	LDD	RESULT	*//b = result
	STD	DATAB
	LDD	RESULT+2
	STD	DATAB+2

	INC	COUNT
	BRA	WHILE2
ENDWHILE2
	
	TSX		*//start operate the stack

	LDY	11,X	*//move up the return address
	STY	7,X
	
	LDD	RESULT	*//load the result value in stack:call-by-value over the stack
	STD	9,X	*//the high two bytes
	LDD	RESULT+2
	STD	11,X	*//the low two bytes

	PULA		*//regain the initial register value: transparent
	TAP
	PULB
	PULA
	PULY
	PULX
	
	RTS


