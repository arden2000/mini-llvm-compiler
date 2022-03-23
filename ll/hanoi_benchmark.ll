declare i8* @malloc(i32)
declare void @free(i8*)
declare i32 @printf(i8*, ...)
declare i32 @scanf(i8*, ...)

@.d = private unnamed_addr constant [3 x i8] c"%d\00", align 1
@.d.space = private unnamed_addr constant [4 x i8] c"%d \00", align 1
@.nl = private unnamed_addr constant [4 x i8] c"%d\0A\00", align 1

@.null = global i32* null
@.read = global i32 0

%struct.plate = type {i32, %struct.plate*}

@peg1 = global %struct.plate* null
@peg2 = global %struct.plate* null
@peg3 = global %struct.plate* null
@numMoves = global i32 0

define void @move(i32 %from, i32 %to) {
START:
	%r1 = bitcast i32** @.null to %struct.plate*
	br label %L18

L18:
	%r2 = icmp eq i32 %from, 1
	br i1 %r2, label %L19, label %L24

L19:
	%r4 = load %struct.plate*, %struct.plate** @peg1
	%r7 = load %struct.plate*, %struct.plate** @peg1
	%r6 = getelementptr %struct.plate, %struct.plate* %r7, i32 0, i32 1
	%r5 = load %struct.plate*, %struct.plate** %r6
	store %struct.plate* %r5, %struct.plate** @peg1
	br label %L34

L34:
	%r21 = phi %struct.plate* [ %r4, %L19 ], [ %r18, %EmptyNode0 ]
	%r24 = icmp eq i32 %to, 1
	br i1 %r24, label %L35, label %L40

L35:
	%r27 = getelementptr %struct.plate, %struct.plate* %r21, i32 0, i32 1
	%r26 = load %struct.plate*, %struct.plate** @peg1
	store %struct.plate* %r26, %struct.plate** %r27
	store %struct.plate* %r21, %struct.plate** @peg1
	br label %L51

L51:
	%r50 = load i32, i32* @numMoves
	%r49 = add i32 %r50, 1
	store i32 %r49, i32* @numMoves
	br label %END

END:
	ret void 

L40:
	%r31 = icmp eq i32 %to, 2
	br i1 %r31, label %L41, label %L46

L41:
	%r34 = getelementptr %struct.plate, %struct.plate* %r21, i32 0, i32 1
	%r33 = load %struct.plate*, %struct.plate** @peg2
	store %struct.plate* %r33, %struct.plate** %r34
	store %struct.plate* %r21, %struct.plate** @peg2
	br label %L51

L46:
	%r39 = getelementptr %struct.plate, %struct.plate* %r21, i32 0, i32 1
	%r38 = load %struct.plate*, %struct.plate** @peg3
	store %struct.plate* %r38, %struct.plate** %r39
	store %struct.plate* %r21, %struct.plate** @peg3
	br label %L51

L24:
	%r8 = icmp eq i32 %from, 2
	br i1 %r8, label %L25, label %L29

L25:
	%r10 = load %struct.plate*, %struct.plate** @peg2
	%r13 = load %struct.plate*, %struct.plate** @peg2
	%r12 = getelementptr %struct.plate, %struct.plate* %r13, i32 0, i32 1
	%r11 = load %struct.plate*, %struct.plate** %r12
	store %struct.plate* %r11, %struct.plate** @peg2
	br label %EmptyNode0

EmptyNode0:
	%r18 = phi %struct.plate* [ %r10, %L25 ], [ %r14, %L29 ]
	br label %L34

L29:
	%r14 = load %struct.plate*, %struct.plate** @peg3
	%r17 = load %struct.plate*, %struct.plate** @peg3
	%r16 = getelementptr %struct.plate, %struct.plate* %r17, i32 0, i32 1
	%r15 = load %struct.plate*, %struct.plate** %r16
	store %struct.plate* %r15, %struct.plate** @peg3
	br label %EmptyNode0
}

define void @hanoi(i32 %n, i32 %from, i32 %to, i32 %other) {
START:
	br label %L56

L56:
	%r52 = icmp eq i32 %n, 1
	br i1 %r52, label %L57, label %L61

L57:
	call void @move(i32 %from, i32 %to)
	br label %END

END:
	ret void 

L61:
	%r58 = sub i32 %n, 1
	call void @hanoi(i32 %r58, i32 %from, i32 %other, i32 %to)
	call void @move(i32 %from, i32 %to)
	%r67 = sub i32 %n, 1
	call void @hanoi(i32 %r67, i32 %other, i32 %to, i32 %from)
	br label %END
}

define void @printPeg(%struct.plate* %peg) {
START:
	%r76 = bitcast i32** @.null to %struct.plate*
	br label %L71

L71:
	br label %L73

L73:
	%r79 = phi %struct.plate* [ %peg, %L71 ], [ %r83, %L75 ]
	%r87 = bitcast %struct.plate* %r79 to i32*
	%r86 = icmp ne i32* %r87, null
	br i1 %r86, label %L75, label %END

L75:
	%r81 = getelementptr %struct.plate, %struct.plate* %r79, i32 0, i32 0
	%r80 = load i32, i32* %r81
	call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.nl, i32 0, i32 0), i32 %r80)
	%r84 = getelementptr %struct.plate, %struct.plate* %r79, i32 0, i32 1
	%r83 = load %struct.plate*, %struct.plate** %r84
	br label %L73

END:
	ret void 
}

define i32 @main() {
START:
	%r90 = bitcast i32** @.null to %struct.plate*
	br label %L85

L85:
	%r91 = bitcast i32** @.null to %struct.plate*
	store %struct.plate* %r91, %struct.plate** @peg1
	%r92 = bitcast i32** @.null to %struct.plate*
	store %struct.plate* %r92, %struct.plate** @peg2
	%r93 = bitcast i32** @.null to %struct.plate*
	store %struct.plate* %r93, %struct.plate** @peg3
	store i32 0, i32* @numMoves
	call i32 (i8*, ...) @scanf(i8* getelementptr inbounds ([3 x i8], [3 x i8]* @.d, i32 0, i32 0), i32* @.read)
	%r95 = load i32, i32* @.read
	%r96 = icmp sge i32 %r95, 1
	br i1 %r96, label %L94, label %END

L94:
	br label %L96

L96:
	%r99 = phi i32 [ %r95, %L94 ], [ %r113, %L98 ]
	%r115 = icmp ne i32 %r99, 0
	br i1 %r115, label %L98, label %L109

L98:
	%r103 = call i8* @malloc(i32 8)
	%r102 = bitcast i8* %r103 to %struct.plate*
	%r105 = getelementptr %struct.plate, %struct.plate* %r102, i32 0, i32 0
	store i32 %r99, i32* %r105
	%r109 = getelementptr %struct.plate, %struct.plate* %r102, i32 0, i32 1
	%r108 = load %struct.plate*, %struct.plate** @peg1
	store %struct.plate* %r108, %struct.plate** %r109
	store %struct.plate* %r102, %struct.plate** @peg1
	%r113 = sub i32 %r99, 1
	br label %L96

L109:
	call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.nl, i32 0, i32 0), i32 1)
	%r120 = load %struct.plate*, %struct.plate** @peg1
	call void @printPeg(%struct.plate* %r120)
	call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.nl, i32 0, i32 0), i32 2)
	%r124 = load %struct.plate*, %struct.plate** @peg2
	call void @printPeg(%struct.plate* %r124)
	call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.nl, i32 0, i32 0), i32 3)
	%r128 = load %struct.plate*, %struct.plate** @peg3
	call void @printPeg(%struct.plate* %r128)
	call void @hanoi(i32 %r95, i32 1, i32 3, i32 2)
	call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.nl, i32 0, i32 0), i32 1)
	%r137 = load %struct.plate*, %struct.plate** @peg1
	call void @printPeg(%struct.plate* %r137)
	call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.nl, i32 0, i32 0), i32 2)
	%r141 = load %struct.plate*, %struct.plate** @peg2
	call void @printPeg(%struct.plate* %r141)
	call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.nl, i32 0, i32 0), i32 3)
	%r145 = load %struct.plate*, %struct.plate** @peg3
	call void @printPeg(%struct.plate* %r145)
	%r146 = load i32, i32* @numMoves
	call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.nl, i32 0, i32 0), i32 %r146)
	br label %L130

L130:
	%r157 = load %struct.plate*, %struct.plate** @peg3
	%r158 = bitcast %struct.plate* %r157 to i32*
	%r156 = icmp ne i32* %r158, null
	br i1 %r156, label %L132, label %END

L132:
	%r150 = load %struct.plate*, %struct.plate** @peg3
	%r153 = load %struct.plate*, %struct.plate** @peg3
	%r152 = getelementptr %struct.plate, %struct.plate* %r153, i32 0, i32 1
	%r151 = load %struct.plate*, %struct.plate** %r152
	store %struct.plate* %r151, %struct.plate** @peg3
	%r155 = bitcast %struct.plate* %r150 to i8*
	call void @free(i8* %r155)
	br label %L130

END:
	ret i32 0
}

