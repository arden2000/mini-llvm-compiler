declare i8* @malloc(i32)
declare void @free(i8*)
declare i32 @printf(i8*, ...)
declare i32 @scanf(i8*, ...)

@.d = private unnamed_addr constant [3 x i8] c"%d\00", align 1
@.d.space = private unnamed_addr constant [4 x i8] c"%d \00", align 1
@.nl = private unnamed_addr constant [4 x i8] c"%d\0A\00", align 1




define i32 @mod(i32 %a1, i32 %b1) {
	%return = alloca i32
	%a = alloca i32
	%b = alloca i32
	store i32 %a1, i32* %a
	store i32 %b1, i32* %b
	br label %L4

L4:
	%r3 = sdiv i32 %a, %b
	%r2 = mul i32 %r3, %b
	%r1 = sub i32 %a, %r2
	store i32 %r1, i32* %return
	br label %END

END:
	%r4 = load i32, i32* %return
	ret i32 %r4
}

define void @hailstone(i32 %n1) {
	%n = alloca i32
	store i32 %n1, i32* %n
	br label %L10

L10:
	%r5 = add i1 1, 0
	br i1 %r5, label %L12, label %EmptyNode1

L12:
	call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.d.space, i32 0, i32 0), i32 %n)
	%r8 = call i32 @mod(i32 %n, i32 2)
	%r11 = add i32 0, 1
	%r7 = icmp eq i32 %r8, %r11
	br i1 %r7, label %L15, label %L19

L15:
	%r14 = add i32 0, 3
	%r13 = mul i32 %r14, %n
	%r15 = add i32 0, 1
	%r12 = add i32 %r13, %r15
	store i32 %r12, i32* %n
	br label %L21

L21:
	%r17 = add i32 0, 1
	%r16 = icmp sle i32 %n, %r17
	br i1 %r16, label %L23, label %EmptyNode0

L23:
	call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.nl, i32 0, i32 0), i32 %n)
	br label %END

END:
	ret void

EmptyNode0:
	br label %L10

L19:
	%r21 = add i32 0, 2
	%r20 = sdiv i32 %n, %r21
	store i32 %r20, i32* %n
	br label %L21

END:
	ret void
}

define i32 @main() {
	%return = alloca i32
	%num = alloca i32
	br label %L32

L32:
	call i32 (i8*, ...) @scanf(i8* getelementptr inbounds ([3 x i8], [3 x i8]* @.d, i32 0, i32 0), i32* %num)
	call void @hailstone(i32 %num)
	%r25 = add i32 0, 0
	store i32 %r25, i32* %return
	br label %END

END:
	%r26 = load i32, i32* %return
	ret i32 %r26
}

