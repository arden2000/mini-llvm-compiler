declare i8* @malloc(i32)
declare void @free(i8*)
declare i32 @printf(i8*, ...)
declare i32 @scanf(i8*, ...)

@.d = private unnamed_addr constant [3 x i8] c"%d\00", align 1
@.d.space = private unnamed_addr constant [4 x i8] c"%d \00", align 1
@.nl = private unnamed_addr constant [4 x i8] c"%d\0A\00", align 1

@.null = global i32* null
@.read = global i32 0


@GLOBAL = global i32 0
@count = global i32 0

define i32 @fun2(i32 %x, i32 %y) {
START:
	br label %L7

L7:
	%r1 = icmp eq i32 %x, 0
	br i1 %r1, label %L8, label %L10

L8:
	br label %END

END:
	%r8 = phi i32 [ %y, %L8 ], [ %r4, %L10 ]
	ret i32 %r8

L10:
	%r5 = sub i32 %x, 1
	%r4 = call i32 @fun2(i32 %r5, i32 %y)
	br label %END
}

define i32 @fun1(i32 %x, i32 %y, i32 %z) {
START:
	br label %L16

L16:
	%r16 = mul i32 %x, 2
	%r12 = sub i32 11, %r16
	%r18 = sdiv i32 4, %y
	%r11 = add i32 %r12, %r18
	%r10 = add i32 %r11, %z
	%r20 = icmp sgt i32 %r10, %y
	br i1 %r20, label %L19, label %L21

L19:
	%r21 = call i32 @fun2(i32 %r10, i32 %x)
	br label %END

END:
	%r33 = phi i32 [ %r21, %L19 ], [ %r29, %L22 ], [ %r10, %L26 ]
	ret i32 %r33

L21:
	%r28 = icmp sle i32 %r10, %y
	%r24 = and i1 1, %r28
	br i1 %r24, label %L22, label %L26

L22:
	%r29 = call i32 @fun2(i32 %r10, i32 %y)
	br label %END

L26:
	br label %END
}

define i32 @main() {
START:
	br label %L32

L32:
	call i32 (i8*, ...) @scanf(i8* getelementptr inbounds ([3 x i8], [3 x i8]* @.d, i32 0, i32 0), i32* @.read)
	%r36 = load i32, i32* @.read
	br label %L35

L35:
	%r37 = phi i32 [ %r36, %L32 ], [ %r42, %L36 ]
	%r44 = icmp slt i32 %r37, 10000
	br i1 %r44, label %L36, label %END

L36:
	%r38 = call i32 @fun1(i32 3, i32 %r37, i32 5)
	call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.nl, i32 0, i32 0), i32 %r38)
	%r42 = add i32 %r37, 1
	br label %L35

END:
	ret i32 0
}

