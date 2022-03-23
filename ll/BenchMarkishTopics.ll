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

@intList = global i32 0

define i32 @length(%struct.intList* %list) {
START:
	br label %L9

L9:
	%r2 = bitcast %struct.intList* %list to i32*
	%r1 = icmp eq i32* %r2, null
	br i1 %r1, label %L10, label %L13

L10:
	br label %END

END:
	%r10 = phi i32 [ 0, %L10 ], [ %r4, %L13 ]
	ret i32 %r10

L13:
	%r8 = getelementptr %struct.intList, %struct.intList* %list, i32 0, i32 1
	%r7 = load %struct.intList*, %struct.intList** %r8
	%r6 = call i32 @length(%struct.intList* %r7)
	%r4 = add i32 1, %r6
	br label %END
}

define %struct.intList* @addToFront(%struct.intList* %list, i32 %element) {
START:
	%r11 = bitcast i32** @.null to %struct.intList*
	br label %L18

L18:
	%r13 = bitcast %struct.intList* %list to i32*
	%r12 = icmp eq i32* %r13, null
	br i1 %r12, label %L19, label %L25

L19:
	%r15 = call i8* @malloc(i32 8)
	%r14 = bitcast i8* %r15 to %struct.intList*
	%r17 = getelementptr %struct.intList, %struct.intList* %r14, i32 0, i32 0
	store i32 %element, i32* %r17
	%r21 = getelementptr %struct.intList, %struct.intList* %r14, i32 0, i32 1
	store %struct.intList* null, %struct.intList** %r21
	br label %END

END:
	%r36 = phi %struct.intList* [ %r14, %L19 ], [ %r25, %L25 ]
	ret %struct.intList* %r36

L25:
	%r26 = call i8* @malloc(i32 8)
	%r25 = bitcast i8* %r26 to %struct.intList*
	%r28 = getelementptr %struct.intList, %struct.intList* %r25, i32 0, i32 0
	store i32 %element, i32* %r28
	%r32 = getelementptr %struct.intList, %struct.intList* %r25, i32 0, i32 1
	store %struct.intList* %list, %struct.intList** %r32
	br label %END
}

define %struct.intList* @deleteFirst(%struct.intList* %list) {
START:
	%r37 = bitcast i32** @.null to %struct.intList*
	br label %L34

L34:
	%r39 = bitcast %struct.intList* %list to i32*
	%r38 = icmp eq i32* %r39, null
	br i1 %r38, label %L35, label %L38

L35:
	br label %END

END:
	%r48 = phi %struct.intList* [ null, %L35 ], [ %r42, %L38 ]
	ret %struct.intList* %r48

L38:
	%r43 = getelementptr %struct.intList, %struct.intList* %list, i32 0, i32 1
	%r42 = load %struct.intList*, %struct.intList** %r43
	%r46 = bitcast %struct.intList* %list to i8*
	call void @free(i8* %r46)
	br label %END
}

define i32 @main() {
START:
	%r49 = bitcast i32** @.null to %struct.intList*
	br label %L48

L48:
	call i32 (i8*, ...) @scanf(i8* getelementptr inbounds ([3 x i8], [3 x i8]* @.d, i32 0, i32 0), i32* @intList)
	br label %L52

L52:
	%r54 = phi %struct.intList* [ null, %L48 ], [ %r56, %L53 ]
	%r67 = load i32, i32* @intList
	%r66 = icmp sgt i32 %r67, 0
	br i1 %r66, label %L53, label %L58

L53:
	%r59 = load i32, i32* @intList
	%r56 = call %struct.intList* @addToFront(%struct.intList* %r54, i32 %r59)
	%r61 = getelementptr %struct.intList, %struct.intList* %r56, i32 0, i32 0
	%r60 = load i32, i32* %r61
	call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.d.space, i32 0, i32 0), i32 %r60)
	%r64 = load i32, i32* @intList
	%r63 = sub i32 %r64, 1
	store i32 %r63, i32* @intList
	br label %L52

L58:
	%r69 = call i32 @length(%struct.intList* %r54)
	call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.d.space, i32 0, i32 0), i32 %r69)
	br label %L60

L60:
	%r72 = phi i32 [ 0, %L58 ], [ %r73, %L61 ]
	%r71 = phi %struct.intList* [ %r54, %L58 ], [ %r79, %L61 ]
	%r82 = call i32 @length(%struct.intList* %r71)
	%r81 = icmp sgt i32 %r82, 0
	br i1 %r81, label %L61, label %L66

L61:
	%r75 = getelementptr %struct.intList, %struct.intList* %r71, i32 0, i32 0
	%r74 = load i32, i32* %r75
	%r73 = add i32 %r72, %r74
	%r77 = call i32 @length(%struct.intList* %r71)
	call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.d.space, i32 0, i32 0), i32 %r77)
	%r79 = call %struct.intList* @deleteFirst(%struct.intList* %r71)
	br label %L60

L66:
	call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.nl, i32 0, i32 0), i32 %r72)
	br label %END

END:
	ret i32 0
}

