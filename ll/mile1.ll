declare i8* @malloc(i32)
declare void @free(i8*)
declare i32 @printf(i8*, ...)
declare i32 @scanf(i8*, ...)

@.d = private unnamed_addr constant [3 x i8] c"%d\00", align 1
@.d.space = private unnamed_addr constant [4 x i8] c"%d \00", align 1
@.nl = private unnamed_addr constant [4 x i8] c"%d\0A\00", align 1

@.null = global i32* null
@.read = global i32 0

%struct.Power = type {i32, i32}


define i32 @calcPower(i32 %base, i32 %exp) {
START:
	br label %L8

L8:
	br label %L9

L9:
	%r5 = phi i32 [ 1, %L8 ], [ %r6, %L10 ]
	%r4 = phi i32 [ %exp, %L8 ], [ %r7, %L10 ]
	%r9 = icmp sgt i32 %r4, 0
	br i1 %r9, label %L10, label %END

L10:
	%r6 = mul i32 %r5, %base
	%r7 = sub i32 %r4, 1
	br label %L9

END:
	ret i32 %r5
}

define i32 @main() {
START:
	%r13 = bitcast i32** @.null to %struct.Power*
	br label %L23

L23:
	%r20 = call i8* @malloc(i32 8)
	%r19 = bitcast i8* %r20 to %struct.Power*
	call i32 (i8*, ...) @scanf(i8* getelementptr inbounds ([3 x i8], [3 x i8]* @.d, i32 0, i32 0), i32* @.read)
	%r21 = load i32, i32* @.read
	%r23 = getelementptr %struct.Power, %struct.Power* %r19, i32 0, i32 0
	store i32 %r21, i32* %r23
	call i32 (i8*, ...) @scanf(i8* getelementptr inbounds ([3 x i8], [3 x i8]* @.d, i32 0, i32 0), i32* @.read)
	%r26 = load i32, i32* @.read
	%r27 = icmp slt i32 %r26, 0
	br i1 %r27, label %L29, label %L30

L29:
	br label %END

END:
	%r54 = phi i32 [ -1, %L29 ], [ 0, %L39 ]
	ret i32 %r54

L30:
	%r32 = getelementptr %struct.Power, %struct.Power* %r19, i32 0, i32 1
	store i32 %r26, i32* %r32
	br label %L33

L33:
	%r40 = phi i32 [ 0, %L30 ], [ %r41, %L34 ]
	%r38 = phi i32 [ 0, %L30 ], [ %r43, %L34 ]
	%r36 = phi %struct.Power* [ %r19, %L30 ]
	%r50 = icmp slt i32 %r40, 1000000
	br i1 %r50, label %L34, label %L39

L34:
	%r41 = add i32 %r40, 1
	%r45 = getelementptr %struct.Power, %struct.Power* %r36, i32 0, i32 0
	%r44 = load i32, i32* %r45
	%r48 = getelementptr %struct.Power, %struct.Power* %r36, i32 0, i32 1
	%r47 = load i32, i32* %r48
	%r43 = call i32 @calcPower(i32 %r44, i32 %r47)
	br label %L33

L39:
	call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.nl, i32 0, i32 0), i32 %r38)
	br label %END
}

