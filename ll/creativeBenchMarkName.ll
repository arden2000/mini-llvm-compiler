declare i8* @malloc(i32)
declare void @free(i8*)
declare i32 @printf(i8*, ...)
declare i32 @scanf(i8*, ...)

@.d = private unnamed_addr constant [3 x i8] c"%d\00", align 1
@.d.space = private unnamed_addr constant [4 x i8] c"%d \00", align 1
@.nl = private unnamed_addr constant [4 x i8] c"%d\0A\00", align 1

@.null = global i32* null
@.read = global i32 0

%struct.node = type {i32, %struct.node*}


define %struct.node* @buildList() {
START:
	%r3 = bitcast i32** @.null to %struct.node*
	%r4 = bitcast i32** @.null to %struct.node*
	%r5 = bitcast i32** @.null to %struct.node*
	%r6 = bitcast i32** @.null to %struct.node*
	%r7 = bitcast i32** @.null to %struct.node*
	%r8 = bitcast i32** @.null to %struct.node*
	br label %L14

L14:
	%r10 = call i8* @malloc(i32 8)
	%r9 = bitcast i8* %r10 to %struct.node*
	%r12 = call i8* @malloc(i32 8)
	%r11 = bitcast i8* %r12 to %struct.node*
	%r14 = call i8* @malloc(i32 8)
	%r13 = bitcast i8* %r14 to %struct.node*
	%r16 = call i8* @malloc(i32 8)
	%r15 = bitcast i8* %r16 to %struct.node*
	%r18 = call i8* @malloc(i32 8)
	%r17 = bitcast i8* %r18 to %struct.node*
	%r20 = call i8* @malloc(i32 8)
	%r19 = bitcast i8* %r20 to %struct.node*
	%r22 = getelementptr %struct.node, %struct.node* %r9, i32 0, i32 0
	call i32 (i8*, ...) @scanf(i8* getelementptr inbounds ([3 x i8], [3 x i8]* @.d, i32 0, i32 0), i32* %r22)
	%r26 = getelementptr %struct.node, %struct.node* %r11, i32 0, i32 0
	call i32 (i8*, ...) @scanf(i8* getelementptr inbounds ([3 x i8], [3 x i8]* @.d, i32 0, i32 0), i32* %r26)
	%r30 = getelementptr %struct.node, %struct.node* %r13, i32 0, i32 0
	call i32 (i8*, ...) @scanf(i8* getelementptr inbounds ([3 x i8], [3 x i8]* @.d, i32 0, i32 0), i32* %r30)
	%r34 = getelementptr %struct.node, %struct.node* %r15, i32 0, i32 0
	call i32 (i8*, ...) @scanf(i8* getelementptr inbounds ([3 x i8], [3 x i8]* @.d, i32 0, i32 0), i32* %r34)
	%r38 = getelementptr %struct.node, %struct.node* %r17, i32 0, i32 0
	call i32 (i8*, ...) @scanf(i8* getelementptr inbounds ([3 x i8], [3 x i8]* @.d, i32 0, i32 0), i32* %r38)
	%r42 = getelementptr %struct.node, %struct.node* %r19, i32 0, i32 0
	call i32 (i8*, ...) @scanf(i8* getelementptr inbounds ([3 x i8], [3 x i8]* @.d, i32 0, i32 0), i32* %r42)
	%r46 = getelementptr %struct.node, %struct.node* %r9, i32 0, i32 1
	store %struct.node* %r11, %struct.node** %r46
	%r50 = getelementptr %struct.node, %struct.node* %r11, i32 0, i32 1
	store %struct.node* %r13, %struct.node** %r50
	%r54 = getelementptr %struct.node, %struct.node* %r13, i32 0, i32 1
	store %struct.node* %r15, %struct.node** %r54
	%r58 = getelementptr %struct.node, %struct.node* %r15, i32 0, i32 1
	store %struct.node* %r17, %struct.node** %r58
	%r62 = getelementptr %struct.node, %struct.node* %r17, i32 0, i32 1
	store %struct.node* %r19, %struct.node** %r62
	%r66 = getelementptr %struct.node, %struct.node* %r19, i32 0, i32 1
	store %struct.node* null, %struct.node** %r66
	br label %END

END:
	ret %struct.node* %r9
}

define i32 @multiple(%struct.node* %list) {
START:
	%r73 = bitcast i32** @.null to %struct.node*
	br label %L41

L41:
	%r77 = getelementptr %struct.node, %struct.node* %list, i32 0, i32 0
	%r76 = load i32, i32* %r77
	%r80 = getelementptr %struct.node, %struct.node* %list, i32 0, i32 1
	%r79 = load %struct.node*, %struct.node** %r80
	br label %L47

L47:
	%r85 = phi %struct.node* [ %r79, %L41 ], [ %r90, %L48 ]
	%r84 = phi i32 [ %r76, %L41 ], [ %r86, %L48 ]
	%r83 = phi i32 [ 0, %L41 ], [ %r94, %L48 ]
	%r96 = icmp slt i32 %r83, 5
	br i1 %r96, label %L48, label %END

L48:
	%r88 = getelementptr %struct.node, %struct.node* %r85, i32 0, i32 0
	%r87 = load i32, i32* %r88
	%r86 = mul i32 %r84, %r87
	%r91 = getelementptr %struct.node, %struct.node* %r85, i32 0, i32 1
	%r90 = load %struct.node*, %struct.node** %r91
	call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.nl, i32 0, i32 0), i32 %r86)
	%r94 = add i32 %r83, 1
	br label %L47

END:
	ret i32 %r84
}

define i32 @add(%struct.node* %list) {
START:
	%r102 = bitcast i32** @.null to %struct.node*
	br label %L60

L60:
	%r106 = getelementptr %struct.node, %struct.node* %list, i32 0, i32 0
	%r105 = load i32, i32* %r106
	%r109 = getelementptr %struct.node, %struct.node* %list, i32 0, i32 1
	%r108 = load %struct.node*, %struct.node** %r109
	br label %L66

L66:
	%r114 = phi %struct.node* [ %r108, %L60 ], [ %r119, %L67 ]
	%r113 = phi i32 [ %r105, %L60 ], [ %r115, %L67 ]
	%r112 = phi i32 [ 0, %L60 ], [ %r123, %L67 ]
	%r125 = icmp slt i32 %r112, 5
	br i1 %r125, label %L67, label %END

L67:
	%r117 = getelementptr %struct.node, %struct.node* %r114, i32 0, i32 0
	%r116 = load i32, i32* %r117
	%r115 = add i32 %r113, %r116
	%r120 = getelementptr %struct.node, %struct.node* %r114, i32 0, i32 1
	%r119 = load %struct.node*, %struct.node** %r120
	call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.nl, i32 0, i32 0), i32 %r115)
	%r123 = add i32 %r112, 1
	br label %L66

END:
	ret i32 %r113
}

define i32 @recurseList(%struct.node* %list) {
START:
	br label %L77

L77:
	%r131 = getelementptr %struct.node, %struct.node* %list, i32 0, i32 1
	%r130 = load %struct.node*, %struct.node** %r131
	%r133 = bitcast %struct.node* %r130 to i32*
	%r129 = icmp eq i32* %r133, null
	br i1 %r129, label %L78, label %L81

L78:
	%r135 = getelementptr %struct.node, %struct.node* %list, i32 0, i32 0
	%r134 = load i32, i32* %r135
	br label %END

END:
	%r145 = phi i32 [ %r134, %L78 ], [ %r137, %L81 ]
	ret i32 %r145

L81:
	%r139 = getelementptr %struct.node, %struct.node* %list, i32 0, i32 0
	%r138 = load i32, i32* %r139
	%r143 = getelementptr %struct.node, %struct.node* %list, i32 0, i32 1
	%r142 = load %struct.node*, %struct.node** %r143
	%r141 = call i32 @recurseList(%struct.node* %r142)
	%r137 = mul i32 %r138, %r141
	br label %END
}

define i32 @main() {
START:
	%r146 = bitcast i32** @.null to %struct.node*
	br label %L91

L91:
	%r154 = call %struct.node* @buildList()
	%r155 = call i32 @multiple(%struct.node* %r154)
	%r157 = call i32 @add(%struct.node* %r154)
	%r160 = sdiv i32 %r157, 2
	%r159 = sub i32 %r155, %r160
	br label %L99

L99:
	%r167 = phi i32 [ 0, %L91 ], [ %r171, %L100 ]
	%r166 = phi i32 [ 0, %L91 ], [ %r168, %L100 ]
	%r162 = phi %struct.node* [ %r154, %L91 ]
	%r173 = icmp slt i32 %r167, 2
	br i1 %r173, label %L100, label %L104

L100:
	%r169 = call i32 @recurseList(%struct.node* %r162)
	%r168 = add i32 %r166, %r169
	%r171 = add i32 %r167, 1
	br label %L99

L104:
	call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.nl, i32 0, i32 0), i32 %r166)
	br label %L106

L106:
	%r180 = phi i32 [ %r166, %L104 ], [ %r182, %L107 ]
	%r184 = icmp ne i32 %r180, 0
	br i1 %r184, label %L107, label %L110

L107:
	%r182 = sub i32 %r180, 1
	br label %L106

L110:
	call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.nl, i32 0, i32 0), i32 %r159)
	call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.nl, i32 0, i32 0), i32 %r180)
	br label %END

END:
	ret i32 0
}

