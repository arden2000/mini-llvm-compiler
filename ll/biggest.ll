declare i8* @malloc(i32)
declare void @free(i8*)
declare i32 @printf(i8*, ...)
declare i32 @scanf(i8*, ...)

@.d = private unnamed_addr constant [3 x i8] c"%d\00", align 1
@.d.space = private unnamed_addr constant [4 x i8] c"%d \00", align 1
@.nl = private unnamed_addr constant [4 x i8] c"%d\0A\00", align 1

@.null = global i32* null
@.read = global i32 0

%struct.IntList = type {i32, %struct.IntList*}


define %struct.IntList* @getIntList() {
START:
	%r1 = bitcast i32** @.null to %struct.IntList*
	br label %L15

L15:
	%r4 = call i8* @malloc(i32 8)
	%r3 = bitcast i8* %r4 to %struct.IntList*
	call i32 (i8*, ...) @scanf(i8* getelementptr inbounds ([3 x i8], [3 x i8]* @.d, i32 0, i32 0), i32* @.read)
	%r5 = load i32, i32* @.read
	%r6 = icmp eq i32 %r5, -1
	br i1 %r6, label %L19, label %L25

L19:
	%r10 = getelementptr %struct.IntList, %struct.IntList* %r3, i32 0, i32 0
	store i32 %r5, i32* %r10
	%r14 = getelementptr %struct.IntList, %struct.IntList* %r3, i32 0, i32 1
	store %struct.IntList* null, %struct.IntList** %r14
	br label %END

END:
	ret %struct.IntList* %r3

L25:
	%r19 = getelementptr %struct.IntList, %struct.IntList* %r3, i32 0, i32 0
	store i32 %r5, i32* %r19
	%r22 = call %struct.IntList* @getIntList()
	%r23 = getelementptr %struct.IntList, %struct.IntList* %r3, i32 0, i32 1
	store %struct.IntList* %r22, %struct.IntList** %r23
	br label %END
}

define i32 @biggest(i32 %num1, i32 %num2) {
START:
	br label %L34

L34:
	%r28 = icmp sgt i32 %num1, %num2
	br i1 %r28, label %L36, label %L40

L36:
	br label %END

END:
	%r31 = phi i32 [ %num1, %L36 ], [ %num2, %L40 ]
	ret i32 %r31

L40:
	br label %END
}

define i32 @biggestInList(%struct.IntList* %list) {
START:
	br label %L47

L47:
	%r34 = getelementptr %struct.IntList, %struct.IntList* %list, i32 0, i32 0
	%r33 = load i32, i32* %r34
	br label %L48

L48:
	%r37 = phi i32 [ %r33, %L47 ], [ %r38, %L50 ]
	%r36 = phi %struct.IntList* [ %list, %L47 ], [ %r43, %L50 ]
	%r48 = getelementptr %struct.IntList, %struct.IntList* %r36, i32 0, i32 1
	%r47 = load %struct.IntList*, %struct.IntList** %r48
	%r50 = bitcast %struct.IntList* %r47 to i32*
	%r46 = icmp ne i32* %r50, null
	br i1 %r46, label %L50, label %END

L50:
	%r41 = getelementptr %struct.IntList, %struct.IntList* %r36, i32 0, i32 0
	%r40 = load i32, i32* %r41
	%r38 = call i32 @biggest(i32 %r37, i32 %r40)
	%r44 = getelementptr %struct.IntList, %struct.IntList* %r36, i32 0, i32 1
	%r43 = load %struct.IntList*, %struct.IntList** %r44
	br label %L48

END:
	ret i32 %r37
}

define i32 @main() {
START:
	%r53 = bitcast i32** @.null to %struct.IntList*
	br label %L60

L60:
	%r54 = call %struct.IntList* @getIntList()
	%r55 = call i32 @biggestInList(%struct.IntList* %r54)
	call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.nl, i32 0, i32 0), i32 %r55)
	br label %END

END:
	ret i32 0
}

