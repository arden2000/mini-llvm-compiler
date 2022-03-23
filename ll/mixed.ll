declare i8* @malloc(i32)
declare void @free(i8*)
declare i32 @printf(i8*, ...)
declare i32 @scanf(i8*, ...)

@.d = private unnamed_addr constant [3 x i8] c"%d\00", align 1
@.d.space = private unnamed_addr constant [4 x i8] c"%d \00", align 1
@.nl = private unnamed_addr constant [4 x i8] c"%d\0A\00", align 1


%struct.simple = type {i32}
%struct.foo = type {i32, i1, %struct.simple*}

@globalfoo = global %struct.foo* null

define void @tailrecursive(i32 %num1) {
	%num = alloca i32
	store i32 %num1, i32* %num
	br label %L17

L17:
	%r2 = add i32 0, 0
	%r1 = icmp sle i32 %num, %r2
	br i1 %r1, label %L19, label %L21

L19:
	br label %END

END:
	ret void

L21:
	%r6 = add i32 0, 1
	%r5 = sub i32 %num, %r6
	call void @tailrecursive(i32 %r5)

END:
	ret void
}

define i32 @add(i32 %x1, i32 %y1) {
	%return = alloca i32
	%x = alloca i32
	%y = alloca i32
	store i32 %x1, i32* %x
	store i32 %y1, i32* %y
	br label %L26

L26:
	%r7 = add i32 %x, %y
	store i32 %r7, i32* %return
	br label %END

END:
	%r8 = load i32, i32* %return
	ret i32 %r8
}

define void @domath(i32 %num1) {
	%math1 = alloca %struct.foo*
	%math2 = alloca %struct.foo*
	%tmp = alloca i32
	%num = alloca i32
	store i32 %num1, i32* %num
	br label %L35

L35:
	%r10 = call i8* @malloc(i32 12)
	%r9 = bitcast i8* %r10 to %struct.foo*
	store %struct.foo* %r9, %struct.foo** %math1
	%r12 = call i8* @malloc(i32 4)
	%r11 = bitcast i8* %r12 to %struct.simple*
	%r15 = load %struct.foo*, %struct.foo** %math1
	%r14 = getelementptr %struct.foo, %struct.foo* %r15, i32 0, i32 2
	%r13 = load %struct.simple*, %struct.simple** %r14
	store i32 %r11, i32* %r13
	%r17 = call i8* @malloc(i32 12)
	%r16 = bitcast i8* %r17 to %struct.foo*
	store %struct.foo* %r16, %struct.foo** %math2
	%r19 = call i8* @malloc(i32 4)
	%r18 = bitcast i8* %r19 to %struct.simple*
	%r22 = load %struct.foo*, %struct.foo** %math2
	%r21 = getelementptr %struct.foo, %struct.foo* %r22, i32 0, i32 2
	%r20 = load %struct.simple*, %struct.simple** %r21
	store i32 %r18, i32* %r20
	%r23 = load i32, i32* %num
	%r26 = load %struct.foo*, %struct.foo** %math1
	%r25 = getelementptr %struct.foo, %struct.foo* %r26, i32 0, i32 0
	%r24 = load i32, i32* %r25
	store i32 %r23, i32* %r24
	%r27 = add i32 0, 3
	%r30 = load %struct.foo*, %struct.foo** %math2
	%r29 = getelementptr %struct.foo, %struct.foo* %r30, i32 0, i32 0
	%r28 = load i32, i32* %r29
	store i32 %r27, i32* %r28
	%r32 = load %struct.foo*, %struct.foo** %math1
	%r31 = getelementptr %struct.foo, %struct.foo* %r32, i32 0, i32 0
	%r37 = load %struct.foo*, %struct.foo** %math1
	%r36 = getelementptr %struct.foo, %struct.foo* %r37, i32 0, i32 2
	%r35 = load %struct.simple*, %struct.simple** %r36
	%r34 = getelementptr %struct.simple, %struct.simple* %r35, i32 0, i32 0
	%r33 = load i32, i32* %r34
	store i32 %r31, i32* %r33
	%r39 = load %struct.foo*, %struct.foo** %math2
	%r38 = getelementptr %struct.foo, %struct.foo* %r39, i32 0, i32 0
	%r44 = load %struct.foo*, %struct.foo** %math2
	%r43 = getelementptr %struct.foo, %struct.foo* %r44, i32 0, i32 2
	%r42 = load %struct.simple*, %struct.simple** %r43
	%r41 = getelementptr %struct.simple, %struct.simple* %r42, i32 0, i32 0
	%r40 = load i32, i32* %r41
	store i32 %r38, i32* %r40
	br label %L45

L45:
	%r46 = add i32 0, 0
	%r45 = icmp sgt i32 %num, %r46
	br i1 %r45, label %L47, label %L54

L47:
	%r49 = load %struct.foo*, %struct.foo** %math1
	%r48 = getelementptr %struct.foo, %struct.foo* %r49, i32 0, i32 0
	%r51 = load %struct.foo*, %struct.foo** %math2
	%r50 = getelementptr %struct.foo, %struct.foo* %r51, i32 0, i32 0
	%r47 = mul i32 %r48, %r50
	store i32 %r47, i32* %tmp
	%r57 = load %struct.foo*, %struct.foo** %math1
	%r56 = getelementptr %struct.foo, %struct.foo* %r57, i32 0, i32 2
	%r55 = load %struct.simple*, %struct.simple** %r56
	%r54 = getelementptr %struct.simple, %struct.simple* %r55, i32 0, i32 0
	%r53 = mul i32 %tmp, %r54
	%r59 = load %struct.foo*, %struct.foo** %math2
	%r58 = getelementptr %struct.foo, %struct.foo* %r59, i32 0, i32 0
	%r52 = sdiv i32 %r53, %r58
	store i32 %r52, i32* %tmp
	%r64 = load %struct.foo*, %struct.foo** %math2
	%r63 = getelementptr %struct.foo, %struct.foo* %r64, i32 0, i32 2
	%r62 = load %struct.simple*, %struct.simple** %r63
	%r61 = getelementptr %struct.simple, %struct.simple* %r62, i32 0, i32 0
	%r66 = load %struct.foo*, %struct.foo** %math1
	%r65 = getelementptr %struct.foo, %struct.foo* %r66, i32 0, i32 0
	%r60 = call i32 @add(i32 %r61, i32 %r65)
	store i32 %r60, i32* %tmp
	%r69 = load %struct.foo*, %struct.foo** %math2
	%r68 = getelementptr %struct.foo, %struct.foo* %r69, i32 0, i32 0
	%r71 = load %struct.foo*, %struct.foo** %math1
	%r70 = getelementptr %struct.foo, %struct.foo* %r71, i32 0, i32 0
	%r67 = sub i32 %r68, %r70
	store i32 %r67, i32* %tmp
	%r73 = add i32 0, 1
	%r72 = sub i32 %num, %r73
	store i32 %r72, i32* %num
	br label %L45

L54:
	%r75 = load %struct.foo*, %struct.foo** %math1
	%r74 = getelementptr %struct.foo, %struct.foo* %r75, i32 0, i32 2
	%r76 = bitcast %struct.simple* %r74 to i8*
	call void @free(i8* %r76)
	%r78 = load %struct.foo*, %struct.foo** %math2
	%r77 = getelementptr %struct.foo, %struct.foo* %r78, i32 0, i32 2
	%r79 = bitcast %struct.simple* %r77 to i8*
	call void @free(i8* %r79)
	%r80 = load %struct.foo*, %struct.foo** %math1
	%r81 = bitcast %struct.foo* %r80 to i8*
	call void @free(i8* %r81)
	%r82 = load %struct.foo*, %struct.foo** %math2
	%r83 = bitcast %struct.foo* %r82 to i8*
	call void @free(i8* %r83)

END:
	ret void
}

define void @objinstantiation(i32 %num1) {
	%tmp = alloca %struct.foo*
	%num = alloca i32
	store i32 %num1, i32* %num
	br label %L63

L63:
	%r85 = add i32 0, 0
	%r84 = icmp sgt i32 %num, %r85
	br i1 %r84, label %L65, label %EmptyNode0

L65:
	%r87 = call i8* @malloc(i32 12)
	%r86 = bitcast i8* %r87 to %struct.foo*
	store %struct.foo* %r86, %struct.foo** %tmp
	%r88 = load %struct.foo*, %struct.foo** %tmp
	%r89 = bitcast %struct.foo* %r88 to i8*
	call void @free(i8* %r89)
	%r91 = add i32 0, 1
	%r90 = sub i32 %num, %r91
	store i32 %r90, i32* %num
	br label %L63

END:
	ret void
}

define i32 @ackermann(i32 %m1, i32 %n1) {
	%return = alloca i32
	%m = alloca i32
	%n = alloca i32
	store i32 %m1, i32* %m
	store i32 %n1, i32* %n
	br label %L73

L73:
	%r93 = add i32 0, 0
	%r92 = icmp eq i32 %m, %r93
	br i1 %r92, label %L75, label %L78

L75:
	%r95 = add i32 0, 1
	%r94 = add i32 %n, %r95
	store i32 %r94, i32* %return
	br label %END

END:
	%r96 = load i32, i32* %return
	ret i32 %r96

L78:
	%r98 = add i32 0, 0
	%r97 = icmp eq i32 %n, %r98
	br i1 %r97, label %L80, label %L84

L80:
	%r101 = add i32 0, 1
	%r100 = sub i32 %m, %r101
	%r99 = call i32 @ackermann(i32 %r100, i32 1)
	store i32 %r99, i32* %return
	br label %END

END:
	%r103 = load i32, i32* %return
	ret i32 %r103

L84:
	%r106 = add i32 0, 1
	%r105 = sub i32 %m, %r106
	%r110 = add i32 0, 1
	%r109 = sub i32 %n, %r110
	%r107 = call i32 @ackermann(i32 %m, i32 %r109)
	%r104 = call i32 @ackermann(i32 %r105, i32 %r107)
	store i32 %r104, i32* %return
	br label %END

END:
	%r111 = load i32, i32* %return
	ret i32 %r111
}

define i32 @main() {
	%return = alloca i32
	%a = alloca i32
	%b = alloca i32
	%c = alloca i32
	%d = alloca i32
	%e = alloca i32
	br label %L92

L92:
	call i32 (i8*, ...) @scanf(i8* getelementptr inbounds ([3 x i8], [3 x i8]* @.d, i32 0, i32 0), i32* %a)
	call i32 (i8*, ...) @scanf(i8* getelementptr inbounds ([3 x i8], [3 x i8]* @.d, i32 0, i32 0), i32* %b)
	call i32 (i8*, ...) @scanf(i8* getelementptr inbounds ([3 x i8], [3 x i8]* @.d, i32 0, i32 0), i32* %c)
	call i32 (i8*, ...) @scanf(i8* getelementptr inbounds ([3 x i8], [3 x i8]* @.d, i32 0, i32 0), i32* %d)
	call i32 (i8*, ...) @scanf(i8* getelementptr inbounds ([3 x i8], [3 x i8]* @.d, i32 0, i32 0), i32* %e)
	call void @tailrecursive(i32 %a)
	call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.nl, i32 0, i32 0), i32 %a)
	call void @domath(i32 %b)
	call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.nl, i32 0, i32 0), i32 %b)
	call void @objinstantiation(i32 %c)
	call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.nl, i32 0, i32 0), i32 %c)
	%r126 = call i32 @ackermann(i32 %d, i32 %e)
	call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.nl, i32 0, i32 0), i32 %r126)
	%r129 = add i32 0, 0
	store i32 %r129, i32* %return
	br label %END

END:
	%r130 = load i32, i32* %return
	ret i32 %r130
}

