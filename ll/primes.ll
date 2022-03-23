declare i8* @malloc(i32)
declare void @free(i8*)
declare i32 @printf(i8*, ...)
declare i32 @scanf(i8*, ...)

@.d = private unnamed_addr constant [3 x i8] c"%d\00", align 1
@.d.space = private unnamed_addr constant [4 x i8] c"%d \00", align 1
@.nl = private unnamed_addr constant [4 x i8] c"%d\0A\00", align 1

@.null = global i32* null
@.read = global i32 0



define i32 @isqrt(i32 %a) {
START:
	br label %L4

L4:
	br label %L6

L6:
	%r7 = phi i32 [ 3, %L4 ], [ %r9, %L8 ]
	%r6 = phi i32 [ 1, %L4 ], [ %r8, %L8 ]
	%r11 = icmp sle i32 %r6, %a
	br i1 %r11, label %L8, label %L11

L8:
	%r8 = add i32 %r6, %r7
	%r9 = add i32 %r7, 2
	br label %L6

L11:
	%r13 = sdiv i32 %r7, 2
	%r12 = sub i32 %r13, 1
	br label %END

END:
	ret i32 %r12
}

define i1 @prime(i32 %a) {
START:
	br label %L17

L17:
	%r20 = icmp slt i32 %a, 2
	br i1 %r20, label %L19, label %L23

L19:
	br label %END

END:
	%r40 = phi i1 [ 0, %L19 ], [ 0, %L30 ], [ 1, %L34 ]
	ret i1 %r40

L23:
	%r23 = call i32 @isqrt(i32 %a)
	br label %L25

L25:
	%r28 = phi i32 [ 2, %L23 ], [ %r36, %L32 ]
	%r38 = icmp sle i32 %r28, %r23
	br i1 %r38, label %L27, label %L34

L27:
	%r32 = sdiv i32 %a, %r28
	%r31 = mul i32 %r32, %r28
	%r30 = sub i32 %a, %r31
	%r33 = icmp eq i32 %r30, 0
	br i1 %r33, label %L30, label %L32

L30:
	br label %END

L32:
	%r36 = add i32 %r28, 1
	br label %L25

L34:
	br label %END
}

define i32 @main() {
START:
	br label %L41

L41:
	call i32 (i8*, ...) @scanf(i8* getelementptr inbounds ([3 x i8], [3 x i8]* @.d, i32 0, i32 0), i32* @.read)
	%r43 = load i32, i32* @.read
	br label %L43

L43:
	%r46 = phi i32 [ 0, %L41 ], [ %r52, %L49 ]
	%r45 = phi i32 [ %r43, %L41 ], [ %r45, %L49 ]
	%r54 = icmp sle i32 %r46, %r45
	br i1 %r54, label %L45, label %END

L45:
	%r47 = call i1 @prime(i32 %r46)
	br i1 %r47, label %L47, label %L49

L47:
	call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.nl, i32 0, i32 0), i32 %r46)
	br label %L49

L49:
	%r52 = add i32 %r46, 1
	br label %L43

END:
	ret i32 0
}

