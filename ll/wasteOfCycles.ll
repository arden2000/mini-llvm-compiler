declare i8* @malloc(i32)
declare void @free(i8*)
declare i32 @printf(i8*, ...)
declare i32 @scanf(i8*, ...)

@.d = private unnamed_addr constant [3 x i8] c"%d\00", align 1
@.d.space = private unnamed_addr constant [4 x i8] c"%d \00", align 1
@.nl = private unnamed_addr constant [4 x i8] c"%d\0A\00", align 1

@.null = global i32* null
@.read = global i32 0



define i32 @function(i32 %n) {
START:
	br label %L4

L4:
	%r3 = icmp sle i32 %n, 0
	br i1 %r3, label %L6, label %L8

L6:
	br label %END

END:
	%r19 = phi i32 [ 0, %L6 ], [ %r16, %L15 ]
	ret i32 %r19

L8:
	br label %L9

L9:
	%r8 = phi i32 [ 0, %L8 ], [ %r12, %L11 ]
	%r15 = mul i32 %n, %n
	%r14 = icmp slt i32 %r8, %r15
	br i1 %r14, label %L11, label %L15

L11:
	%r10 = add i32 %r8, %n
	call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.d.space, i32 0, i32 0), i32 %r10)
	%r12 = add i32 %r8, 1
	br label %L9

L15:
	%r17 = sub i32 %n, 1
	%r16 = call i32 @function(i32 %r17)
	br label %END
}

define i32 @main() {
START:
	br label %L21

L21:
	call i32 (i8*, ...) @scanf(i8* getelementptr inbounds ([3 x i8], [3 x i8]* @.d, i32 0, i32 0), i32* @.read)
	%r21 = load i32, i32* @.read
	%r22 = call i32 @function(i32 %r21)
	call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.nl, i32 0, i32 0), i32 0)
	br label %END

END:
	ret i32 0
}

