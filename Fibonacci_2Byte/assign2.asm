**************************************
*
* Name: Jiaxin Li
* ID:
* Date:Feb 22 2018
* Lab2
*
* Program description: 
*
*I used a while loop to implement this program. Use NEXT to store the value of every step and inital NEXT equals 1 when N = 1 or 2
*At final, give the value of NEXT to RESULT
*
*
* Pseudocode:
*
* #define N 10
*
* int a; //two variables
* int b;
* 
* int count; //control while loop;
* int next; //store a+b
*
* int result;
*
* a = 0;
* b = 0;
* result = 0;
* count = 0;
* next = 0;
*
* next = 1; //when N = 1, 2
*
* a = 1; //the first two FBC number
* b = 1;
*
* count = 2; 
*
* while(count < N)
* {
*	next = a + b;
*	a = b;
*	b = next;
*
*	count ++;
*
* }
*	result = next;
*
**************************************

* start of data section

	ORG $B000
N       	FCB	10 

	ORG $B010
RESULT  	RMB     	2

* define any other variables that you might need here

DATAA	RMB	2
DATAB	RMB	2
COUNT	RMB	1
NEXT	RMB	2


	ORG $C000
* start of your program

	CLR	DATAA
	CLR	DATAA+1
	CLR	DATAB
	CLR	DATAB+1
	CLR	COUNT
	CLR	NEXT
	CLR	NEXT+1

	LDD	#$01
	STD	NEXT
	
	LDD	#$01
	STD	DATAA

	LDD	#$01
	STD	DATAB

	LDAA	#$02
	STAA	COUNT

WHILE	CMPA	N
	BHS	ENDWHILE
	LDD	DATAA
	ADDD	DATAB
	STD	NEXT

	LDD 	DATAB
	STD 	DATAA

	LDD	NEXT
	STD	DATAB
	
	INC	COUNT
	LDAA	COUNT
	BRA	WHILE

ENDWHILE	LDD	NEXT
	STD	RESULT

DONE	BRA	DONE

	END	



	




































