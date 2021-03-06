**************************************
*
* Name: Jiaxin Li
* ID:
* Date: 21th Mar 2018
* Lab4
*
* Program description:this program is to get a number from NARR array, find this number is fib value, than store it in RESARR
* array as a 4 byte number. The main program uses a while loop to get every item in NARR and then transfer to subroutine to calculate * the fib value.  
* the item N passes by value from main program, and get back from stack. The subroutine is the same as the assign3'sprogram.
* 
*
* Pseudocode of Main Program:
*
* unsigned int NARR[]= {1, 2, 5, 10, 20, 128, 254, 255, 0}; //two array store the initial and final value
* unsigned int RESARR[];
*
* unsigned int *p1;
* unsigned int *p2;
*
* p1 = &NARR[0];
* p2 = &RESARR[0];
*
* while(*p1 != 0)
* {
*   *p2 = fbc(*p1); 
*		
*   p1++;
*   p2 = p2+4;
*		
* }
*
* 
*---------------------------------------
*
* Pseudocode of Subroutine:
* N passed by value from main program
*
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
   

*
**************************************

* start of data section
	ORG 	$B000
NARR	FCB	1, 2, 5, 10, 20, 128, 254, 255, $00
SENTIN	EQU	$00

	ORG 	$B010
RESARR	RMB	32	




	ORG 	$C000

	LDS	#$01FF	*//initial stack pointer

	
	LDX	#NARR	*//p1 = &NARR[0];
	LDY	#RESARR	*//p2 = &RESARR[0];

WHILE1	LDAA	0,X	*//*p1 != 0
	CMPA	#SENTIN
	BEQ	ENDWHILE1

	DES		*//open 4 holes store the RESARR value
	DES
	DES
	DES

	
	JSR	SUB	*//*p2 = fbc(*p1);

	
	PULA
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


* define any variables that your SUBROUTINE might need here


DATAA	RMB	4
DATAB	RMB	4
RESULT	RMB	4
COUNT	RMB	1
N	RMB	1




	ORG $D000
* start of your subroutine

SUB			*//same as the assign3
	
	PSHX		*//X,Y store the pointer value, must store in stack when execting the subroutine
	PSHY
	STAA	N

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
	
	LDD	RESULT
	STD	6,X	*//the high two bytes
	LDD	RESULT+2
	STD	8,X	*//the low two bytes

	PULY		*//get the main program pointer value
	PULX

	RTS
