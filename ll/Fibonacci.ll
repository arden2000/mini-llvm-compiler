declare i8* @malloc(i32)
declare void @free(i8*)
declare i32 @printf(i8*, ...)
declare i32 @scanf(i8*, ...)

@.d = private unnamed_addr constant [3 x i8] c"%d\00", align 1
@.d.space = private unnamed_addr constant [4 x i8] c"%d \00", align 1
@.nl = private unnamed_addr constant [4 x i8] c"%d\0A\00", align 1

@.null = global i32* null
@.read = global i32 0



define i32 @computeFib(i32 %input) {
START:
	br label %L2

L2:
	%r1 = icmp eq i32 %input, 0
	br i1 %r1, label %L3, label %L6

L3:
	br label %END

END:
	%r14 = phi i32 [ 0, %L3 ], [ 1, %L7 ], [ %r7, %L10 ]
	ret i32 %r14

L6:
	%r4 = icmp sle i32 %input, 2
	br i1 %r4, label %L7, label %L10

L7:
	br label %END

L10:
	%r9 = sub i32 %input, 1
	%r8 = call i32 @computeFib(i32 %r9)
	%r12 = sub i32 %input, 2
	%r11 = call i32 @computeFib(i32 %r12)
	%r7 = add i32 %r8, %r11
	br label %END
}

define i32 @main() {
START:
	br label %L18

L18:
	call i32 (i8*, ...) @scanf(i8* getelementptr inbounds ([3 x i8], [3 x i8]* @.d, i32 0, i32 0), i32* @.read)
	%r16 = load i32, i32* @.read
	%r17 = call i32 @computeFib(i32 %r16)
	call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.nl, i32 0, i32 0), i32 %r17)
	br label %END

END:
	ret i32 0
}

