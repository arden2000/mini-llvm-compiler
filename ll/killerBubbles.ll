declare i8* @malloc(i32)
declare void @free(i8*)
declare i32 @printf(i8*, ...)
declare i32 @scanf(i8*, ...)

@.d = private unnamed_addr constant [3 x i8] c"%d\00", align 1
@.d.space = private unnamed_addr constant [4 x i8] c"%d \00", align 1
@.nl = private unnamed_addr constant [4 x i8] c"%d\0A\00", align 1

@.null = global i32* null
@.read = global i32 0

%struct.Node = type {i32, %struct.Node*, %struct.Node*}

@swapped = global i32 0

define i32 @compare(%struct.Node* %a, %struct.Node* %b) {
START:
	br label %L12

L12:
	%r3 = getelementptr %struct.Node, %struct.Node* %a, i32 0, i32 0
	%r2 = load i32, i32* %r3
	%r6 = getelementptr %struct.Node, %struct.Node* %b, i32 0, i32 0
	%r5 = load i32, i32* %r6
	%r1 = sub i32 %r2, %r5
	br label %END

END:
	ret i32 %r1
}

define void @deathSort(%struct.Node* %head) {
START:
	%r11 = bitcast i32** @.null to %struct.Node*
	br label %L20

L20:
	br label %L22

L22:
	%r15 = phi i32 [ 0, %L20 ], [ %r21, %EmptyNode0 ]
	%r14 = phi i32 [ 1, %L20 ], [ %r20, %EmptyNode0 ]
	%r13 = phi %struct.Node* [ %head, %L20 ], [ %r19, %EmptyNode0 ]
	%r63 = icmp eq i32 %r14, 1
	br i1 %r63, label %L25, label %END

L25:
	br label %L28

L28:
	%r22 = phi %struct.Node* [ %r13, %L25 ], [ %r54, %L38 ]
	%r21 = phi i32 [ %r15, %L25 ], [ %r51, %L38 ]
	%r20 = phi i32 [ 0, %L25 ], [ %r52, %L38 ]
	%r19 = phi %struct.Node* [ %r13, %L25 ], [ %r19, %L38 ]
	%r59 = getelementptr %struct.Node, %struct.Node* %r22, i32 0, i32 2
	%r58 = load %struct.Node*, %struct.Node** %r59
	%r61 = bitcast %struct.Node* %r58 to i32*
	%r62 = bitcast %struct.Node* %r19 to i32*
	%r57 = icmp ne i32* %r61, %r62
	br i1 %r57, label %L30, label %EmptyNode0

L30:
	%r27 = getelementptr %struct.Node, %struct.Node* %r22, i32 0, i32 2
	%r26 = load %struct.Node*, %struct.Node** %r27
	%r24 = call i32 @compare(%struct.Node* %r22, %struct.Node* %r26)
	%r23 = icmp sgt i32 %r24, 0
	br i1 %r23, label %L32, label %L38

L32:
	%r31 = getelementptr %struct.Node, %struct.Node* %r22, i32 0, i32 0
	%r30 = load i32, i32* %r31
	%r37 = getelementptr %struct.Node, %struct.Node* %r22, i32 0, i32 2
	%r36 = load %struct.Node*, %struct.Node** %r37
	%r34 = getelementptr %struct.Node, %struct.Node* %r36, i32 0, i32 0
	%r33 = load i32, i32* %r34
	%r39 = getelementptr %struct.Node, %struct.Node* %r22, i32 0, i32 0
	store i32 %r33, i32* %r39
	%r47 = getelementptr %struct.Node, %struct.Node* %r22, i32 0, i32 2
	%r46 = load %struct.Node*, %struct.Node** %r47
	%r43 = getelementptr %struct.Node, %struct.Node* %r46, i32 0, i32 0
	store i32 %r30, i32* %r43
	br label %L38

L38:
	%r51 = phi i32 [ %r30, %L32 ], [ %r21, %L30 ]
	%r52 = phi i32 [ 1, %L32 ], [ %r20, %L30 ]
	%r55 = getelementptr %struct.Node, %struct.Node* %r22, i32 0, i32 2
	%r54 = load %struct.Node*, %struct.Node** %r55
	br label %L28

EmptyNode0:
	br label %L22

END:
	ret void 
}

define void @printEVILList(%struct.Node* %head) {
START:
	%r65 = bitcast i32** @.null to %struct.Node*
	%r66 = bitcast i32** @.null to %struct.Node*
	br label %L48

L48:
	%r68 = getelementptr %struct.Node, %struct.Node* %head, i32 0, i32 2
	%r67 = load %struct.Node*, %struct.Node** %r68
	%r71 = getelementptr %struct.Node, %struct.Node* %head, i32 0, i32 0
	%r70 = load i32, i32* %r71
	call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.nl, i32 0, i32 0), i32 %r70)
	%r74 = bitcast %struct.Node* %head to i8*
	call void @free(i8* %r74)
	br label %L53

L53:
	%r76 = phi %struct.Node* [ %r67, %L48 ], [ %r82, %L55 ]
	%r88 = bitcast %struct.Node* %r76 to i32*
	%r89 = bitcast %struct.Node* %head to i32*
	%r87 = icmp ne i32* %r88, %r89
	br i1 %r87, label %L55, label %END

L55:
	%r80 = getelementptr %struct.Node, %struct.Node* %r76, i32 0, i32 0
	%r79 = load i32, i32* %r80
	call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.nl, i32 0, i32 0), i32 %r79)
	%r83 = getelementptr %struct.Node, %struct.Node* %r76, i32 0, i32 2
	%r82 = load %struct.Node*, %struct.Node** %r83
	%r86 = bitcast %struct.Node* %r76 to i8*
	call void @free(i8* %r86)
	br label %L53

END:
	ret void 
}

define i32 @main() {
START:
	%r92 = bitcast i32** @.null to %struct.Node*
	%r93 = bitcast i32** @.null to %struct.Node*
	%r94 = bitcast i32** @.null to %struct.Node*
	br label %L69

L69:
	store i32 666, i32* @swapped
	call i32 (i8*, ...) @scanf(i8* getelementptr inbounds ([3 x i8], [3 x i8]* @.d, i32 0, i32 0), i32* @.read)
	%r96 = load i32, i32* @.read
	%r97 = icmp sle i32 %r96, 0
	br i1 %r97, label %L76, label %L80

L76:
	call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.nl, i32 0, i32 0), i32 -1)
	br label %END

END:
	%r156 = phi i32 [ -1, %L76 ], [ 0, %L103 ]
	ret i32 %r156

L80:
	%r103 = mul i32 %r96, 1000
	%r107 = call i8* @malloc(i32 12)
	%r106 = bitcast i8* %r107 to %struct.Node*
	%r109 = getelementptr %struct.Node, %struct.Node* %r106, i32 0, i32 0
	store i32 %r103, i32* %r109
	%r113 = getelementptr %struct.Node, %struct.Node* %r106, i32 0, i32 1
	store %struct.Node* %r106, %struct.Node** %r113
	%r117 = getelementptr %struct.Node, %struct.Node* %r106, i32 0, i32 2
	store %struct.Node* %r106, %struct.Node** %r117
	%r120 = sub i32 %r103, 1
	br label %L90

L90:
	%r127 = phi %struct.Node* [ %r106, %L80 ], [ %r128, %L92 ]
	%r126 = phi %struct.Node* [ %r106, %L80 ]
	%r124 = phi i32 [ %r120, %L80 ], [ %r147, %L92 ]
	%r149 = icmp sgt i32 %r124, 0
	br i1 %r149, label %L92, label %L103

L92:
	%r129 = call i8* @malloc(i32 12)
	%r128 = bitcast i8* %r129 to %struct.Node*
	%r131 = getelementptr %struct.Node, %struct.Node* %r128, i32 0, i32 0
	store i32 %r124, i32* %r131
	%r135 = getelementptr %struct.Node, %struct.Node* %r128, i32 0, i32 1
	store %struct.Node* %r127, %struct.Node** %r135
	%r139 = getelementptr %struct.Node, %struct.Node* %r128, i32 0, i32 2
	store %struct.Node* %r126, %struct.Node** %r139
	%r143 = getelementptr %struct.Node, %struct.Node* %r127, i32 0, i32 2
	store %struct.Node* %r128, %struct.Node** %r143
	%r147 = sub i32 %r124, 1
	br label %L90

L103:
	call void @deathSort(%struct.Node* %r126)
	call void @printEVILList(%struct.Node* %r126)
	br label %END
}

