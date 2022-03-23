declare i8* @malloc(i32)
declare void @free(i8*)
declare i32 @printf(i8*, ...)
declare i32 @scanf(i8*, ...)

@.d = private unnamed_addr constant [3 x i8] c"%d\00", align 1
@.d.space = private unnamed_addr constant [4 x i8] c"%d \00", align 1
@.nl = private unnamed_addr constant [4 x i8] c"%d\0A\00", align 1


%struct.gameBoard = type {i32, i32, i32, i32, i32, i32, i32, i32, i32}


define void @cleanBoard(%struct.gameBoard* %board1) {
	%board = alloca %struct.gameBoard*
	store %struct.gameBoard* %board1, %struct.gameBoard** %board
	br label %L14

L14:
	%r1 = add i32 0, 0
	%r4 = load %struct.gameBoard*, %struct.gameBoard** %board
	%r3 = getelementptr %struct.gameBoard, %struct.gameBoard* %r4, i32 0, i32 0
	%r2 = load i32, i32* %r3
	store i32 %r1, i32* %r2
	%r5 = add i32 0, 0
	%r8 = load %struct.gameBoard*, %struct.gameBoard** %board
	%r7 = getelementptr %struct.gameBoard, %struct.gameBoard* %r8, i32 0, i32 1
	%r6 = load i32, i32* %r7
	store i32 %r5, i32* %r6
	%r9 = add i32 0, 0
	%r12 = load %struct.gameBoard*, %struct.gameBoard** %board
	%r11 = getelementptr %struct.gameBoard, %struct.gameBoard* %r12, i32 0, i32 2
	%r10 = load i32, i32* %r11
	store i32 %r9, i32* %r10
	%r13 = add i32 0, 0
	%r16 = load %struct.gameBoard*, %struct.gameBoard** %board
	%r15 = getelementptr %struct.gameBoard, %struct.gameBoard* %r16, i32 0, i32 3
	%r14 = load i32, i32* %r15
	store i32 %r13, i32* %r14
	%r17 = add i32 0, 0
	%r20 = load %struct.gameBoard*, %struct.gameBoard** %board
	%r19 = getelementptr %struct.gameBoard, %struct.gameBoard* %r20, i32 0, i32 4
	%r18 = load i32, i32* %r19
	store i32 %r17, i32* %r18
	%r21 = add i32 0, 0
	%r24 = load %struct.gameBoard*, %struct.gameBoard** %board
	%r23 = getelementptr %struct.gameBoard, %struct.gameBoard* %r24, i32 0, i32 5
	%r22 = load i32, i32* %r23
	store i32 %r21, i32* %r22
	%r25 = add i32 0, 0
	%r28 = load %struct.gameBoard*, %struct.gameBoard** %board
	%r27 = getelementptr %struct.gameBoard, %struct.gameBoard* %r28, i32 0, i32 6
	%r26 = load i32, i32* %r27
	store i32 %r25, i32* %r26
	%r29 = add i32 0, 0
	%r32 = load %struct.gameBoard*, %struct.gameBoard** %board
	%r31 = getelementptr %struct.gameBoard, %struct.gameBoard* %r32, i32 0, i32 7
	%r30 = load i32, i32* %r31
	store i32 %r29, i32* %r30
	%r33 = add i32 0, 0
	%r36 = load %struct.gameBoard*, %struct.gameBoard** %board
	%r35 = getelementptr %struct.gameBoard, %struct.gameBoard* %r36, i32 0, i32 8
	%r34 = load i32, i32* %r35
	store i32 %r33, i32* %r34

END:
	ret void
}

define void @printBoard(%struct.gameBoard* %board1) {
	%board = alloca %struct.gameBoard*
	store %struct.gameBoard* %board1, %struct.gameBoard** %board
	br label %L26

L26:
	%r38 = load %struct.gameBoard*, %struct.gameBoard** %board
	%r37 = getelementptr %struct.gameBoard, %struct.gameBoard* %r38, i32 0, i32 0
	call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.d.space, i32 0, i32 0), i32 %r37)
	%r40 = load %struct.gameBoard*, %struct.gameBoard** %board
	%r39 = getelementptr %struct.gameBoard, %struct.gameBoard* %r40, i32 0, i32 1
	call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.d.space, i32 0, i32 0), i32 %r39)
	%r42 = load %struct.gameBoard*, %struct.gameBoard** %board
	%r41 = getelementptr %struct.gameBoard, %struct.gameBoard* %r42, i32 0, i32 2
	call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.nl, i32 0, i32 0), i32 %r41)
	%r44 = load %struct.gameBoard*, %struct.gameBoard** %board
	%r43 = getelementptr %struct.gameBoard, %struct.gameBoard* %r44, i32 0, i32 3
	call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.d.space, i32 0, i32 0), i32 %r43)
	%r46 = load %struct.gameBoard*, %struct.gameBoard** %board
	%r45 = getelementptr %struct.gameBoard, %struct.gameBoard* %r46, i32 0, i32 4
	call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.d.space, i32 0, i32 0), i32 %r45)
	%r48 = load %struct.gameBoard*, %struct.gameBoard** %board
	%r47 = getelementptr %struct.gameBoard, %struct.gameBoard* %r48, i32 0, i32 5
	call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.nl, i32 0, i32 0), i32 %r47)
	%r50 = load %struct.gameBoard*, %struct.gameBoard** %board
	%r49 = getelementptr %struct.gameBoard, %struct.gameBoard* %r50, i32 0, i32 6
	call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.d.space, i32 0, i32 0), i32 %r49)
	%r52 = load %struct.gameBoard*, %struct.gameBoard** %board
	%r51 = getelementptr %struct.gameBoard, %struct.gameBoard* %r52, i32 0, i32 7
	call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.d.space, i32 0, i32 0), i32 %r51)
	%r54 = load %struct.gameBoard*, %struct.gameBoard** %board
	%r53 = getelementptr %struct.gameBoard, %struct.gameBoard* %r54, i32 0, i32 8
	call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.nl, i32 0, i32 0), i32 %r53)

END:
	ret void
}

define void @printMoveBoard() {
	br label %L39

L39:
	%r55 = add i32 0, 123
	call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.nl, i32 0, i32 0), i32 %r55)
	%r56 = add i32 0, 456
	call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.nl, i32 0, i32 0), i32 %r56)
	%r57 = add i32 0, 789
	call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.nl, i32 0, i32 0), i32 %r57)

END:
	ret void
}

define void @placePiece(%struct.gameBoard* %board1, i32 %turn1, i32 %placement1) {
	%board = alloca %struct.gameBoard*
	%turn = alloca i32
	%placement = alloca i32
	store %struct.gameBoard* %board1, %struct.gameBoard** %board
	store i32 %turn1, i32* %turn
	store i32 %placement1, i32* %placement
	br label %L47

L47:
	%r59 = add i32 0, 1
	%r58 = icmp eq i32 %placement, %r59
	br i1 %r58, label %L48, label %L50

L48:
	%r60 = load i32, i32* %turn
	%r63 = load %struct.gameBoard*, %struct.gameBoard** %board
	%r62 = getelementptr %struct.gameBoard, %struct.gameBoard* %r63, i32 0, i32 0
	%r61 = load i32, i32* %r62
	store i32 %r60, i32* %r61
	br label %EmptyNode8

END:
	ret void

L50:
	%r65 = add i32 0, 2
	%r64 = icmp eq i32 %placement, %r65
	br i1 %r64, label %L51, label %L53

L51:
	%r66 = load i32, i32* %turn
	%r69 = load %struct.gameBoard*, %struct.gameBoard** %board
	%r68 = getelementptr %struct.gameBoard, %struct.gameBoard* %r69, i32 0, i32 1
	%r67 = load i32, i32* %r68
	store i32 %r66, i32* %r67
	br label %EmptyNode7

EmptyNode7:
	br label %EmptyNode8

L53:
	%r71 = add i32 0, 3
	%r70 = icmp eq i32 %placement, %r71
	br i1 %r70, label %L54, label %L56

L54:
	%r72 = load i32, i32* %turn
	%r75 = load %struct.gameBoard*, %struct.gameBoard** %board
	%r74 = getelementptr %struct.gameBoard, %struct.gameBoard* %r75, i32 0, i32 2
	%r73 = load i32, i32* %r74
	store i32 %r72, i32* %r73
	br label %EmptyNode6

EmptyNode6:
	br label %EmptyNode7

L56:
	%r77 = add i32 0, 4
	%r76 = icmp eq i32 %placement, %r77
	br i1 %r76, label %L57, label %L59

L57:
	%r78 = load i32, i32* %turn
	%r81 = load %struct.gameBoard*, %struct.gameBoard** %board
	%r80 = getelementptr %struct.gameBoard, %struct.gameBoard* %r81, i32 0, i32 3
	%r79 = load i32, i32* %r80
	store i32 %r78, i32* %r79
	br label %EmptyNode5

EmptyNode5:
	br label %EmptyNode6

L59:
	%r83 = add i32 0, 5
	%r82 = icmp eq i32 %placement, %r83
	br i1 %r82, label %L60, label %L62

L60:
	%r84 = load i32, i32* %turn
	%r87 = load %struct.gameBoard*, %struct.gameBoard** %board
	%r86 = getelementptr %struct.gameBoard, %struct.gameBoard* %r87, i32 0, i32 4
	%r85 = load i32, i32* %r86
	store i32 %r84, i32* %r85
	br label %EmptyNode4

EmptyNode4:
	br label %EmptyNode5

L62:
	%r89 = add i32 0, 6
	%r88 = icmp eq i32 %placement, %r89
	br i1 %r88, label %L63, label %L65

L63:
	%r90 = load i32, i32* %turn
	%r93 = load %struct.gameBoard*, %struct.gameBoard** %board
	%r92 = getelementptr %struct.gameBoard, %struct.gameBoard* %r93, i32 0, i32 5
	%r91 = load i32, i32* %r92
	store i32 %r90, i32* %r91
	br label %EmptyNode3

EmptyNode3:
	br label %EmptyNode4

L65:
	%r95 = add i32 0, 7
	%r94 = icmp eq i32 %placement, %r95
	br i1 %r94, label %L66, label %L68

L66:
	%r96 = load i32, i32* %turn
	%r99 = load %struct.gameBoard*, %struct.gameBoard** %board
	%r98 = getelementptr %struct.gameBoard, %struct.gameBoard* %r99, i32 0, i32 6
	%r97 = load i32, i32* %r98
	store i32 %r96, i32* %r97
	br label %EmptyNode2

EmptyNode2:
	br label %EmptyNode3

L68:
	%r101 = add i32 0, 8
	%r100 = icmp eq i32 %placement, %r101
	br i1 %r100, label %L69, label %L71

L69:
	%r102 = load i32, i32* %turn
	%r105 = load %struct.gameBoard*, %struct.gameBoard** %board
	%r104 = getelementptr %struct.gameBoard, %struct.gameBoard* %r105, i32 0, i32 7
	%r103 = load i32, i32* %r104
	store i32 %r102, i32* %r103
	br label %EmptyNode1

EmptyNode1:
	br label %EmptyNode2

L71:
	%r107 = add i32 0, 9
	%r106 = icmp eq i32 %placement, %r107
	br i1 %r106, label %L72, label %EmptyNode0

L72:
	%r108 = load i32, i32* %turn
	%r111 = load %struct.gameBoard*, %struct.gameBoard** %board
	%r110 = getelementptr %struct.gameBoard, %struct.gameBoard* %r111, i32 0, i32 8
	%r109 = load i32, i32* %r110
	store i32 %r108, i32* %r109
	br label %EmptyNode0

EmptyNode0:
	br label %EmptyNode1
}

define i32 @checkWinner(%struct.gameBoard* %board1) {
	%return = alloca i32
	%board = alloca %struct.gameBoard*
	store %struct.gameBoard* %board1, %struct.gameBoard** %board
	br label %L88

L88:
	%r114 = load %struct.gameBoard*, %struct.gameBoard** %board
	%r113 = getelementptr %struct.gameBoard, %struct.gameBoard* %r114, i32 0, i32 0
	%r115 = add i32 0, 1
	%r112 = icmp eq i32 %r113, %r115
	br i1 %r112, label %L89, label %L96

L89:
	%r118 = load %struct.gameBoard*, %struct.gameBoard** %board
	%r117 = getelementptr %struct.gameBoard, %struct.gameBoard* %r118, i32 0, i32 1
	%r119 = add i32 0, 1
	%r116 = icmp eq i32 %r117, %r119
	br i1 %r116, label %L90, label %EmptyNode10

L90:
	%r122 = load %struct.gameBoard*, %struct.gameBoard** %board
	%r121 = getelementptr %struct.gameBoard, %struct.gameBoard* %r122, i32 0, i32 2
	%r123 = add i32 0, 1
	%r120 = icmp eq i32 %r121, %r123
	br i1 %r120, label %L91, label %EmptyNode9

L91:
	%r124 = add i32 0, 0
	store i32 %r124, i32* %return
	br label %END

END:
	%r125 = load i32, i32* %return
	ret i32 %r125

EmptyNode9:
	br label %EmptyNode10

EmptyNode10:
	br label %L96

L96:
	%r128 = load %struct.gameBoard*, %struct.gameBoard** %board
	%r127 = getelementptr %struct.gameBoard, %struct.gameBoard* %r128, i32 0, i32 0
	%r129 = add i32 0, 2
	%r126 = icmp eq i32 %r127, %r129
	br i1 %r126, label %L97, label %L105

L97:
	%r132 = load %struct.gameBoard*, %struct.gameBoard** %board
	%r131 = getelementptr %struct.gameBoard, %struct.gameBoard* %r132, i32 0, i32 1
	%r133 = add i32 0, 2
	%r130 = icmp eq i32 %r131, %r133
	br i1 %r130, label %L98, label %EmptyNode12

L98:
	%r136 = load %struct.gameBoard*, %struct.gameBoard** %board
	%r135 = getelementptr %struct.gameBoard, %struct.gameBoard* %r136, i32 0, i32 2
	%r137 = add i32 0, 2
	%r134 = icmp eq i32 %r135, %r137
	br i1 %r134, label %L99, label %EmptyNode11

L99:
	%r138 = add i32 0, 1
	store i32 %r138, i32* %return
	br label %END

END:
	%r139 = load i32, i32* %return
	ret i32 %r139

EmptyNode11:
	br label %EmptyNode12

EmptyNode12:
	br label %L105

L105:
	%r142 = load %struct.gameBoard*, %struct.gameBoard** %board
	%r141 = getelementptr %struct.gameBoard, %struct.gameBoard* %r142, i32 0, i32 3
	%r143 = add i32 0, 1
	%r140 = icmp eq i32 %r141, %r143
	br i1 %r140, label %L106, label %L113

L106:
	%r146 = load %struct.gameBoard*, %struct.gameBoard** %board
	%r145 = getelementptr %struct.gameBoard, %struct.gameBoard* %r146, i32 0, i32 4
	%r147 = add i32 0, 1
	%r144 = icmp eq i32 %r145, %r147
	br i1 %r144, label %L107, label %EmptyNode14

L107:
	%r150 = load %struct.gameBoard*, %struct.gameBoard** %board
	%r149 = getelementptr %struct.gameBoard, %struct.gameBoard* %r150, i32 0, i32 5
	%r151 = add i32 0, 1
	%r148 = icmp eq i32 %r149, %r151
	br i1 %r148, label %L108, label %EmptyNode13

L108:
	%r152 = add i32 0, 0
	store i32 %r152, i32* %return
	br label %END

END:
	%r153 = load i32, i32* %return
	ret i32 %r153

EmptyNode13:
	br label %EmptyNode14

EmptyNode14:
	br label %L113

L113:
	%r156 = load %struct.gameBoard*, %struct.gameBoard** %board
	%r155 = getelementptr %struct.gameBoard, %struct.gameBoard* %r156, i32 0, i32 3
	%r157 = add i32 0, 2
	%r154 = icmp eq i32 %r155, %r157
	br i1 %r154, label %L114, label %L122

L114:
	%r160 = load %struct.gameBoard*, %struct.gameBoard** %board
	%r159 = getelementptr %struct.gameBoard, %struct.gameBoard* %r160, i32 0, i32 4
	%r161 = add i32 0, 2
	%r158 = icmp eq i32 %r159, %r161
	br i1 %r158, label %L115, label %EmptyNode16

L115:
	%r164 = load %struct.gameBoard*, %struct.gameBoard** %board
	%r163 = getelementptr %struct.gameBoard, %struct.gameBoard* %r164, i32 0, i32 5
	%r165 = add i32 0, 2
	%r162 = icmp eq i32 %r163, %r165
	br i1 %r162, label %L116, label %EmptyNode15

L116:
	%r166 = add i32 0, 1
	store i32 %r166, i32* %return
	br label %END

END:
	%r167 = load i32, i32* %return
	ret i32 %r167

EmptyNode15:
	br label %EmptyNode16

EmptyNode16:
	br label %L122

L122:
	%r170 = load %struct.gameBoard*, %struct.gameBoard** %board
	%r169 = getelementptr %struct.gameBoard, %struct.gameBoard* %r170, i32 0, i32 6
	%r171 = add i32 0, 1
	%r168 = icmp eq i32 %r169, %r171
	br i1 %r168, label %L123, label %L130

L123:
	%r174 = load %struct.gameBoard*, %struct.gameBoard** %board
	%r173 = getelementptr %struct.gameBoard, %struct.gameBoard* %r174, i32 0, i32 7
	%r175 = add i32 0, 1
	%r172 = icmp eq i32 %r173, %r175
	br i1 %r172, label %L124, label %EmptyNode18

L124:
	%r178 = load %struct.gameBoard*, %struct.gameBoard** %board
	%r177 = getelementptr %struct.gameBoard, %struct.gameBoard* %r178, i32 0, i32 8
	%r179 = add i32 0, 1
	%r176 = icmp eq i32 %r177, %r179
	br i1 %r176, label %L125, label %EmptyNode17

L125:
	%r180 = add i32 0, 0
	store i32 %r180, i32* %return
	br label %END

END:
	%r181 = load i32, i32* %return
	ret i32 %r181

EmptyNode17:
	br label %EmptyNode18

EmptyNode18:
	br label %L130

L130:
	%r184 = load %struct.gameBoard*, %struct.gameBoard** %board
	%r183 = getelementptr %struct.gameBoard, %struct.gameBoard* %r184, i32 0, i32 6
	%r185 = add i32 0, 2
	%r182 = icmp eq i32 %r183, %r185
	br i1 %r182, label %L131, label %L141

L131:
	%r188 = load %struct.gameBoard*, %struct.gameBoard** %board
	%r187 = getelementptr %struct.gameBoard, %struct.gameBoard* %r188, i32 0, i32 7
	%r189 = add i32 0, 2
	%r186 = icmp eq i32 %r187, %r189
	br i1 %r186, label %L132, label %EmptyNode20

L132:
	%r192 = load %struct.gameBoard*, %struct.gameBoard** %board
	%r191 = getelementptr %struct.gameBoard, %struct.gameBoard* %r192, i32 0, i32 8
	%r193 = add i32 0, 2
	%r190 = icmp eq i32 %r191, %r193
	br i1 %r190, label %L133, label %EmptyNode19

L133:
	%r194 = add i32 0, 1
	store i32 %r194, i32* %return
	br label %END

END:
	%r195 = load i32, i32* %return
	ret i32 %r195

EmptyNode19:
	br label %EmptyNode20

EmptyNode20:
	br label %L141

L141:
	%r198 = load %struct.gameBoard*, %struct.gameBoard** %board
	%r197 = getelementptr %struct.gameBoard, %struct.gameBoard* %r198, i32 0, i32 0
	%r199 = add i32 0, 1
	%r196 = icmp eq i32 %r197, %r199
	br i1 %r196, label %L142, label %L149

L142:
	%r202 = load %struct.gameBoard*, %struct.gameBoard** %board
	%r201 = getelementptr %struct.gameBoard, %struct.gameBoard* %r202, i32 0, i32 3
	%r203 = add i32 0, 1
	%r200 = icmp eq i32 %r201, %r203
	br i1 %r200, label %L143, label %EmptyNode22

L143:
	%r206 = load %struct.gameBoard*, %struct.gameBoard** %board
	%r205 = getelementptr %struct.gameBoard, %struct.gameBoard* %r206, i32 0, i32 6
	%r207 = add i32 0, 1
	%r204 = icmp eq i32 %r205, %r207
	br i1 %r204, label %L144, label %EmptyNode21

L144:
	%r208 = add i32 0, 0
	store i32 %r208, i32* %return
	br label %END

END:
	%r209 = load i32, i32* %return
	ret i32 %r209

EmptyNode21:
	br label %EmptyNode22

EmptyNode22:
	br label %L149

L149:
	%r212 = load %struct.gameBoard*, %struct.gameBoard** %board
	%r211 = getelementptr %struct.gameBoard, %struct.gameBoard* %r212, i32 0, i32 0
	%r213 = add i32 0, 2
	%r210 = icmp eq i32 %r211, %r213
	br i1 %r210, label %L150, label %L158

L150:
	%r216 = load %struct.gameBoard*, %struct.gameBoard** %board
	%r215 = getelementptr %struct.gameBoard, %struct.gameBoard* %r216, i32 0, i32 3
	%r217 = add i32 0, 2
	%r214 = icmp eq i32 %r215, %r217
	br i1 %r214, label %L151, label %EmptyNode24

L151:
	%r220 = load %struct.gameBoard*, %struct.gameBoard** %board
	%r219 = getelementptr %struct.gameBoard, %struct.gameBoard* %r220, i32 0, i32 6
	%r221 = add i32 0, 2
	%r218 = icmp eq i32 %r219, %r221
	br i1 %r218, label %L152, label %EmptyNode23

L152:
	%r222 = add i32 0, 1
	store i32 %r222, i32* %return
	br label %END

END:
	%r223 = load i32, i32* %return
	ret i32 %r223

EmptyNode23:
	br label %EmptyNode24

EmptyNode24:
	br label %L158

L158:
	%r226 = load %struct.gameBoard*, %struct.gameBoard** %board
	%r225 = getelementptr %struct.gameBoard, %struct.gameBoard* %r226, i32 0, i32 1
	%r227 = add i32 0, 1
	%r224 = icmp eq i32 %r225, %r227
	br i1 %r224, label %L159, label %L166

L159:
	%r230 = load %struct.gameBoard*, %struct.gameBoard** %board
	%r229 = getelementptr %struct.gameBoard, %struct.gameBoard* %r230, i32 0, i32 4
	%r231 = add i32 0, 1
	%r228 = icmp eq i32 %r229, %r231
	br i1 %r228, label %L160, label %EmptyNode26

L160:
	%r234 = load %struct.gameBoard*, %struct.gameBoard** %board
	%r233 = getelementptr %struct.gameBoard, %struct.gameBoard* %r234, i32 0, i32 7
	%r235 = add i32 0, 1
	%r232 = icmp eq i32 %r233, %r235
	br i1 %r232, label %L161, label %EmptyNode25

L161:
	%r236 = add i32 0, 0
	store i32 %r236, i32* %return
	br label %END

END:
	%r237 = load i32, i32* %return
	ret i32 %r237

EmptyNode25:
	br label %EmptyNode26

EmptyNode26:
	br label %L166

L166:
	%r240 = load %struct.gameBoard*, %struct.gameBoard** %board
	%r239 = getelementptr %struct.gameBoard, %struct.gameBoard* %r240, i32 0, i32 1
	%r241 = add i32 0, 2
	%r238 = icmp eq i32 %r239, %r241
	br i1 %r238, label %L167, label %L175

L167:
	%r244 = load %struct.gameBoard*, %struct.gameBoard** %board
	%r243 = getelementptr %struct.gameBoard, %struct.gameBoard* %r244, i32 0, i32 4
	%r245 = add i32 0, 2
	%r242 = icmp eq i32 %r243, %r245
	br i1 %r242, label %L168, label %EmptyNode28

L168:
	%r248 = load %struct.gameBoard*, %struct.gameBoard** %board
	%r247 = getelementptr %struct.gameBoard, %struct.gameBoard* %r248, i32 0, i32 7
	%r249 = add i32 0, 2
	%r246 = icmp eq i32 %r247, %r249
	br i1 %r246, label %L169, label %EmptyNode27

L169:
	%r250 = add i32 0, 1
	store i32 %r250, i32* %return
	br label %END

END:
	%r251 = load i32, i32* %return
	ret i32 %r251

EmptyNode27:
	br label %EmptyNode28

EmptyNode28:
	br label %L175

L175:
	%r254 = load %struct.gameBoard*, %struct.gameBoard** %board
	%r253 = getelementptr %struct.gameBoard, %struct.gameBoard* %r254, i32 0, i32 2
	%r255 = add i32 0, 1
	%r252 = icmp eq i32 %r253, %r255
	br i1 %r252, label %L176, label %L183

L176:
	%r258 = load %struct.gameBoard*, %struct.gameBoard** %board
	%r257 = getelementptr %struct.gameBoard, %struct.gameBoard* %r258, i32 0, i32 5
	%r259 = add i32 0, 1
	%r256 = icmp eq i32 %r257, %r259
	br i1 %r256, label %L177, label %EmptyNode30

L177:
	%r262 = load %struct.gameBoard*, %struct.gameBoard** %board
	%r261 = getelementptr %struct.gameBoard, %struct.gameBoard* %r262, i32 0, i32 8
	%r263 = add i32 0, 1
	%r260 = icmp eq i32 %r261, %r263
	br i1 %r260, label %L178, label %EmptyNode29

L178:
	%r264 = add i32 0, 0
	store i32 %r264, i32* %return
	br label %END

END:
	%r265 = load i32, i32* %return
	ret i32 %r265

EmptyNode29:
	br label %EmptyNode30

EmptyNode30:
	br label %L183

L183:
	%r268 = load %struct.gameBoard*, %struct.gameBoard** %board
	%r267 = getelementptr %struct.gameBoard, %struct.gameBoard* %r268, i32 0, i32 2
	%r269 = add i32 0, 2
	%r266 = icmp eq i32 %r267, %r269
	br i1 %r266, label %L184, label %L191

L184:
	%r272 = load %struct.gameBoard*, %struct.gameBoard** %board
	%r271 = getelementptr %struct.gameBoard, %struct.gameBoard* %r272, i32 0, i32 5
	%r273 = add i32 0, 2
	%r270 = icmp eq i32 %r271, %r273
	br i1 %r270, label %L185, label %EmptyNode32

L185:
	%r276 = load %struct.gameBoard*, %struct.gameBoard** %board
	%r275 = getelementptr %struct.gameBoard, %struct.gameBoard* %r276, i32 0, i32 8
	%r277 = add i32 0, 2
	%r274 = icmp eq i32 %r275, %r277
	br i1 %r274, label %L186, label %EmptyNode31

L186:
	%r278 = add i32 0, 1
	store i32 %r278, i32* %return
	br label %END

END:
	%r279 = load i32, i32* %return
	ret i32 %r279

EmptyNode31:
	br label %EmptyNode32

EmptyNode32:
	br label %L191

L191:
	%r281 = add i32 0, 1
	%r280 = mul i32 -1, %r281
	store i32 %r280, i32* %return
	br label %END

END:
	%r282 = load i32, i32* %return
	ret i32 %r282
}

define i32 @main() {
	%return = alloca i32
	%turn = alloca i32
	%space1 = alloca i32
	%space2 = alloca i32
	%winner = alloca i32
	%i = alloca i32
	%board = alloca %struct.gameBoard*
	br label %L199

L199:
	%r283 = add i32 0, 0
	store i32 %r283, i32* %i
	%r284 = add i32 0, 0
	store i32 %r284, i32* %turn
	%r285 = add i32 0, 0
	store i32 %r285, i32* %space1
	%r286 = add i32 0, 0
	store i32 %r286, i32* %space2
	%r288 = add i32 0, 1
	%r287 = mul i32 -1, %r288
	store i32 %r287, i32* %winner
	%r290 = call i8* @malloc(i32 36)
	%r289 = bitcast i8* %r290 to %struct.gameBoard*
	store %struct.gameBoard* %r289, %struct.gameBoard** %board
	call void @cleanBoard(%struct.gameBoard* %board)
	br label %L210

L210:
	%r295 = add i32 0, 0
	%r294 = icmp slt i32 %winner, %r295
	%r297 = add i32 0, 8
	%r296 = icmp ne i32 %i, %r297
	%r293 = and i1 %r294, %r296
	br i1 %r293, label %L211, label %L227

L211:
	call void @printBoard(%struct.gameBoard* %board)
	%r301 = add i32 0, 0
	%r300 = icmp eq i32 %turn, %r301
	br i1 %r300, label %L213, label %L218

L213:
	%r303 = add i32 0, 1
	%r302 = add i32 %turn, %r303
	store i32 %r302, i32* %turn
	call i32 (i8*, ...) @scanf(i8* getelementptr inbounds ([3 x i8], [3 x i8]* @.d, i32 0, i32 0), i32* %space1)
	call void @placePiece(%struct.gameBoard* %board, i32 1, i32 %space1)
	br label %L223

L223:
	%r309 = call i32 @checkWinner(%struct.gameBoard* %board)
	store i32 %r309, i32* %winner
	%r312 = add i32 0, 1
	%r311 = add i32 %i, %r312
	store i32 %r311, i32* %i
	br label %L210

L218:
	%r314 = add i32 0, 1
	%r313 = sub i32 %turn, %r314
	store i32 %r313, i32* %turn
	call i32 (i8*, ...) @scanf(i8* getelementptr inbounds ([3 x i8], [3 x i8]* @.d, i32 0, i32 0), i32* %space2)
	call void @placePiece(%struct.gameBoard* %board, i32 2, i32 %space2)
	br label %L223

L227:
	%r321 = add i32 0, 1
	%r320 = add i32 %winner, %r321
	call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.nl, i32 0, i32 0), i32 %r320)
	%r322 = add i32 0, 0
	store i32 %r322, i32* %return
	br label %END

END:
	%r323 = load i32, i32* %return
	ret i32 %r323
}

