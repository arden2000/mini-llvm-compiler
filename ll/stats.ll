declare i8* @malloc(i32)
declare void @free(i8*)
declare i32 @printf(i8*, ...)
declare i32 @scanf(i8*, ...)

@.d = private unnamed_addr constant [3 x i8] c"%d\00", align 1
@.d.space = private unnamed_addr constant [4 x i8] c"%d \00", align 1
@.nl = private unnamed_addr constant [4 x i8] c"%d\0A\00", align 1

@.null = global i32* null
@.read = global i32 0

%struct.linkedNums = type {i32, %struct.linkedNums*}


define %struct.linkedNums* @getRands(i32 %seed, i32 %num) {
START:
	%r3 = bitcast i32** @.null to %struct.linkedNums*
	%r4 = bitcast i32** @.null to %struct.linkedNums*
	br label %L10

L10:
	%r6 = mul i32 %seed, %seed
	%r8 = call i8* @malloc(i32 8)
	%r7 = bitcast i8* %r8 to %struct.linkedNums*
	%r10 = getelementptr %struct.linkedNums, %struct.linkedNums* %r7, i32 0, i32 0
	store i32 %r6, i32* %r10
	%r14 = getelementptr %struct.linkedNums, %struct.linkedNums* %r7, i32 0, i32 1
	store %struct.linkedNums* null, %struct.linkedNums** %r14
	%r17 = sub i32 %num, 1
	br label %L20

L20:
	%r25 = phi %struct.linkedNums* [ %r7, %L10 ], [ %r38, %L21 ]
	%r24 = phi %struct.linkedNums* [ null, %L10 ], [ %r38, %L21 ]
	%r23 = phi i32 [ %r6, %L10 ], [ %r33, %L21 ]
	%r21 = phi i32 [ %r17, %L10 ], [ %r49, %L21 ]
	%r52 = icmp sgt i32 %r21, 0
	br i1 %r52, label %L21, label %END

L21:
	%r29 = mul i32 %r23, %r23
	%r28 = sdiv i32 %r29, %seed
	%r30 = sdiv i32 %seed, 2
	%r27 = mul i32 %r28, %r30
	%r26 = add i32 %r27, 1
	%r35 = sdiv i32 %r26, 1000000000
	%r34 = mul i32 %r35, 1000000000
	%r33 = sub i32 %r26, %r34
	%r39 = call i8* @malloc(i32 8)
	%r38 = bitcast i8* %r39 to %struct.linkedNums*
	%r41 = getelementptr %struct.linkedNums, %struct.linkedNums* %r38, i32 0, i32 0
	store i32 %r33, i32* %r41
	%r45 = getelementptr %struct.linkedNums, %struct.linkedNums* %r38, i32 0, i32 1
	store %struct.linkedNums* %r25, %struct.linkedNums** %r45
	%r49 = sub i32 %r21, 1
	br label %L20

END:
	ret %struct.linkedNums* %r24
}

define i32 @calcMean(%struct.linkedNums* %nums) {
START:
	br label %L40

L40:
	br label %L44

L44:
	%r64 = phi i32 [ 0, %L40 ], [ %r66, %L45 ]
	%r63 = phi i32 [ 0, %L40 ], [ %r68, %L45 ]
	%r62 = phi %struct.linkedNums* [ %nums, %L40 ], [ %r72, %L45 ]
	%r76 = bitcast %struct.linkedNums* %r62 to i32*
	%r75 = icmp ne i32* %r76, null
	br i1 %r75, label %L45, label %L50

L45:
	%r66 = add i32 %r64, 1
	%r70 = getelementptr %struct.linkedNums, %struct.linkedNums* %r62, i32 0, i32 0
	%r69 = load i32, i32* %r70
	%r68 = add i32 %r63, %r69
	%r73 = getelementptr %struct.linkedNums, %struct.linkedNums* %r62, i32 0, i32 1
	%r72 = load %struct.linkedNums*, %struct.linkedNums** %r73
	br label %L44

L50:
	%r77 = icmp ne i32 %r64, 0
	br i1 %r77, label %L51, label %L54

L51:
	%r79 = sdiv i32 %r63, %r64
	br label %L54

L54:
	%r80 = phi i32 [ %r79, %L51 ], [ 0, %L50 ]
	br label %END

END:
	ret i32 %r80
}

define i32 @approxSqrt(i32 %num) {
START:
	br label %L59

L59:
	br label %L63

L63:
	%r95 = phi i32 [ 1, %L59 ], [ %r93, %L64 ]
	%r94 = phi i32 [ 0, %L59 ], [ %r96, %L64 ]
	%r93 = phi i32 [ 1, %L59 ], [ %r98, %L64 ]
	%r100 = icmp slt i32 %r94, %num
	br i1 %r100, label %L64, label %END

L64:
	%r96 = mul i32 %r93, %r93
	%r98 = add i32 %r93, 1
	br label %L63

END:
	ret i32 %r95
}

define void @approxSqrtAll(%struct.linkedNums* %nums) {
START:
	br label %L73

L73:
	%r103 = phi %struct.linkedNums* [ %r108, %L74 ], [ %nums, %START ]
	%r112 = bitcast %struct.linkedNums* %r103 to i32*
	%r111 = icmp ne i32* %r112, null
	br i1 %r111, label %L74, label %END

L74:
	%r106 = getelementptr %struct.linkedNums, %struct.linkedNums* %r103, i32 0, i32 0
	%r105 = load i32, i32* %r106
	%r104 = call i32 @approxSqrt(i32 %r105)
	call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.nl, i32 0, i32 0), i32 %r104)
	%r109 = getelementptr %struct.linkedNums, %struct.linkedNums* %r103, i32 0, i32 1
	%r108 = load %struct.linkedNums*, %struct.linkedNums** %r109
	br label %L73

END:
	ret void 
}

define void @range(%struct.linkedNums* %nums) {
START:
	br label %L84

L84:
	br label %L88

L88:
	%r122 = phi i1 [ 1, %L84 ], [ %r153, %L102 ]
	%r121 = phi i32 [ 0, %L84 ], [ %r154, %L102 ]
	%r120 = phi i32 [ 0, %L84 ], [ %r155, %L102 ]
	%r119 = phi %struct.linkedNums* [ %nums, %L84 ], [ %r157, %L102 ]
	%r161 = bitcast %struct.linkedNums* %r119 to i32*
	%r160 = icmp ne i32* %r161, null
	br i1 %r160, label %L89, label %L105

L89:
	br i1 %r122, label %L90, label %L94

L90:
	%r125 = getelementptr %struct.linkedNums, %struct.linkedNums* %r119, i32 0, i32 0
	%r124 = load i32, i32* %r125
	%r128 = getelementptr %struct.linkedNums, %struct.linkedNums* %r119, i32 0, i32 0
	%r127 = load i32, i32* %r128
	br label %L102

L102:
	%r153 = phi i1 [ 0, %L90 ], [ %r122, %EmptyNode2 ]
	%r154 = phi i32 [ %r127, %L90 ], [ %r150, %EmptyNode2 ]
	%r155 = phi i32 [ %r124, %L90 ], [ %r151, %EmptyNode2 ]
	%r158 = getelementptr %struct.linkedNums, %struct.linkedNums* %r119, i32 0, i32 1
	%r157 = load %struct.linkedNums*, %struct.linkedNums** %r158
	br label %L88

L94:
	%r133 = getelementptr %struct.linkedNums, %struct.linkedNums* %r119, i32 0, i32 0
	%r132 = load i32, i32* %r133
	%r131 = icmp slt i32 %r132, %r120
	br i1 %r131, label %L95, label %L97

L95:
	%r136 = getelementptr %struct.linkedNums, %struct.linkedNums* %r119, i32 0, i32 0
	%r135 = load i32, i32* %r136
	br label %EmptyNode2

EmptyNode2:
	%r150 = phi i32 [ %r121, %L95 ], [ %r146, %EmptyNode1 ]
	%r151 = phi i32 [ %r135, %L95 ], [ %r120, %EmptyNode1 ]
	br label %L102

L97:
	%r140 = getelementptr %struct.linkedNums, %struct.linkedNums* %r119, i32 0, i32 0
	%r139 = load i32, i32* %r140
	%r138 = icmp sgt i32 %r139, %r121
	br i1 %r138, label %L98, label %EmptyNode1

L98:
	%r143 = getelementptr %struct.linkedNums, %struct.linkedNums* %r119, i32 0, i32 0
	%r142 = load i32, i32* %r143
	br label %EmptyNode1

EmptyNode1:
	%r146 = phi i32 [ %r142, %L98 ], [ %r121, %L97 ]
	br label %EmptyNode2

L105:
	call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.nl, i32 0, i32 0), i32 %r120)
	call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.nl, i32 0, i32 0), i32 %r121)
	br label %END

END:
	ret void 
}

define i32 @main() {
START:
	%r167 = bitcast i32** @.null to %struct.linkedNums*
	br label %L113

L113:
	call i32 (i8*, ...) @scanf(i8* getelementptr inbounds ([3 x i8], [3 x i8]* @.d, i32 0, i32 0), i32* @.read)
	%r168 = load i32, i32* @.read
	call i32 (i8*, ...) @scanf(i8* getelementptr inbounds ([3 x i8], [3 x i8]* @.d, i32 0, i32 0), i32* @.read)
	%r169 = load i32, i32* @.read
	%r170 = call %struct.linkedNums* @getRands(i32 %r168, i32 %r169)
	%r173 = call i32 @calcMean(%struct.linkedNums* %r170)
	call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.nl, i32 0, i32 0), i32 %r173)
	call void @range(%struct.linkedNums* %r170)
	call void @approxSqrtAll(%struct.linkedNums* %r170)
	br label %END

END:
	ret i32 0
}

