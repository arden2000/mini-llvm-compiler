declare i8* @malloc(i32)
declare void @free(i8*)
declare i32 @printf(i8*, ...)
declare i32 @scanf(i8*, ...)

@.d = private unnamed_addr constant [3 x i8] c"%d\00", align 1
@.d.space = private unnamed_addr constant [4 x i8] c"%d \00", align 1
@.nl = private unnamed_addr constant [4 x i8] c"%d\0A\00", align 1

@.null = global i32* null
@.read = global i32 0

%struct.intList = type {i32, %struct.intList*}


define i32 @main() {
START:
	%r1 = add i32 0, 0
	%r2 = add i32 0, 0
	%r3 = add i32 0, 0
	%r4 = bitcast i32** @.null to %struct.intList*
	br label %L11

L11:
	%r5 = add i32 0, 3
	call i32 (i8*, ...) @scanf(i8* getelementptr inbounds ([3 x i8], [3 x i8]* @.d, i32 0, i32 0), i32* @.read)
	%r6 = load i32, i32* @.read
	%r8 = bitcast %struct.intList* %r4 to i32*
	%r7 = icmp eq i32* %r8, null
	br i1 %r7, label %L16, label %L23

L16:
	%r10 = add i32 0, 3
	%r9 = add i32 %r6, %r10
	%r12 = add i32 0, 1
	%r11 = icmp slt i32 %r6, %r12
	br i1 %r11, label %L19, label %EmptyNode0

L19:
	call i32 (i8*, ...) @scanf(i8* getelementptr inbounds ([3 x i8], [3 x i8]* @.d, i32 0, i32 0), i32* @.read)
	%r13 = load i32, i32* @.read
	br label %EmptyNode0

EmptyNode0:
	%r14 = phi %struct.intList* [ %r4, %L19 ], [ %r4, %L16 ]
	%r15 = phi i32 [ %r3, %L19 ], [ %r3, %L16 ]
	%r16 = phi i32 [ %r9, %L19 ], [ %r9, %L16 ]
	%r17 = phi i32 [ %r13, %L19 ], [ %r6, %L16 ]
	br label %L23

L23:
	%r18 = phi %struct.intList* [ %r14, %EmptyNode0 ], [ %r4, %L11 ]
	%r19 = phi i32 [ %r15, %EmptyNode0 ], [ %r3, %L11 ]
	%r20 = phi i32 [ %r16, %EmptyNode0 ], [ %r2, %L11 ]
	%r21 = phi i32 [ %r17, %EmptyNode0 ], [ %r6, %L11 ]
	%r22 = add i32 %r19, %r19
	br label %END

END:
	%r24 = phi i32 [ %r22, %L23 ]
	ret i32 %r24
}

