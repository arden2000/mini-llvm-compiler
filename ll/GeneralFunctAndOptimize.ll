declare i8* @malloc(i32)
declare void @free(i8*)
declare i32 @printf(i8*, ...)
declare i32 @scanf(i8*, ...)

@.d = private unnamed_addr constant [3 x i8] c"%d\00", align 1
@.d.space = private unnamed_addr constant [4 x i8] c"%d \00", align 1
@.nl = private unnamed_addr constant [4 x i8] c"%d\0A\00", align 1

@.null = global i32* null
@.read = global i32 0

%struct.IntHolder = type {i32}

@interval = global i32 0
@end = global i32 0

define i32 @multBy4xTimes(%struct.IntHolder* %num, i32 %timesLeft) {
START:
	br label %L12

L12:
	%r1 = icmp sle i32 %timesLeft, 0
	br i1 %r1, label %L13, label %L17

L13:
	%r4 = getelementptr %struct.IntHolder, %struct.IntHolder* %num, i32 0, i32 0
	%r3 = load i32, i32* %r4
	br label %END

END:
	%r21 = phi i32 [ %r3, %L13 ], [ %r18, %L17 ]
	ret i32 %r21

L17:
	%r9 = getelementptr %struct.IntHolder, %struct.IntHolder* %num, i32 0, i32 0
	%r8 = load i32, i32* %r9
	%r6 = mul i32 4, %r8
	%r11 = getelementptr %struct.IntHolder, %struct.IntHolder* %num, i32 0, i32 0
	store i32 %r6, i32* %r11
	%r16 = sub i32 %timesLeft, 1
	%r14 = call i32 @multBy4xTimes(%struct.IntHolder* %num, i32 %r16)
	%r19 = getelementptr %struct.IntHolder, %struct.IntHolder* %num, i32 0, i32 0
	%r18 = load i32, i32* %r19
	br label %END
}

define void @divideBy8(%struct.IntHolder* %num) {
START:
	br label %L26

L26:
	%r24 = getelementptr %struct.IntHolder, %struct.IntHolder* %num, i32 0, i32 0
	%r23 = load i32, i32* %r24
	%r22 = sdiv i32 %r23, 2
	%r27 = getelementptr %struct.IntHolder, %struct.IntHolder* %num, i32 0, i32 0
	store i32 %r22, i32* %r27
	%r32 = getelementptr %struct.IntHolder, %struct.IntHolder* %num, i32 0, i32 0
	%r31 = load i32, i32* %r32
	%r30 = sdiv i32 %r31, 2
	%r35 = getelementptr %struct.IntHolder, %struct.IntHolder* %num, i32 0, i32 0
	store i32 %r30, i32* %r35
	%r40 = getelementptr %struct.IntHolder, %struct.IntHolder* %num, i32 0, i32 0
	%r39 = load i32, i32* %r40
	%r38 = sdiv i32 %r39, 2
	%r43 = getelementptr %struct.IntHolder, %struct.IntHolder* %num, i32 0, i32 0
	store i32 %r38, i32* %r43
	br label %END

END:
	ret void 
}

define i32 @main() {
START:
	%r52 = bitcast i32** @.null to %struct.IntHolder*
	br label %L41

L41:
	%r56 = call i8* @malloc(i32 4)
	%r55 = bitcast i8* %r56 to %struct.IntHolder*
	store i32 1000000, i32* @end
	call i32 (i8*, ...) @scanf(i8* getelementptr inbounds ([3 x i8], [3 x i8]* @.d, i32 0, i32 0), i32* @.read)
	%r58 = load i32, i32* @.read
	call i32 (i8*, ...) @scanf(i8* getelementptr inbounds ([3 x i8], [3 x i8]* @.d, i32 0, i32 0), i32* @interval)
	call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.nl, i32 0, i32 0), i32 %r58)
	%r61 = load i32, i32* @interval
	call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.nl, i32 0, i32 0), i32 %r61)
	br label %L58

L58:
	%r73 = phi i1 [ 0, %L41 ], [ %r83, %L83 ]
	%r72 = phi i1 [ 0, %L41 ], [ %r82, %L83 ]
	%r71 = phi %struct.IntHolder* [ %r55, %L41 ], [ %r81, %L83 ]
	%r70 = phi i32 [ 0, %L41 ], [ %r80, %L83 ]
	%r69 = phi i32 [ 0, %L41 ], [ %r79, %L83 ]
	%r68 = phi i32 [ 0, %L41 ], [ %r78, %L83 ]
	%r67 = phi i32 [ 0, %L41 ], [ %r77, %L83 ]
	%r66 = phi i32 [ 0, %L41 ], [ %r139, %L83 ]
	%r65 = phi i32 [ %r58, %L41 ], [ %r75, %L83 ]
	%r141 = icmp slt i32 %r66, 50
	br i1 %r141, label %L60, label %L86

L60:
	br label %L61

L61:
	%r83 = phi i1 [ %r73, %L60 ], [ %r127, %L80 ]
	%r82 = phi i1 [ %r72, %L60 ], [ %r122, %L80 ]
	%r81 = phi %struct.IntHolder* [ %r71, %L60 ], [ %r81, %L80 ]
	%r80 = phi i32 [ %r70, %L60 ], [ %r130, %L80 ]
	%r79 = phi i32 [ %r69, %L60 ], [ %r111, %L80 ]
	%r78 = phi i32 [ %r68, %L60 ], [ 39916800, %L80 ]
	%r77 = phi i32 [ 0, %L60 ], [ %r136, %L80 ]
	%r76 = phi i32 [ %r66, %L60 ], [ %r134, %L80 ]
	%r75 = phi i32 [ %r65, %L60 ], [ %r135, %L80 ]
	%r138 = load i32, i32* @end
	%r137 = icmp sle i32 %r77, %r138
	br i1 %r137, label %L63, label %L83

L63:
	%r105 = add i32 %r77, 1
	%r108 = getelementptr %struct.IntHolder, %struct.IntHolder* %r81, i32 0, i32 0
	store i32 %r105, i32* %r108
	%r112 = getelementptr %struct.IntHolder, %struct.IntHolder* %r81, i32 0, i32 0
	%r111 = load i32, i32* %r112
	%r114 = call i32 @multBy4xTimes(%struct.IntHolder* %r81, i32 2)
	call void @divideBy8(%struct.IntHolder* %r81)
	%r120 = load i32, i32* @interval
	%r119 = sub i32 %r120, 1
	%r122 = icmp sle i32 %r119, 0
	%r124 = icmp sle i32 %r119, 0
	br i1 %r124, label %L77, label %L80

L77:
	br label %L80

L80:
	%r127 = phi i1 [ %r83, %L77 ], [ %r83, %L63 ]
	%r130 = phi i32 [ 1, %L77 ], [ %r119, %L63 ]
	%r134 = phi i32 [ %r76, %L77 ], [ %r76, %L63 ]
	%r135 = phi i32 [ %r75, %L77 ], [ %r75, %L63 ]
	%r136 = add i32 %r105, %r130
	br label %L61

L83:
	%r139 = add i32 %r76, 1
	br label %L58

L86:
	call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.nl, i32 0, i32 0), i32 %r67)
	call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.nl, i32 0, i32 0), i32 %r68)
	br label %END

END:
	ret i32 0
}

