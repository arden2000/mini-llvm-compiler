declare i8* @malloc(i32)
declare void @free(i8*)
declare i32 @printf(i8*, ...)
declare i32 @scanf(i8*, ...)

@.d = private unnamed_addr constant [3 x i8] c"%d\00", align 1
@.d.space = private unnamed_addr constant [4 x i8] c"%d \00", align 1
@.nl = private unnamed_addr constant [4 x i8] c"%d\0A\00", align 1

@.null = global i32* null
@.read = global i32 0



define i32 @sum(i32 %a, i32 %b) {
START:
	br label %L11

L11:
	%r1 = add i32 %a, %b
	br label %END

END:
	ret i32 %r1
}

define i32 @fact(i32 %n) {
START:
	br label %L19

L19:
	%r5 = icmp eq i32 %n, 1
	%r7 = icmp eq i32 %n, 0
	%r4 = or i1 %r5, %r7
	br i1 %r4, label %L20, label %L22

L20:
	br label %END

END:
	%r21 = phi i32 [ 1, %L20 ], [ %r12, %L24 ], [ %r16, %L26 ]
	ret i32 %r21

L22:
	%r10 = icmp sle i32 %n, 1
	br i1 %r10, label %L24, label %L26

L24:
	%r13 = mul i32 -1, %n
	%r12 = call i32 @fact(i32 %r13)
	br label %END

L26:
	%r18 = sub i32 %n, 1
	%r17 = call i32 @fact(i32 %r18)
	%r16 = mul i32 %n, %r17
	br label %END
}

define i32 @main() {
START:
	br label %L35

L35:
	br label %L37

L37:
	%r28 = phi i32 [ 0, %L35 ], [ %r38, %L39 ]
	%r39 = icmp ne i32 %r28, -1
	br i1 %r39, label %L39, label %END

L39:
	call i32 (i8*, ...) @scanf(i8* getelementptr inbounds ([3 x i8], [3 x i8]* @.d, i32 0, i32 0), i32* @.read)
	%r29 = load i32, i32* @.read
	call i32 (i8*, ...) @scanf(i8* getelementptr inbounds ([3 x i8], [3 x i8]* @.d, i32 0, i32 0), i32* @.read)
	%r30 = load i32, i32* @.read
	%r31 = call i32 @fact(i32 %r29)
	%r33 = call i32 @fact(i32 %r30)
	%r35 = call i32 @sum(i32 %r31, i32 %r33)
	call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.nl, i32 0, i32 0), i32 %r35)
	call i32 (i8*, ...) @scanf(i8* getelementptr inbounds ([3 x i8], [3 x i8]* @.d, i32 0, i32 0), i32* @.read)
	%r38 = load i32, i32* @.read
	br label %L37

END:
	ret i32 0
}

