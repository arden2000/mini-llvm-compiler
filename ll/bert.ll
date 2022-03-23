declare i8* @malloc(i32)
declare void @free(i8*)
declare i32 @printf(i8*, ...)
declare i32 @scanf(i8*, ...)

@.d = private unnamed_addr constant [3 x i8] c"%d\00", align 1
@.d.space = private unnamed_addr constant [4 x i8] c"%d \00", align 1
@.nl = private unnamed_addr constant [4 x i8] c"%d\0A\00", align 1


%struct.node = type {i32, %struct.node*}
%struct.tnode = type {i32, %struct.tnode*, %struct.tnode*}
%struct.i = type {i32}
%struct.myCopy = type {i1}

@a = global i32 0
@b = global i32 0
@i = global %struct.i* null

define %struct.node* @concatLists(%struct.node* %first1, %struct.node* %second1) {
	%return = alloca %struct.node*
	%temp = alloca %struct.node*
	%first = alloca %struct.node*
	%second = alloca %struct.node*
	store %struct.node* %first1, %struct.node** %first
	store %struct.node* %second1, %struct.node** %second
	br label %L31

L31:
	%r1 = load %struct.node*, %struct.node** %first
	store %struct.node* %r1, %struct.node** %temp
	%r3 = bitcast %struct.node* %first to i32*
	%r2 = icmp eq i32* %r3, null
	br i1 %r2, label %L35, label %L38

L35:
	%r4 = load %struct.node*, %struct.node** %second
	store %struct.node* %r4, %struct.node** %return
	br label %END

END:
	%r5 = load %struct.node*, %struct.node** %return
	ret %struct.node* %r5

L38:
	%r8 = load %struct.node*, %struct.node** %temp
	%r7 = getelementptr %struct.node, %struct.node* %r8, i32 0, i32 1
	%r9 = bitcast %struct.node* %r7 to i32*
	%r6 = icmp ne i32* %r9, null
	br i1 %r6, label %L40, label %L43

L40:
	%r11 = load %struct.node*, %struct.node** %temp
	%r10 = getelementptr %struct.node, %struct.node* %r11, i32 0, i32 1
	store %struct.node* %r10, %struct.node** %temp
	br label %L38

L43:
	%r12 = load %struct.node*, %struct.node** %second
	%r15 = load %struct.node*, %struct.node** %temp
	%r14 = getelementptr %struct.node, %struct.node* %r15, i32 0, i32 1
	%r13 = load %struct.node*, %struct.node** %r14
	store i32 %r12, i32* %r13
	%r16 = load %struct.node*, %struct.node** %first
	store %struct.node* %r16, %struct.node** %return
	br label %END

END:
	%r17 = load %struct.node*, %struct.node** %return
	ret %struct.node* %r17
}

define %struct.node* @add(%struct.node* %list1, i32 %toAdd1) {
	%return = alloca %struct.node*
	%newNode = alloca %struct.node*
	%list = alloca %struct.node*
	%toAdd = alloca i32
	store %struct.node* %list1, %struct.node** %list
	store i32 %toAdd1, i32* %toAdd
	br label %L52

L52:
	%r19 = call i8* @malloc(i32 8)
	%r18 = bitcast i8* %r19 to %struct.node*
	store %struct.node* %r18, %struct.node** %newNode
	%r20 = load i32, i32* %toAdd
	%r23 = load %struct.node*, %struct.node** %newNode
	%r22 = getelementptr %struct.node, %struct.node* %r23, i32 0, i32 0
	%r21 = load i32, i32* %r22
	store i32 %r20, i32* %r21
	%r24 = load %struct.node*, %struct.node** %list
	%r27 = load %struct.node*, %struct.node** %newNode
	%r26 = getelementptr %struct.node, %struct.node* %r27, i32 0, i32 1
	%r25 = load %struct.node*, %struct.node** %r26
	store i32 %r24, i32* %r25
	%r28 = load %struct.node*, %struct.node** %newNode
	store %struct.node* %r28, %struct.node** %return
	br label %END

END:
	%r29 = load %struct.node*, %struct.node** %return
	ret %struct.node* %r29
}

define i32 @size(%struct.node* %list1) {
	%return = alloca i32
	%list = alloca %struct.node*
	store %struct.node* %list1, %struct.node** %list
	br label %L61

L61:
	%r31 = bitcast %struct.node* %list to i32*
	%r30 = icmp eq i32* %r31, null
	br i1 %r30, label %L63, label %L66

L63:
	%r32 = add i32 0, 0
	store i32 %r32, i32* %return
	br label %END

END:
	%r33 = load i32, i32* %return
	ret i32 %r33

L66:
	%r35 = add i32 0, 1
	%r38 = load %struct.node*, %struct.node** %list
	%r37 = getelementptr %struct.node, %struct.node* %r38, i32 0, i32 1
	%r36 = call i32 @size(%struct.node* %r37)
	%r34 = add i32 %r35, %r36
	store i32 %r34, i32* %return
	br label %END

END:
	%r39 = load i32, i32* %return
	ret i32 %r39
}

define i32 @get(%struct.node* %list1, i32 %index1) {
	%return = alloca i32
	%list = alloca %struct.node*
	%index = alloca i32
	store %struct.node* %list1, %struct.node** %list
	store i32 %index1, i32* %index
	br label %L71

L71:
	%r41 = add i32 0, 0
	%r40 = icmp eq i32 %index, %r41
	br i1 %r40, label %L73, label %L76

L73:
	%r43 = load %struct.node*, %struct.node** %list
	%r42 = getelementptr %struct.node, %struct.node* %r43, i32 0, i32 0
	store i32 %r42, i32* %return
	br label %END

END:
	%r44 = load i32, i32* %return
	ret i32 %r44

L76:
	%r47 = load %struct.node*, %struct.node** %list
	%r46 = getelementptr %struct.node, %struct.node* %r47, i32 0, i32 1
	%r49 = add i32 0, 1
	%r48 = sub i32 %index, %r49
	%r45 = call i32 @get(%struct.node* %r46, i32 %r48)
	store i32 %r45, i32* %return
	br label %END

END:
	%r50 = load i32, i32* %return
	ret i32 %r50
}

define %struct.node* @pop(%struct.node* %list1) {
	%return = alloca %struct.node*
	%list = alloca %struct.node*
	store %struct.node* %list1, %struct.node** %list
	br label %L81

L81:
	%r52 = load %struct.node*, %struct.node** %list
	%r51 = getelementptr %struct.node, %struct.node* %r52, i32 0, i32 1
	store %struct.node* %r51, %struct.node** %list
	%r53 = load %struct.node*, %struct.node** %list
	store %struct.node* %r53, %struct.node** %return
	br label %END

END:
	%r54 = load %struct.node*, %struct.node** %return
	ret %struct.node* %r54
}

define void @printList(%struct.node* %list1) {
	%list = alloca %struct.node*
	store %struct.node* %list1, %struct.node** %list
	br label %L88

L88:
	%r56 = bitcast %struct.node* %list to i32*
	%r55 = icmp ne i32* %r56, null
	br i1 %r55, label %L90, label %EmptyNode0

L90:
	%r58 = load %struct.node*, %struct.node** %list
	%r57 = getelementptr %struct.node, %struct.node* %r58, i32 0, i32 0
	call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.nl, i32 0, i32 0), i32 %r57)
	%r61 = load %struct.node*, %struct.node** %list
	%r60 = getelementptr %struct.node, %struct.node* %r61, i32 0, i32 1
	call void @printList(%struct.node* %r60)
	br label %EmptyNode0

END:
	ret void
}

define void @treeprint(%struct.tnode* %root1) {
	%root = alloca %struct.tnode*
	store %struct.tnode* %root1, %struct.tnode** %root
	br label %L98

L98:
	%r63 = bitcast %struct.tnode* %root to i32*
	%r62 = icmp ne i32* %r63, null
	br i1 %r62, label %L100, label %EmptyNode1

L100:
	%r66 = load %struct.tnode*, %struct.tnode** %root
	%r65 = getelementptr %struct.tnode, %struct.tnode* %r66, i32 0, i32 1
	call void @treeprint(%struct.tnode* %r65)
	%r68 = load %struct.tnode*, %struct.tnode** %root
	%r67 = getelementptr %struct.tnode, %struct.tnode* %r68, i32 0, i32 0
	call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.nl, i32 0, i32 0), i32 %r67)
	%r71 = load %struct.tnode*, %struct.tnode** %root
	%r70 = getelementptr %struct.tnode, %struct.tnode* %r71, i32 0, i32 2
	call void @treeprint(%struct.tnode* %r70)
	br label %EmptyNode1

END:
	ret void
}

define void @freeList(%struct.node* %list1) {
	%list = alloca %struct.node*
	store %struct.node* %list1, %struct.node** %list
	br label %L108

L108:
	%r73 = bitcast %struct.node* %list to i32*
	%r72 = icmp ne i32* %r73, null
	br i1 %r72, label %L110, label %EmptyNode2

L110:
	%r76 = load %struct.node*, %struct.node** %list
	%r75 = getelementptr %struct.node, %struct.node* %r76, i32 0, i32 1
	call void @freeList(%struct.node* %r75)
	%r77 = load %struct.node*, %struct.node** %list
	%r78 = bitcast %struct.node* %r77 to i8*
	call void @free(i8* %r78)
	br label %EmptyNode2

END:
	ret void
}

define void @freeTree(%struct.tnode* %root1) {
	%root = alloca %struct.tnode*
	store %struct.tnode* %root1, %struct.tnode** %root
	br label %L117

L117:
	%r81 = bitcast %struct.tnode* %root to i32*
	%r80 = icmp eq i32* %r81, null
	%r79 = xor i32 1, %r80
	br i1 %r79, label %L119, label %EmptyNode3

L119:
	%r84 = load %struct.tnode*, %struct.tnode** %root
	%r83 = getelementptr %struct.tnode, %struct.tnode* %r84, i32 0, i32 1
	call void @freeTree(%struct.tnode* %r83)
	%r87 = load %struct.tnode*, %struct.tnode** %root
	%r86 = getelementptr %struct.tnode, %struct.tnode* %r87, i32 0, i32 2
	call void @freeTree(%struct.tnode* %r86)
	%r88 = load %struct.tnode*, %struct.tnode** %root
	%r89 = bitcast %struct.tnode* %r88 to i8*
	call void @free(i8* %r89)
	br label %EmptyNode3

END:
	ret void
}

define %struct.node* @postOrder(%struct.tnode* %root1) {
	%return = alloca %struct.node*
	%temp = alloca %struct.node*
	%root = alloca %struct.tnode*
	store %struct.tnode* %root1, %struct.tnode** %root
	br label %L129

L129:
	%r91 = bitcast %struct.tnode* %root to i32*
	%r90 = icmp ne i32* %r91, null
	br i1 %r90, label %L131, label %L137

L131:
	%r93 = call i8* @malloc(i32 8)
	%r92 = bitcast i8* %r93 to %struct.node*
	store %struct.node* %r92, %struct.node** %temp
	%r95 = load %struct.tnode*, %struct.tnode** %root
	%r94 = getelementptr %struct.tnode, %struct.tnode* %r95, i32 0, i32 0
	%r98 = load %struct.node*, %struct.node** %temp
	%r97 = getelementptr %struct.node, %struct.node* %r98, i32 0, i32 0
	%r96 = load i32, i32* %r97
	store i32 %r94, i32* %r96
	%r99 = bitcast i32** @.null to i
	%r102 = load %struct.node*, %struct.node** %temp
	%r101 = getelementptr %struct.node, %struct.node* %r102, i32 0, i32 1
	%r100 = load %struct.node*, %struct.node** %r101
	store i32 %r99, i32* %r100
	%r107 = load %struct.tnode*, %struct.tnode** %root
	%r106 = getelementptr %struct.tnode, %struct.tnode* %r107, i32 0, i32 1
	%r105 = call %struct.node* @postOrder(%struct.tnode* %r106)
	%r110 = load %struct.tnode*, %struct.tnode** %root
	%r109 = getelementptr %struct.tnode, %struct.tnode* %r110, i32 0, i32 2
	%r108 = call %struct.node* @postOrder(%struct.tnode* %r109)
	%r104 = call %struct.node* @concatLists(%struct.node* %r105, %struct.node* %r108)
	%r103 = call %struct.node* @concatLists(%struct.node* %r104, %struct.node* %temp)
	store %struct.node* %r103, %struct.node** %return
	br label %END

END:
	%r112 = load %struct.node*, %struct.node** %return
	ret %struct.node* %r112

L137:
	%r113 = bitcast i32** @.null to i
	store %struct.node* %r113, %struct.node** %return
	br label %END

END:
	%r114 = load %struct.node*, %struct.node** %return
	ret %struct.node* %r114
}

define %struct.tnode* @treeadd(%struct.tnode* %root1, i32 %toAdd1) {
	%return = alloca %struct.tnode*
	%temp = alloca %struct.tnode*
	%root = alloca %struct.tnode*
	%toAdd = alloca i32
	store %struct.tnode* %root1, %struct.tnode** %root
	store i32 %toAdd1, i32* %toAdd
	br label %L144

L144:
	%r116 = bitcast %struct.tnode* %root to i32*
	%r115 = icmp eq i32* %r116, null
	br i1 %r115, label %L146, label %L153

L146:
	%r118 = call i8* @malloc(i32 12)
	%r117 = bitcast i8* %r118 to %struct.tnode*
	store %struct.tnode* %r117, %struct.tnode** %temp
	%r119 = load i32, i32* %toAdd
	%r122 = load %struct.tnode*, %struct.tnode** %temp
	%r121 = getelementptr %struct.tnode, %struct.tnode* %r122, i32 0, i32 0
	%r120 = load i32, i32* %r121
	store i32 %r119, i32* %r120
	%r123 = bitcast i32** @.null to i
	%r126 = load %struct.tnode*, %struct.tnode** %temp
	%r125 = getelementptr %struct.tnode, %struct.tnode* %r126, i32 0, i32 1
	%r124 = load %struct.tnode*, %struct.tnode** %r125
	store i32 %r123, i32* %r124
	%r127 = bitcast i32** @.null to i
	%r130 = load %struct.tnode*, %struct.tnode** %temp
	%r129 = getelementptr %struct.tnode, %struct.tnode* %r130, i32 0, i32 2
	%r128 = load %struct.tnode*, %struct.tnode** %r129
	store i32 %r127, i32* %r128
	%r131 = load %struct.tnode*, %struct.tnode** %temp
	store %struct.tnode* %r131, %struct.tnode** %return
	br label %END

END:
	%r132 = load %struct.tnode*, %struct.tnode** %return
	ret %struct.tnode* %r132

L153:
	%r135 = load %struct.tnode*, %struct.tnode** %root
	%r134 = getelementptr %struct.tnode, %struct.tnode* %r135, i32 0, i32 0
	%r133 = icmp slt i32 %toAdd, %r134
	br i1 %r133, label %L155, label %L159

L155:
	%r138 = load %struct.tnode*, %struct.tnode** %root
	%r137 = getelementptr %struct.tnode, %struct.tnode* %r138, i32 0, i32 1
	%r136 = call %struct.tnode* @treeadd(%struct.tnode* %r137, i32 %toAdd)
	%r142 = load %struct.tnode*, %struct.tnode** %root
	%r141 = getelementptr %struct.tnode, %struct.tnode* %r142, i32 0, i32 1
	%r140 = load %struct.tnode*, %struct.tnode** %r141
	store i32 %r136, i32* %r140
	br label %L162

L162:
	%r143 = load %struct.tnode*, %struct.tnode** %root
	store %struct.tnode* %r143, %struct.tnode** %return
	br label %END

END:
	%r144 = load %struct.tnode*, %struct.tnode** %return
	ret %struct.tnode* %r144

L159:
	%r147 = load %struct.tnode*, %struct.tnode** %root
	%r146 = getelementptr %struct.tnode, %struct.tnode* %r147, i32 0, i32 2
	%r145 = call %struct.tnode* @treeadd(%struct.tnode* %r146, i32 %toAdd)
	%r151 = load %struct.tnode*, %struct.tnode** %root
	%r150 = getelementptr %struct.tnode, %struct.tnode* %r151, i32 0, i32 2
	%r149 = load %struct.tnode*, %struct.tnode** %r150
	store i32 %r145, i32* %r149
	br label %L162
}

define %struct.node* @quickSort(%struct.node* %list1) {
	%return = alloca %struct.node*
	%pivot = alloca i32
	%i = alloca i32
	%less = alloca %struct.node*
	%greater = alloca %struct.node*
	%temp = alloca %struct.node*
	%list = alloca %struct.node*
	store %struct.node* %list1, %struct.node** %list
	br label %L172

L172:
	%r152 = bitcast i32** @.null to i
	store %struct.node* %r152, %struct.node** %less
	%r153 = bitcast i32** @.null to i
	store %struct.node* %r153, %struct.node** %greater
	%r155 = call i32 @size(%struct.node* %list)
	%r157 = add i32 0, 1
	%r154 = icmp sle i32 %r155, %r157
	br i1 %r154, label %L177, label %L180

L177:
	%r158 = load %struct.node*, %struct.node** %list
	store %struct.node* %r158, %struct.node** %return
	br label %END

END:
	%r159 = load %struct.node*, %struct.node** %return
	ret %struct.node* %r159

L180:
	%r162 = call i32 @get(%struct.node* %list, i32 0)
	%r168 = call i32 @size(%struct.node* %list)
	%r170 = add i32 0, 1
	%r167 = sub i32 %r168, %r170
	%r165 = call i32 @get(%struct.node* %list, i32 %r167)
	%r161 = add i32 %r162, %r165
	%r171 = add i32 0, 2
	%r160 = sdiv i32 %r161, %r171
	store i32 %r160, i32* %pivot
	%r172 = load %struct.node*, %struct.node** %list
	store %struct.node* %r172, %struct.node** %temp
	%r173 = add i32 0, 0
	store i32 %r173, i32* %i
	br label %L185

L185:
	%r175 = bitcast %struct.node* %temp to i32*
	%r174 = icmp ne i32* %r175, null
	br i1 %r174, label %L187, label %L200

L187:
	%r177 = call i32 @get(%struct.node* %list, i32 %i)
	%r176 = icmp sgt i32 %r177, %pivot
	br i1 %r176, label %L189, label %L193

L189:
	%r182 = call i32 @get(%struct.node* %list, i32 %i)
	%r180 = call %struct.node* @add(%struct.node* %greater, i32 %r182)
	store %struct.node* %r180, %struct.node** %greater
	br label %L196

L196:
	%r186 = load %struct.node*, %struct.node** %temp
	%r185 = getelementptr %struct.node, %struct.node* %r186, i32 0, i32 1
	store %struct.node* %r185, %struct.node** %temp
	%r188 = add i32 0, 1
	%r187 = add i32 %i, %r188
	store i32 %r187, i32* %i
	br label %L185

L193:
	%r191 = call i32 @get(%struct.node* %list, i32 %i)
	%r189 = call %struct.node* @add(%struct.node* %less, i32 %r191)
	store %struct.node* %r189, %struct.node** %less
	br label %L196

L200:
	call void @freeList(%struct.node* %list)
	%r197 = call %struct.node* @quickSort(%struct.node* %less)
	%r199 = call %struct.node* @quickSort(%struct.node* %greater)
	%r196 = call %struct.node* @concatLists(%struct.node* %r197, %struct.node* %r199)
	store %struct.node* %r196, %struct.node** %return
	br label %END

END:
	%r201 = load %struct.node*, %struct.node** %return
	ret %struct.node* %r201
}

define %struct.node* @quickSortMain(%struct.node* %list1) {
	%return = alloca %struct.node*
	%list = alloca %struct.node*
	store %struct.node* %list1, %struct.node** %list
	br label %L207

L207:
	call void @printList(%struct.node* %list)
	%r205 = add i32 0, 999
	%r204 = mul i32 -1, %r205
	call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.nl, i32 0, i32 0), i32 %r204)
	call void @printList(%struct.node* %list)
	%r209 = add i32 0, 999
	%r208 = mul i32 -1, %r209
	call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.nl, i32 0, i32 0), i32 %r208)
	call void @printList(%struct.node* %list)
	%r213 = add i32 0, 999
	%r212 = mul i32 -1, %r213
	call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.nl, i32 0, i32 0), i32 %r212)
	%r214 = bitcast i32** @.null to i
	store %struct.node* %r214, %struct.node** %return
	br label %END

END:
	%r215 = load %struct.node*, %struct.node** %return
	ret %struct.node* %r215
}

define i32 @treesearch(%struct.tnode* %root1, i32 %target1) {
	%return = alloca i32
	%root = alloca %struct.tnode*
	%target = alloca i32
	store %struct.tnode* %root1, %struct.tnode** %root
	store i32 %target1, i32* %target
	br label %L229

L229:
	%r217 = add i32 0, 1
	%r216 = mul i32 -1, %r217
	call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.nl, i32 0, i32 0), i32 %r216)
	%r219 = bitcast %struct.tnode* %root to i32*
	%r218 = icmp ne i32* %r219, null
	br i1 %r218, label %L233, label %L252

L233:
	%r222 = load %struct.tnode*, %struct.tnode** %root
	%r221 = getelementptr %struct.tnode, %struct.tnode* %r222, i32 0, i32 0
	%r220 = icmp eq i32 %r221, %target
	br i1 %r220, label %L235, label %L238

L235:
	%r223 = add i32 0, 1
	store i32 %r223, i32* %return
	br label %END

END:
	%r224 = load i32, i32* %return
	ret i32 %r224

L238:
	%r228 = load %struct.tnode*, %struct.tnode** %root
	%r227 = getelementptr %struct.tnode, %struct.tnode* %r228, i32 0, i32 1
	%r226 = call i32 @treesearch(%struct.tnode* %r227, i32 %target)
	%r230 = add i32 0, 1
	%r225 = icmp eq i32 %r226, %r230
	br i1 %r225, label %L240, label %L242

L240:
	%r231 = add i32 0, 1
	store i32 %r231, i32* %return
	br label %END

END:
	%r232 = load i32, i32* %return
	ret i32 %r232

L242:
	%r236 = load %struct.tnode*, %struct.tnode** %root
	%r235 = getelementptr %struct.tnode, %struct.tnode* %r236, i32 0, i32 2
	%r234 = call i32 @treesearch(%struct.tnode* %r235, i32 %target)
	%r238 = add i32 0, 1
	%r233 = icmp eq i32 %r234, %r238
	br i1 %r233, label %L244, label %L248

L244:
	%r239 = add i32 0, 1
	store i32 %r239, i32* %return
	br label %END

END:
	%r240 = load i32, i32* %return
	ret i32 %r240

L248:
	%r241 = add i32 0, 0
	store i32 %r241, i32* %return
	br label %END

END:
	%r242 = load i32, i32* %return
	ret i32 %r242

L252:
	%r243 = add i32 0, 0
	store i32 %r243, i32* %return
	br label %END

END:
	%r244 = load i32, i32* %return
	ret i32 %r244
}

define %struct.node* @inOrder(%struct.tnode* %root1) {
	%return = alloca %struct.node*
	%temp = alloca %struct.node*
	%root = alloca %struct.tnode*
	store %struct.tnode* %root1, %struct.tnode** %root
	br label %L259

L259:
	%r246 = bitcast %struct.tnode* %root to i32*
	%r245 = icmp ne i32* %r246, null
	br i1 %r245, label %L261, label %L268

L261:
	%r248 = call i8* @malloc(i32 8)
	%r247 = bitcast i8* %r248 to %struct.node*
	store %struct.node* %r247, %struct.node** %temp
	%r250 = load %struct.tnode*, %struct.tnode** %root
	%r249 = getelementptr %struct.tnode, %struct.tnode* %r250, i32 0, i32 0
	%r253 = load %struct.node*, %struct.node** %temp
	%r252 = getelementptr %struct.node, %struct.node* %r253, i32 0, i32 0
	%r251 = load i32, i32* %r252
	store i32 %r249, i32* %r251
	%r254 = bitcast i32** @.null to i
	%r257 = load %struct.node*, %struct.node** %temp
	%r256 = getelementptr %struct.node, %struct.node* %r257, i32 0, i32 1
	%r255 = load %struct.node*, %struct.node** %r256
	store i32 %r254, i32* %r255
	%r261 = load %struct.tnode*, %struct.tnode** %root
	%r260 = getelementptr %struct.tnode, %struct.tnode* %r261, i32 0, i32 1
	%r259 = call %struct.node* @inOrder(%struct.tnode* %r260)
	%r266 = load %struct.tnode*, %struct.tnode** %root
	%r265 = getelementptr %struct.tnode, %struct.tnode* %r266, i32 0, i32 2
	%r264 = call %struct.node* @inOrder(%struct.tnode* %r265)
	%r262 = call %struct.node* @concatLists(%struct.node* %temp, %struct.node* %r264)
	%r258 = call %struct.node* @concatLists(%struct.node* %r259, %struct.node* %r262)
	store %struct.node* %r258, %struct.node** %return
	br label %END

END:
	%r267 = load %struct.node*, %struct.node** %return
	ret %struct.node* %r267

L268:
	%r268 = bitcast i32** @.null to i
	store %struct.node* %r268, %struct.node** %return
	br label %END

END:
	%r269 = load %struct.node*, %struct.node** %return
	ret %struct.node* %r269
}

define i32 @bintreesearch(%struct.tnode* %root1, i32 %target1) {
	%return = alloca i32
	%root = alloca %struct.tnode*
	%target = alloca i32
	store %struct.tnode* %root1, %struct.tnode** %root
	store i32 %target1, i32* %target
	br label %L274

L274:
	%r271 = add i32 0, 1
	%r270 = mul i32 -1, %r271
	call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.nl, i32 0, i32 0), i32 %r270)
	%r273 = bitcast %struct.tnode* %root to i32*
	%r272 = icmp ne i32* %r273, null
	br i1 %r272, label %L278, label %L293

L278:
	%r276 = load %struct.tnode*, %struct.tnode** %root
	%r275 = getelementptr %struct.tnode, %struct.tnode* %r276, i32 0, i32 0
	%r274 = icmp eq i32 %r275, %target
	br i1 %r274, label %L280, label %L283

L280:
	%r277 = add i32 0, 1
	store i32 %r277, i32* %return
	br label %END

END:
	%r278 = load i32, i32* %return
	ret i32 %r278

L283:
	%r281 = load %struct.tnode*, %struct.tnode** %root
	%r280 = getelementptr %struct.tnode, %struct.tnode* %r281, i32 0, i32 0
	%r279 = icmp slt i32 %target, %r280
	br i1 %r279, label %L285, label %L289

L285:
	%r284 = load %struct.tnode*, %struct.tnode** %root
	%r283 = getelementptr %struct.tnode, %struct.tnode* %r284, i32 0, i32 1
	%r282 = call i32 @bintreesearch(%struct.tnode* %r283, i32 %target)
	store i32 %r282, i32* %return
	br label %END

END:
	%r286 = load i32, i32* %return
	ret i32 %r286

L289:
	%r289 = load %struct.tnode*, %struct.tnode** %root
	%r288 = getelementptr %struct.tnode, %struct.tnode* %r289, i32 0, i32 2
	%r287 = call i32 @bintreesearch(%struct.tnode* %r288, i32 %target)
	store i32 %r287, i32* %return
	br label %END

END:
	%r291 = load i32, i32* %return
	ret i32 %r291

L293:
	%r292 = add i32 0, 0
	store i32 %r292, i32* %return
	br label %END

END:
	%r293 = load i32, i32* %return
	ret i32 %r293
}

define %struct.tnode* @buildTree(%struct.node* %list1) {
	%return = alloca %struct.tnode*
	%i = alloca i32
	%root = alloca %struct.tnode*
	%list = alloca %struct.node*
	store %struct.node* %list1, %struct.node** %list
	br label %L301

L301:
	%r294 = bitcast i32** @.null to i
	store %struct.tnode* %r294, %struct.tnode** %root
	%r295 = add i32 0, 0
	store i32 %r295, i32* %i
	br label %L304

L304:
	%r297 = call i32 @size(%struct.node* %list)
	%r296 = icmp slt i32 %i, %r297
	br i1 %r296, label %L306, label %L311

L306:
	%r301 = call i32 @get(%struct.node* %list, i32 %i)
	%r299 = call %struct.tnode* @treeadd(%struct.tnode* %root, i32 %r301)
	store %struct.tnode* %r299, %struct.tnode** %root
	%r305 = add i32 0, 1
	%r304 = add i32 %i, %r305
	store i32 %r304, i32* %i
	br label %L304

L311:
	%r306 = load %struct.tnode*, %struct.tnode** %root
	store %struct.tnode* %r306, %struct.tnode** %return
	br label %END

END:
	%r307 = load %struct.tnode*, %struct.tnode** %return
	ret %struct.tnode* %r307
}

define void @treeMain(%struct.node* %list1) {
	%root = alloca %struct.tnode*
	%inList = alloca %struct.node*
	%postList = alloca %struct.node*
	%list = alloca %struct.node*
	store %struct.node* %list1, %struct.node** %list
	br label %L320

L320:
	%r308 = call %struct.tnode* @buildTree(%struct.node* %list)
	store %struct.tnode* %r308, %struct.tnode** %root
	call void @treeprint(%struct.tnode* %root)
	%r313 = add i32 0, 999
	%r312 = mul i32 -1, %r313
	call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.nl, i32 0, i32 0), i32 %r312)
	%r314 = call %struct.node* @inOrder(%struct.tnode* %root)
	store %struct.node* %r314, %struct.node** %inList
	call void @printList(%struct.node* %inList)
	%r319 = add i32 0, 999
	%r318 = mul i32 -1, %r319
	call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.nl, i32 0, i32 0), i32 %r318)
	call void @freeList(%struct.node* %inList)
	%r322 = call %struct.node* @postOrder(%struct.tnode* %root)
	store %struct.node* %r322, %struct.node** %postList
	call void @printList(%struct.node* %postList)
	%r327 = add i32 0, 999
	%r326 = mul i32 -1, %r327
	call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.nl, i32 0, i32 0), i32 %r326)
	call void @freeList(%struct.node* %postList)
	%r330 = call i32 @treesearch(%struct.tnode* %root, i32 0)
	call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.nl, i32 0, i32 0), i32 %r330)
	%r334 = add i32 0, 999
	%r333 = mul i32 -1, %r334
	call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.nl, i32 0, i32 0), i32 %r333)
	%r335 = call i32 @treesearch(%struct.tnode* %root, i32 10)
	call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.nl, i32 0, i32 0), i32 %r335)
	%r339 = add i32 0, 999
	%r338 = mul i32 -1, %r339
	call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.nl, i32 0, i32 0), i32 %r338)
	%r343 = add i32 0, 2
	%r342 = mul i32 -1, %r343
	%r340 = call i32 @treesearch(%struct.tnode* %root, i32 %r342)
	call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.nl, i32 0, i32 0), i32 %r340)
	%r345 = add i32 0, 999
	%r344 = mul i32 -1, %r345
	call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.nl, i32 0, i32 0), i32 %r344)
	%r346 = call i32 @treesearch(%struct.tnode* %root, i32 2)
	call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.nl, i32 0, i32 0), i32 %r346)
	%r350 = add i32 0, 999
	%r349 = mul i32 -1, %r350
	call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.nl, i32 0, i32 0), i32 %r349)
	%r351 = call i32 @treesearch(%struct.tnode* %root, i32 3)
	call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.nl, i32 0, i32 0), i32 %r351)
	%r355 = add i32 0, 999
	%r354 = mul i32 -1, %r355
	call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.nl, i32 0, i32 0), i32 %r354)
	%r356 = call i32 @treesearch(%struct.tnode* %root, i32 9)
	call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.nl, i32 0, i32 0), i32 %r356)
	%r360 = add i32 0, 999
	%r359 = mul i32 -1, %r360
	call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.nl, i32 0, i32 0), i32 %r359)
	%r361 = call i32 @treesearch(%struct.tnode* %root, i32 1)
	call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.nl, i32 0, i32 0), i32 %r361)
	%r365 = add i32 0, 999
	%r364 = mul i32 -1, %r365
	call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.nl, i32 0, i32 0), i32 %r364)
	%r366 = call i32 @bintreesearch(%struct.tnode* %root, i32 0)
	call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.nl, i32 0, i32 0), i32 %r366)
	%r370 = add i32 0, 999
	%r369 = mul i32 -1, %r370
	call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.nl, i32 0, i32 0), i32 %r369)
	%r371 = call i32 @bintreesearch(%struct.tnode* %root, i32 10)
	call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.nl, i32 0, i32 0), i32 %r371)
	%r375 = add i32 0, 999
	%r374 = mul i32 -1, %r375
	call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.nl, i32 0, i32 0), i32 %r374)
	%r379 = add i32 0, 2
	%r378 = mul i32 -1, %r379
	%r376 = call i32 @bintreesearch(%struct.tnode* %root, i32 %r378)
	call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.nl, i32 0, i32 0), i32 %r376)
	%r381 = add i32 0, 999
	%r380 = mul i32 -1, %r381
	call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.nl, i32 0, i32 0), i32 %r380)
	%r382 = call i32 @bintreesearch(%struct.tnode* %root, i32 2)
	call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.nl, i32 0, i32 0), i32 %r382)
	%r386 = add i32 0, 999
	%r385 = mul i32 -1, %r386
	call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.nl, i32 0, i32 0), i32 %r385)
	%r387 = call i32 @bintreesearch(%struct.tnode* %root, i32 3)
	call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.nl, i32 0, i32 0), i32 %r387)
	%r391 = add i32 0, 999
	%r390 = mul i32 -1, %r391
	call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.nl, i32 0, i32 0), i32 %r390)
	%r392 = call i32 @bintreesearch(%struct.tnode* %root, i32 9)
	call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.nl, i32 0, i32 0), i32 %r392)
	%r396 = add i32 0, 999
	%r395 = mul i32 -1, %r396
	call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.nl, i32 0, i32 0), i32 %r395)
	%r397 = call i32 @bintreesearch(%struct.tnode* %root, i32 1)
	call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.nl, i32 0, i32 0), i32 %r397)
	%r401 = add i32 0, 999
	%r400 = mul i32 -1, %r401
	call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.nl, i32 0, i32 0), i32 %r400)
	call void @freeTree(%struct.tnode* %root)

END:
	ret void
}

define %struct.node* @myCopy(%struct.node* %src1) {
	%return = alloca %struct.node*
	%src = alloca %struct.node*
	store %struct.node* %src1, %struct.node** %src
	br label %L370

L370:
	%r405 = bitcast %struct.node* %src to i32*
	%r404 = icmp eq i32* %r405, null
	br i1 %r404, label %L372, label %L374

L372:
	%r406 = bitcast i32** @.null to i
	store %struct.node* %r406, %struct.node** %return
	br label %END

END:
	%r407 = load %struct.node*, %struct.node** %return
	ret %struct.node* %r407

L374:
	%r412 = load %struct.node*, %struct.node** %src
	%r411 = getelementptr %struct.node, %struct.node* %r412, i32 0, i32 0
	%r409 = call %struct.node* @add(%struct.node* null, i32 %r411)
	%r415 = load %struct.node*, %struct.node** %src
	%r414 = getelementptr %struct.node, %struct.node* %r415, i32 0, i32 1
	%r413 = call %struct.node* @myCopy(%struct.node* %r414)
	%r408 = call %struct.node* @concatLists(%struct.node* %r409, %struct.node* %r413)
	store %struct.node* %r408, %struct.node** %return
	br label %END

END:
	%r416 = load %struct.node*, %struct.node** %return
	ret %struct.node* %r416
}

define i32 @main() {
	%return = alloca i32
	%i = alloca i32
	%element = alloca i32
	%myList = alloca %struct.node*
	%copyList1 = alloca %struct.node*
	%copyList2 = alloca %struct.node*
	%sortedList = alloca %struct.node*
	br label %L381

L381:
	%r417 = bitcast i32** @.null to i
	store %struct.node* %r417, %struct.node** %myList
	%r418 = bitcast i32** @.null to i
	store %struct.node* %r418, %struct.node** %copyList1
	%r419 = bitcast i32** @.null to i
	store %struct.node* %r419, %struct.node** %copyList2
	%r420 = add i32 0, 0
	store i32 %r420, i32* %i
	br label %L386

L386:
	%r422 = add i32 0, 10
	%r421 = icmp slt i32 %i, %r422
	br i1 %r421, label %L388, label %L397

L388:
	call i32 (i8*, ...) @scanf(i8* getelementptr inbounds ([3 x i8], [3 x i8]* @.d, i32 0, i32 0), i32* %element)
	%r424 = call %struct.node* @add(%struct.node* %myList, i32 %element)
	store %struct.node* %r424, %struct.node** %myList
	%r427 = call %struct.node* @myCopy(%struct.node* %myList)
	store %struct.node* %r427, %struct.node** %copyList1
	%r429 = call %struct.node* @myCopy(%struct.node* %myList)
	store %struct.node* %r429, %struct.node** %copyList2
	%r431 = call %struct.node* @quickSortMain(%struct.node* %copyList1)
	store %struct.node* %r431, %struct.node** %sortedList
	call void @freeList(%struct.node* %sortedList)
	call void @treeMain(%struct.node* %copyList2)
	%r438 = add i32 0, 1
	%r437 = add i32 %i, %r438
	store i32 %r437, i32* %i
	br label %L386

L397:
	call void @freeList(%struct.node* %myList)
	call void @freeList(%struct.node* %copyList1)
	call void @freeList(%struct.node* %copyList2)
	%r445 = add i32 0, 0
	store i32 %r445, i32* %return
	br label %END

END:
	%r446 = load i32, i32* %return
	ret i32 %r446
}

