*************************
ORG	$B000
RESULT	RMB	1

	ORG	$C000
	LDS	#$01FF
	JSR	SUB
	PULA		*栈底放着处理好的数据
	STAA	RESULT	*提取出来给回RESULT，这他妈也太牛逼了，这是人类的大脑吗
	
DONE	BRA	DONE


	ORG	$D000

SUB	DES		*开个洞，放这个往上移的返回值
	PSHX		*把这些X，Y，A，CC都PUSH进去，一会儿再PULL出来
	PSHY
	PSHA
	TPA
	PSHA

	DES		*再开个洞，放这个处理的数据，其实这是真正这个函数要做的事情
	TSX
	LDAA	#5
	STAA	0,X
	INC	0,X

	LDY	8,X	*把返回的地址值提取出来让Y存着
	STY	7,X	*把返回的地址值提一个位置存回去
	LDAA	0,X	*把头上那个存着已经改变的变量值给A
	STAA	9,X	*把这个值给到栈底
	INS		*关闭那个栈顶临时存值的位置
	
	PULA		*把这几个寄存器的值提取出来
	TAP
	PULA
	PULY
	PULX
	
	RTS	
