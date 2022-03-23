declare i8* @malloc(i32)
declare void @free(i8*)
declare i32 @printf(i8*, ...)
declare i32 @scanf(i8*, ...)

@.d = private unnamed_addr constant [3 x i8] c"%d\00", align 1
@.d.space = private unnamed_addr constant [4 x i8] c"%d \00", align 1
@.nl = private unnamed_addr constant [4 x i8] c"%d\0A\00", align 1


%struct.thing = type {i32, i1, %struct.thing*}

@gi1 = global i32 0
@gb1 = global i1 0
@gs1 = global %struct.thing* null
@counter = global i32 0

define void @printgroup(i32 %groupnum1) {
	%groupnum = alloca i32
	store i32 %groupnum1, i32* %groupnum
	br label %L26

L26:
	%r1 = add i32 0, 1
	call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.d.space, i32 0, i32 0), i32 %r1)
	%r2 = add i32 0, 0
	call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.d.space, i32 0, i32 0), i32 %r2)
	%r3 = add i32 0, 1
	call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.d.space, i32 0, i32 0), i32 %r3)
	%r4 = add i32 0, 0
	call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.d.space, i32 0, i32 0), i32 %r4)
	%r5 = add i32 0, 1
	call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.d.space, i32 0, i32 0), i32 %r5)
	%r6 = add i32 0, 0
	call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.d.space, i32 0, i32 0), i32 %r6)
	call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.nl, i32 0, i32 0), i32 %groupnum)
	br label %END

END:
	ret void
}

define i1 @setcounter(i32 %val1) {
	%return = alloca i1
	%val = alloca i32
	store i32 %val1, i32* %val
	br label %L40

L40:
	%r9 = load i32, i32* %val
	store i32 %r9, i32* @counter
	%r10 = add i1 1, 0
	store i1 %r10, i1* %return
	br label %END

END:
	%r11 = load i1, i1* %return
	ret i1 %r11
}

define void @takealltypes(i32 %i1, i1 %b1, %struct.thing* %s1) {
	%i = alloca i32
	%b = alloca i1
	%s = alloca %struct.thing*
	store i32 %i1, i32* %i
	store i1 %b1, i1* %b
	store %struct.thing* %s1, %struct.thing** %s
	br label %L47

L47:
	%r13 = add i32 0, 3
	%r12 = icmp eq i32 %i, %r13
	br i1 %r12, label %L47, label %L47

L47:
	%r14 = add i32 0, 1
	call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.nl, i32 0, i32 0), i32 %r14)
	br label %L48

L48:
	br i1 %b, label %L48, label %L48

L48:
	%r16 = add i32 0, 1
	call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.nl, i32 0, i32 0), i32 %r16)
	br label %L49

L49:
	%r18 = load %struct.thing*, %struct.thing** %s
	%r17 = getelementptr %struct.thing, %struct.thing* %r18, i32 0, i32 1
	br i1 %r17, label %L49, label %L49

L49:
	%r19 = add i32 0, 1
	call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.nl, i32 0, i32 0), i32 %r19)
	br label %EmptyNode0

END:
	ret void

L49:
	%r20 = add i32 0, 0
	call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.nl, i32 0, i32 0), i32 %r20)
	br label %EmptyNode0

L48:
	%r21 = add i32 0, 0
	call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.nl, i32 0, i32 0), i32 %r21)
	br label %L49

L47:
	%r22 = add i32 0, 0
	call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.nl, i32 0, i32 0), i32 %r22)
	br label %L48
}

define void @tonofargs(i32 %a11, i32 %a21, i32 %a31, i32 %a41, i32 %a51, i32 %a61, i32 %a71, i32 %a81) {
	%a1 = alloca i32
	%a2 = alloca i32
	%a3 = alloca i32
	%a4 = alloca i32
	%a5 = alloca i32
	%a6 = alloca i32
	%a7 = alloca i32
	%a8 = alloca i32
	store i32 %a11, i32* %a1
	store i32 %a21, i32* %a2
	store i32 %a31, i32* %a3
	store i32 %a41, i32* %a4
	store i32 %a51, i32* %a5
	store i32 %a61, i32* %a6
	store i32 %a71, i32* %a7
	store i32 %a81, i32* %a8
	br label %L55

L55:
	%r24 = add i32 0, 5
	%r23 = icmp eq i32 %a5, %r24
	br i1 %r23, label %L55, label %L55

L55:
	%r25 = add i32 0, 1
	call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.nl, i32 0, i32 0), i32 %r25)
	br label %L56

L56:
	%r27 = add i32 0, 6
	%r26 = icmp eq i32 %a6, %r27
	br i1 %r26, label %L56, label %L56

L56:
	%r28 = add i32 0, 1
	call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.nl, i32 0, i32 0), i32 %r28)
	br label %L57

L57:
	%r30 = add i32 0, 7
	%r29 = icmp eq i32 %a7, %r30
	br i1 %r29, label %L57, label %L57

L57:
	%r31 = add i32 0, 1
	call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.nl, i32 0, i32 0), i32 %r31)
	br label %L58

L58:
	%r33 = add i32 0, 8
	%r32 = icmp eq i32 %a8, %r33
	br i1 %r32, label %L58, label %L58

L58:
	%r34 = add i32 0, 1
	call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.nl, i32 0, i32 0), i32 %r34)
	br label %EmptyNode1

END:
	ret void

L58:
	%r35 = add i32 0, 0
	call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.d.space, i32 0, i32 0), i32 %r35)
	call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.nl, i32 0, i32 0), i32 %a8)
	br label %EmptyNode1

L57:
	%r37 = add i32 0, 0
	call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.d.space, i32 0, i32 0), i32 %r37)
	call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.nl, i32 0, i32 0), i32 %a7)
	br label %L58

L56:
	%r39 = add i32 0, 0
	call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.d.space, i32 0, i32 0), i32 %r39)
	call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.nl, i32 0, i32 0), i32 %a6)
	br label %L57

L55:
	%r41 = add i32 0, 0
	call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.d.space, i32 0, i32 0), i32 %r41)
	call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.nl, i32 0, i32 0), i32 %a5)
	br label %L56
}

define i32 @returnint(i32 %ret1) {
	%return = alloca i32
	%ret = alloca i32
	store i32 %ret1, i32* %ret
	br label %L61

L61:
	%r43 = load i32, i32* %ret
	store i32 %r43, i32* %return
	br label %END

END:
	%r44 = load i32, i32* %return
	ret i32 %r44
}

define i1 @returnbool(i1 %ret1) {
	%return = alloca i1
	%ret = alloca i1
	store i1 %ret1, i1* %ret
	br label %L62

L62:
	%r45 = load i1, i1* %ret
	store i1 %r45, i1* %return
	br label %END

END:
	%r46 = load i1, i1* %return
	ret i1 %r46
}

define %struct.thing* @returnstruct(%struct.thing* %ret1) {
	%return = alloca %struct.thing*
	%ret = alloca %struct.thing*
	store %struct.thing* %ret1, %struct.thing** %ret
	br label %L63

L63:
	%r47 = load %struct.thing*, %struct.thing** %ret
	store %struct.thing* %r47, %struct.thing** %return
	br label %END

END:
	%r48 = load %struct.thing*, %struct.thing** %return
	ret %struct.thing* %r48
}

define i32 @main() {
	%return = alloca i32
	%b1 = alloca i1
	%b2 = alloca i1
	%i1 = alloca i32
	%i2 = alloca i32
	%i3 = alloca i32
	%s1 = alloca %struct.thing*
	%s2 = alloca %struct.thing*
	br label %L73

L73:
	%r49 = add i32 0, 0
	store i32 %r49, i32* @counter
	call void @printgroup(i32 1)
	%r52 = add i1 0, 0
	store i1 %r52, i1* %b1
	%r53 = add i1 0, 0
	store i1 %r53, i1* %b2
	%r54 = and i1 %b1, %b2
	br i1 %r54, label %L82, label %L82

L82:
	%r55 = add i32 0, 0
	call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.nl, i32 0, i32 0), i32 %r55)
	br label %L84

L84:
	%r56 = add i1 1, 0
	store i1 %r56, i1* %b1
	%r57 = add i1 0, 0
	store i1 %r57, i1* %b2
	%r58 = and i1 %b1, %b2
	br i1 %r58, label %L86, label %L86

L86:
	%r59 = add i32 0, 0
	call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.nl, i32 0, i32 0), i32 %r59)
	br label %L88

L88:
	%r60 = add i1 0, 0
	store i1 %r60, i1* %b1
	%r61 = add i1 1, 0
	store i1 %r61, i1* %b2
	%r62 = and i1 %b1, %b2
	br i1 %r62, label %L90, label %L90

L90:
	%r63 = add i32 0, 0
	call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.nl, i32 0, i32 0), i32 %r63)
	br label %L92

L92:
	%r64 = add i1 1, 0
	store i1 %r64, i1* %b1
	%r65 = add i1 1, 0
	store i1 %r65, i1* %b2
	%r66 = and i1 %b1, %b2
	br i1 %r66, label %L94, label %L94

L94:
	%r67 = add i32 0, 1
	call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.nl, i32 0, i32 0), i32 %r67)
	br label %L96

L96:
	%r68 = add i32 0, 0
	store i32 %r68, i32* @counter
	call void @printgroup(i32 2)
	%r71 = add i1 1, 0
	store i1 %r71, i1* %b1
	%r72 = add i1 1, 0
	store i1 %r72, i1* %b2
	%r73 = or i1 %b1, %b2
	br i1 %r73, label %L103, label %L103

L103:
	%r74 = add i32 0, 1
	call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.nl, i32 0, i32 0), i32 %r74)
	br label %L105

L105:
	%r75 = add i1 1, 0
	store i1 %r75, i1* %b1
	%r76 = add i1 0, 0
	store i1 %r76, i1* %b2
	%r77 = or i1 %b1, %b2
	br i1 %r77, label %L107, label %L107

L107:
	%r78 = add i32 0, 1
	call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.nl, i32 0, i32 0), i32 %r78)
	br label %L109

L109:
	%r79 = add i1 0, 0
	store i1 %r79, i1* %b1
	%r80 = add i1 1, 0
	store i1 %r80, i1* %b2
	%r81 = or i1 %b1, %b2
	br i1 %r81, label %L111, label %L111

L111:
	%r82 = add i32 0, 1
	call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.nl, i32 0, i32 0), i32 %r82)
	br label %L113

L113:
	%r83 = add i1 0, 0
	store i1 %r83, i1* %b1
	%r84 = add i1 0, 0
	store i1 %r84, i1* %b2
	%r85 = or i1 %b1, %b2
	br i1 %r85, label %L115, label %L115

L115:
	%r86 = add i32 0, 0
	call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.nl, i32 0, i32 0), i32 %r86)
	br label %L119

L119:
	call void @printgroup(i32 3)
	%r90 = add i32 0, 42
	%r91 = add i32 0, 1
	%r89 = icmp sgt i32 %r90, %r91
	br i1 %r89, label %L121, label %L121

L121:
	%r92 = add i32 0, 1
	call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.nl, i32 0, i32 0), i32 %r92)
	br label %L122

L122:
	%r94 = add i32 0, 42
	%r95 = add i32 0, 1
	%r93 = icmp sge i32 %r94, %r95
	br i1 %r93, label %L122, label %L122

L122:
	%r96 = add i32 0, 1
	call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.nl, i32 0, i32 0), i32 %r96)
	br label %L123

L123:
	%r98 = add i32 0, 42
	%r99 = add i32 0, 1
	%r97 = icmp slt i32 %r98, %r99
	br i1 %r97, label %L123, label %L123

L123:
	%r100 = add i32 0, 0
	call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.nl, i32 0, i32 0), i32 %r100)
	br label %L124

L124:
	%r102 = add i32 0, 42
	%r103 = add i32 0, 1
	%r101 = icmp sle i32 %r102, %r103
	br i1 %r101, label %L124, label %L124

L124:
	%r104 = add i32 0, 0
	call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.nl, i32 0, i32 0), i32 %r104)
	br label %L125

L125:
	%r106 = add i32 0, 42
	%r107 = add i32 0, 1
	%r105 = icmp eq i32 %r106, %r107
	br i1 %r105, label %L125, label %L125

L125:
	%r108 = add i32 0, 0
	call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.nl, i32 0, i32 0), i32 %r108)
	br label %L126

L126:
	%r110 = add i32 0, 42
	%r111 = add i32 0, 1
	%r109 = icmp ne i32 %r110, %r111
	br i1 %r109, label %L126, label %L126

L126:
	%r112 = add i32 0, 1
	call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.nl, i32 0, i32 0), i32 %r112)
	br label %L127

L127:
	%r113 = add i1 1, 0
	br i1 %r113, label %L127, label %L127

L127:
	%r114 = add i32 0, 1
	call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.nl, i32 0, i32 0), i32 %r114)
	br label %L128

L128:
	%r116 = add i1 1, 0
	%r115 = xor i32 1, %r116
	br i1 %r115, label %L128, label %L128

L128:
	%r117 = add i32 0, 0
	call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.nl, i32 0, i32 0), i32 %r117)
	br label %L129

L129:
	%r118 = add i1 0, 0
	br i1 %r118, label %L129, label %L129

L129:
	%r119 = add i32 0, 0
	call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.nl, i32 0, i32 0), i32 %r119)
	br label %L130

L130:
	%r121 = add i1 0, 0
	%r120 = xor i32 1, %r121
	br i1 %r120, label %L130, label %L130

L130:
	%r122 = add i32 0, 1
	call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.nl, i32 0, i32 0), i32 %r122)
	br label %L131

L131:
	%r124 = add i1 0, 0
	%r123 = xor i32 1, %r124
	br i1 %r123, label %L131, label %L131

L131:
	%r125 = add i32 0, 1
	call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.nl, i32 0, i32 0), i32 %r125)
	br label %L136

L136:
	call void @printgroup(i32 4)
	%r130 = add i32 0, 2
	%r131 = add i32 0, 3
	%r129 = add i32 %r130, %r131
	%r132 = add i32 0, 5
	%r128 = icmp eq i32 %r129, %r132
	br i1 %r128, label %L138, label %L139

L138:
	%r133 = add i32 0, 1
	call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.nl, i32 0, i32 0), i32 %r133)
	br label %L140

L140:
	%r136 = add i32 0, 2
	%r137 = add i32 0, 3
	%r135 = mul i32 %r136, %r137
	%r138 = add i32 0, 6
	%r134 = icmp eq i32 %r135, %r138
	br i1 %r134, label %L140, label %L141

L140:
	%r139 = add i32 0, 1
	call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.nl, i32 0, i32 0), i32 %r139)
	br label %L142

L142:
	%r142 = add i32 0, 3
	%r143 = add i32 0, 2
	%r141 = sub i32 %r142, %r143
	%r144 = add i32 0, 1
	%r140 = icmp eq i32 %r141, %r144
	br i1 %r140, label %L142, label %L143

L142:
	%r145 = add i32 0, 1
	call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.nl, i32 0, i32 0), i32 %r145)
	br label %L144

L144:
	%r148 = add i32 0, 6
	%r149 = add i32 0, 3
	%r147 = sdiv i32 %r148, %r149
	%r150 = add i32 0, 2
	%r146 = icmp eq i32 %r147, %r150
	br i1 %r146, label %L144, label %L145

L144:
	%r151 = add i32 0, 1
	call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.nl, i32 0, i32 0), i32 %r151)
	br label %L146

L146:
	%r154 = add i32 0, 6
	%r153 = mul i32 -1, %r154
	%r155 = add i32 0, 0
	%r152 = icmp slt i32 %r153, %r155
	br i1 %r152, label %L146, label %L146

L146:
	%r156 = add i32 0, 1
	call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.nl, i32 0, i32 0), i32 %r156)
	br label %L150

L150:
	call void @printgroup(i32 5)
	%r159 = add i32 0, 42
	store i32 %r159, i32* %i1
	%r161 = add i32 0, 42
	%r160 = icmp eq i32 %i1, %r161
	br i1 %r160, label %L152, label %L152

L152:
	%r162 = add i32 0, 1
	call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.nl, i32 0, i32 0), i32 %r162)
	br label %L154

L154:
	%r163 = add i32 0, 3
	store i32 %r163, i32* %i1
	%r164 = add i32 0, 2
	store i32 %r164, i32* %i2
	%r165 = add i32 %i1, %i2
	store i32 %r165, i32* %i3
	%r167 = add i32 0, 5
	%r166 = icmp eq i32 %i3, %r167
	br i1 %r166, label %L157, label %L157

L157:
	%r168 = add i32 0, 1
	call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.nl, i32 0, i32 0), i32 %r168)
	br label %L159

L159:
	%r169 = add i1 1, 0
	store i1 %r169, i1* %b1
	br i1 %b1, label %L160, label %L160

L160:
	%r171 = add i32 0, 1
	call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.nl, i32 0, i32 0), i32 %r171)
	br label %L161

L161:
	%r172 = xor i32 1, %b1
	br i1 %r172, label %L161, label %L161

L161:
	%r173 = add i32 0, 0
	call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.nl, i32 0, i32 0), i32 %r173)
	br label %L163

L163:
	%r174 = add i1 0, 0
	store i1 %r174, i1* %b1
	br i1 %b1, label %L164, label %L164

L164:
	%r176 = add i32 0, 0
	call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.nl, i32 0, i32 0), i32 %r176)
	br label %L165

L165:
	%r177 = xor i32 1, %b1
	br i1 %r177, label %L165, label %L165

L165:
	%r178 = add i32 0, 1
	call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.nl, i32 0, i32 0), i32 %r178)
	br label %L166

L166:
	br i1 %b1, label %L166, label %L166

L166:
	%r180 = add i32 0, 0
	call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.nl, i32 0, i32 0), i32 %r180)
	br label %L170

L170:
	call void @printgroup(i32 6)
	%r183 = add i32 0, 0
	store i32 %r183, i32* %i1
	br label %L172

L172:
	%r185 = add i32 0, 5
	%r184 = icmp slt i32 %i1, %r185
	br i1 %r184, label %L173, label %L176

L173:
	%r187 = add i32 0, 5
	%r186 = icmp sge i32 %i1, %r187
	br i1 %r186, label %L173, label %L174

L173:
	%r188 = add i32 0, 0
	call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.nl, i32 0, i32 0), i32 %r188)
	br label %L174

L174:
	%r190 = add i32 0, 5
	%r189 = add i32 %i1, %r190
	store i32 %r189, i32* %i1
	br label %L172

L176:
	%r192 = add i32 0, 5
	%r191 = icmp eq i32 %i1, %r192
	br i1 %r191, label %L176, label %L176

L176:
	%r193 = add i32 0, 1
	call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.nl, i32 0, i32 0), i32 %r193)
	br label %L180

L180:
	call void @printgroup(i32 7)
	%r197 = call i8* @malloc(i32 12)
	%r196 = bitcast i8* %r197 to %struct.thing*
	store %struct.thing* %r196, %struct.thing** %s1
	%r198 = add i32 0, 42
	%r201 = load %struct.thing*, %struct.thing** %s1
	%r200 = getelementptr %struct.thing, %struct.thing* %r201, i32 0, i32 0
	%r199 = load i32, i32* %r200
	store i32 %r198, i32* %r199
	%r202 = add i1 1, 0
	%r205 = load %struct.thing*, %struct.thing** %s1
	%r204 = getelementptr %struct.thing, %struct.thing* %r205, i32 0, i32 1
	%r203 = load i1, i1* %r204
	store i32 %r202, i32* %r203
	%r208 = load %struct.thing*, %struct.thing** %s1
	%r207 = getelementptr %struct.thing, %struct.thing* %r208, i32 0, i32 0
	%r209 = add i32 0, 42
	%r206 = icmp eq i32 %r207, %r209
	br i1 %r206, label %L185, label %L185

L185:
	%r210 = add i32 0, 1
	call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.nl, i32 0, i32 0), i32 %r210)
	br label %L186

L186:
	%r212 = load %struct.thing*, %struct.thing** %s1
	%r211 = getelementptr %struct.thing, %struct.thing* %r212, i32 0, i32 1
	br i1 %r211, label %L186, label %L186

L186:
	%r213 = add i32 0, 1
	call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.nl, i32 0, i32 0), i32 %r213)
	br label %L188

L188:
	%r215 = call i8* @malloc(i32 12)
	%r214 = bitcast i8* %r215 to %struct.thing*
	%r218 = load %struct.thing*, %struct.thing** %s1
	%r217 = getelementptr %struct.thing, %struct.thing* %r218, i32 0, i32 2
	%r216 = load %struct.thing*, %struct.thing** %r217
	store i32 %r214, i32* %r216
	%r219 = add i32 0, 13
	%r224 = load %struct.thing*, %struct.thing** %s1
	%r223 = getelementptr %struct.thing, %struct.thing* %r224, i32 0, i32 2
	%r222 = load %struct.thing*, %struct.thing** %r223
	%r221 = getelementptr %struct.thing, %struct.thing* %r222, i32 0, i32 0
	%r220 = load i32, i32* %r221
	store i32 %r219, i32* %r220
	%r225 = add i1 0, 0
	%r230 = load %struct.thing*, %struct.thing** %s1
	%r229 = getelementptr %struct.thing, %struct.thing* %r230, i32 0, i32 2
	%r228 = load %struct.thing*, %struct.thing** %r229
	%r227 = getelementptr %struct.thing, %struct.thing* %r228, i32 0, i32 1
	%r226 = load i1, i1* %r227
	store i32 %r225, i32* %r226
	%r235 = load %struct.thing*, %struct.thing** %s1
	%r234 = getelementptr %struct.thing, %struct.thing* %r235, i32 0, i32 2
	%r233 = load %struct.thing*, %struct.thing** %r234
	%r232 = getelementptr %struct.thing, %struct.thing* %r233, i32 0, i32 0
	%r236 = add i32 0, 13
	%r231 = icmp eq i32 %r232, %r236
	br i1 %r231, label %L192, label %L192

L192:
	%r237 = add i32 0, 1
	call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.nl, i32 0, i32 0), i32 %r237)
	br label %L193

L193:
	%r242 = load %struct.thing*, %struct.thing** %s1
	%r241 = getelementptr %struct.thing, %struct.thing* %r242, i32 0, i32 2
	%r240 = load %struct.thing*, %struct.thing** %r241
	%r239 = getelementptr %struct.thing, %struct.thing* %r240, i32 0, i32 1
	%r238 = xor i32 1, %r239
	br i1 %r238, label %L193, label %L193

L193:
	%r243 = add i32 0, 1
	call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.nl, i32 0, i32 0), i32 %r243)
	br label %L195

L195:
	%r245 = bitcast %struct.thing* %s1 to i32*
	%r246 = bitcast %struct.thing* %s1 to i32*
	%r244 = icmp eq i32* %r245, %r246
	br i1 %r244, label %L195, label %L195

L195:
	%r247 = add i32 0, 1
	call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.nl, i32 0, i32 0), i32 %r247)
	br label %L196

L196:
	%r251 = bitcast %struct.thing* %s1 to i32*
	%r250 = load %struct.thing*, %struct.thing** %s1
	%r249 = getelementptr %struct.thing, %struct.thing* %r250, i32 0, i32 2
	%r252 = bitcast %struct.thing* %r249 to i32*
	%r248 = icmp ne i32* %r251, %r252
	br i1 %r248, label %L196, label %L196

L196:
	%r253 = add i32 0, 1
	call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.nl, i32 0, i32 0), i32 %r253)
	br label %L198

L198:
	%r255 = load %struct.thing*, %struct.thing** %s1
	%r254 = getelementptr %struct.thing, %struct.thing* %r255, i32 0, i32 2
	%r256 = bitcast %struct.thing* %r254 to i8*
	call void @free(i8* %r256)
	%r257 = load %struct.thing*, %struct.thing** %s1
	%r258 = bitcast %struct.thing* %r257 to i8*
	call void @free(i8* %r258)
	call void @printgroup(i32 8)
	%r261 = add i32 0, 7
	store i32 %r261, i32* @gi1
	%r263 = load i32, i32* @gi1
	%r264 = add i32 0, 7
	%r262 = icmp eq i32 %r263, %r264
	br i1 %r262, label %L206, label %L206

L206:
	%r265 = add i32 0, 1
	call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.nl, i32 0, i32 0), i32 %r265)
	br label %L208

L208:
	%r266 = add i1 1, 0
	store i1 %r266, i1* @gb1
	%r267 = load i1, i1* @gb1
	br i1 %r267, label %L209, label %L209

L209:
	%r268 = add i32 0, 1
	call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.nl, i32 0, i32 0), i32 %r268)
	br label %L211

L211:
	%r270 = call i8* @malloc(i32 12)
	%r269 = bitcast i8* %r270 to %struct.thing*
	store %struct.thing* %r269, %struct.thing** @gs1
	%r271 = add i32 0, 34
	%r274 = load %struct.thing*, %struct.thing** @gs1
	%r273 = getelementptr %struct.thing, %struct.thing* %r274, i32 0, i32 0
	%r272 = load i32, i32* %r273
	store i32 %r271, i32* %r272
	%r275 = add i1 0, 0
	%r278 = load %struct.thing*, %struct.thing** @gs1
	%r277 = getelementptr %struct.thing, %struct.thing* %r278, i32 0, i32 1
	%r276 = load i1, i1* %r277
	store i32 %r275, i32* %r276
	%r281 = load %struct.thing*, %struct.thing** @gs1
	%r280 = getelementptr %struct.thing, %struct.thing* %r281, i32 0, i32 0
	%r282 = add i32 0, 34
	%r279 = icmp eq i32 %r280, %r282
	br i1 %r279, label %L214, label %L215

L214:
	%r283 = add i32 0, 1
	call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.nl, i32 0, i32 0), i32 %r283)
	br label %L216

L216:
	%r286 = load %struct.thing*, %struct.thing** @gs1
	%r285 = getelementptr %struct.thing, %struct.thing* %r286, i32 0, i32 1
	%r284 = xor i32 1, %r285
	br i1 %r284, label %L216, label %L216

L216:
	%r287 = add i32 0, 1
	call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.nl, i32 0, i32 0), i32 %r287)
	br label %L218

L218:
	%r289 = call i8* @malloc(i32 12)
	%r288 = bitcast i8* %r289 to %struct.thing*
	%r292 = load %struct.thing*, %struct.thing** @gs1
	%r291 = getelementptr %struct.thing, %struct.thing* %r292, i32 0, i32 2
	%r290 = load %struct.thing*, %struct.thing** %r291
	store i32 %r288, i32* %r290
	%r293 = add i32 0, 16
	%r298 = load %struct.thing*, %struct.thing** @gs1
	%r297 = getelementptr %struct.thing, %struct.thing* %r298, i32 0, i32 2
	%r296 = load %struct.thing*, %struct.thing** %r297
	%r295 = getelementptr %struct.thing, %struct.thing* %r296, i32 0, i32 0
	%r294 = load i32, i32* %r295
	store i32 %r293, i32* %r294
	%r299 = add i1 1, 0
	%r304 = load %struct.thing*, %struct.thing** @gs1
	%r303 = getelementptr %struct.thing, %struct.thing* %r304, i32 0, i32 2
	%r302 = load %struct.thing*, %struct.thing** %r303
	%r301 = getelementptr %struct.thing, %struct.thing* %r302, i32 0, i32 1
	%r300 = load i1, i1* %r301
	store i32 %r299, i32* %r300
	%r309 = load %struct.thing*, %struct.thing** @gs1
	%r308 = getelementptr %struct.thing, %struct.thing* %r309, i32 0, i32 2
	%r307 = load %struct.thing*, %struct.thing** %r308
	%r306 = getelementptr %struct.thing, %struct.thing* %r307, i32 0, i32 0
	%r310 = add i32 0, 16
	%r305 = icmp eq i32 %r306, %r310
	br i1 %r305, label %L221, label %L222

L221:
	%r311 = add i32 0, 1
	call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.nl, i32 0, i32 0), i32 %r311)
	br label %L223

L223:
	%r315 = load %struct.thing*, %struct.thing** @gs1
	%r314 = getelementptr %struct.thing, %struct.thing* %r315, i32 0, i32 2
	%r313 = load %struct.thing*, %struct.thing** %r314
	%r312 = getelementptr %struct.thing, %struct.thing* %r313, i32 0, i32 1
	br i1 %r312, label %L223, label %L223

L223:
	%r316 = add i32 0, 1
	call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.nl, i32 0, i32 0), i32 %r316)
	br label %L225

L225:
	%r318 = load %struct.thing*, %struct.thing** @gs1
	%r317 = getelementptr %struct.thing, %struct.thing* %r318, i32 0, i32 2
	%r319 = bitcast %struct.thing* %r317 to i8*
	call void @free(i8* %r319)
	%r320 = load %struct.thing*, %struct.thing** @gs1
	%r321 = bitcast %struct.thing* %r320 to i8*
	call void @free(i8* %r321)
	call void @printgroup(i32 9)
	%r325 = call i8* @malloc(i32 12)
	%r324 = bitcast i8* %r325 to %struct.thing*
	store %struct.thing* %r324, %struct.thing** %s1
	%r326 = add i1 1, 0
	%r329 = load %struct.thing*, %struct.thing** %s1
	%r328 = getelementptr %struct.thing, %struct.thing* %r329, i32 0, i32 1
	%r327 = load i1, i1* %r328
	store i32 %r326, i32* %r327
	call void @takealltypes(i32 3, i1 1, %struct.thing* %s1)
	%r334 = add i32 0, 2
	call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.nl, i32 0, i32 0), i32 %r334)
	call void @tonofargs(i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7, i32 8)
	%r344 = add i32 0, 3
	call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.nl, i32 0, i32 0), i32 %r344)
	%r345 = call i32 @returnint(i32 3)
	store i32 %r345, i32* %i1
	%r348 = add i32 0, 3
	%r347 = icmp eq i32 %i1, %r348
	br i1 %r347, label %L242, label %L242

L242:
	%r349 = add i32 0, 1
	call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.nl, i32 0, i32 0), i32 %r349)
	br label %L244

L244:
	%r350 = call i1 @returnbool(i1 1)
	store i1 %r350, i1* %b1
	br i1 %b1, label %L245, label %L245

L245:
	%r353 = add i32 0, 1
	call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.nl, i32 0, i32 0), i32 %r353)
	br label %L247

L247:
	%r355 = call i8* @malloc(i32 12)
	%r354 = bitcast i8* %r355 to %struct.thing*
	store %struct.thing* %r354, %struct.thing** %s1
	%r356 = call %struct.thing* @returnstruct(%struct.thing* %s1)
	store %struct.thing* %r356, %struct.thing** %s2
	%r359 = bitcast %struct.thing* %s1 to i32*
	%r360 = bitcast %struct.thing* %s2 to i32*
	%r358 = icmp eq i32* %r359, %r360
	br i1 %r358, label %L249, label %L249

L249:
	%r361 = add i32 0, 1
	call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.nl, i32 0, i32 0), i32 %r361)
	br label %L251

L251:
	call void @printgroup(i32 10)
	%r364 = add i32 0, 0
	store i32 %r364, i32* %return
	br label %END

END:
	%r365 = load i32, i32* %return
	ret i32 %r365

L249:
	%r366 = add i32 0, 0
	call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.nl, i32 0, i32 0), i32 %r366)
	br label %L251

L245:
	%r367 = add i32 0, 0
	call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.nl, i32 0, i32 0), i32 %r367)
	br label %L247

L242:
	%r368 = add i32 0, 0
	call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.d.space, i32 0, i32 0), i32 %r368)
	call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.nl, i32 0, i32 0), i32 %i1)
	br label %L244

L223:
	%r370 = add i32 0, 0
	call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.nl, i32 0, i32 0), i32 %r370)
	br label %L225

L222:
	%r371 = add i32 0, 0
	call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.d.space, i32 0, i32 0), i32 %r371)
	%r375 = load %struct.thing*, %struct.thing** @gs1
	%r374 = getelementptr %struct.thing, %struct.thing* %r375, i32 0, i32 2
	%r373 = load %struct.thing*, %struct.thing** %r374
	%r372 = getelementptr %struct.thing, %struct.thing* %r373, i32 0, i32 0
	call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.nl, i32 0, i32 0), i32 %r372)
	br label %L223

L216:
	%r376 = add i32 0, 0
	call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.nl, i32 0, i32 0), i32 %r376)
	br label %L218

L215:
	%r377 = add i32 0, 0
	call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.d.space, i32 0, i32 0), i32 %r377)
	%r379 = load %struct.thing*, %struct.thing** @gs1
	%r378 = getelementptr %struct.thing, %struct.thing* %r379, i32 0, i32 0
	call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.nl, i32 0, i32 0), i32 %r378)
	br label %L216

L209:
	%r380 = add i32 0, 0
	call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.nl, i32 0, i32 0), i32 %r380)
	br label %L211

L206:
	%r381 = add i32 0, 0
	call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.d.space, i32 0, i32 0), i32 %r381)
	%r382 = load i32, i32* @gi1
	call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.nl, i32 0, i32 0), i32 %r382)
	br label %L208

L196:
	%r383 = add i32 0, 0
	call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.nl, i32 0, i32 0), i32 %r383)
	br label %L198

L195:
	%r384 = add i32 0, 0
	call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.nl, i32 0, i32 0), i32 %r384)
	br label %L196

L193:
	%r385 = add i32 0, 0
	call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.nl, i32 0, i32 0), i32 %r385)
	br label %L195

L192:
	%r386 = add i32 0, 0
	call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.d.space, i32 0, i32 0), i32 %r386)
	%r390 = load %struct.thing*, %struct.thing** %s1
	%r389 = getelementptr %struct.thing, %struct.thing* %r390, i32 0, i32 2
	%r388 = load %struct.thing*, %struct.thing** %r389
	%r387 = getelementptr %struct.thing, %struct.thing* %r388, i32 0, i32 0
	call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.nl, i32 0, i32 0), i32 %r387)
	br label %L193

L186:
	%r391 = add i32 0, 0
	call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.nl, i32 0, i32 0), i32 %r391)
	br label %L188

L185:
	%r392 = add i32 0, 0
	call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.d.space, i32 0, i32 0), i32 %r392)
	%r394 = load %struct.thing*, %struct.thing** %s1
	%r393 = getelementptr %struct.thing, %struct.thing* %r394, i32 0, i32 0
	call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.nl, i32 0, i32 0), i32 %r393)
	br label %L186

L176:
	%r395 = add i32 0, 0
	call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.d.space, i32 0, i32 0), i32 %r395)
	call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.nl, i32 0, i32 0), i32 %i1)
	br label %L180

L166:
	%r397 = add i32 0, 1
	call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.nl, i32 0, i32 0), i32 %r397)
	br label %L170

L165:
	%r398 = add i32 0, 0
	call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.nl, i32 0, i32 0), i32 %r398)
	br label %L166

L164:
	%r399 = add i32 0, 1
	call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.nl, i32 0, i32 0), i32 %r399)
	br label %L165

L161:
	%r400 = add i32 0, 1
	call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.nl, i32 0, i32 0), i32 %r400)
	br label %L163

L160:
	%r401 = add i32 0, 0
	call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.nl, i32 0, i32 0), i32 %r401)
	br label %L161

L157:
	%r402 = add i32 0, 0
	call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.nl, i32 0, i32 0), i32 %r402)
	br label %L159

L152:
	%r403 = add i32 0, 0
	call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.nl, i32 0, i32 0), i32 %r403)
	br label %L154

L146:
	%r404 = add i32 0, 0
	call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.nl, i32 0, i32 0), i32 %r404)
	br label %L150

L145:
	%r405 = add i32 0, 0
	call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.d.space, i32 0, i32 0), i32 %r405)
	%r407 = add i32 0, 6
	%r408 = add i32 0, 3
	%r406 = sdiv i32 %r407, %r408
	call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.nl, i32 0, i32 0), i32 %r406)
	br label %L146

L143:
	%r409 = add i32 0, 0
	call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.d.space, i32 0, i32 0), i32 %r409)
	%r411 = add i32 0, 3
	%r412 = add i32 0, 2
	%r410 = sub i32 %r411, %r412
	call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.nl, i32 0, i32 0), i32 %r410)
	br label %L144

L141:
	%r413 = add i32 0, 0
	call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.d.space, i32 0, i32 0), i32 %r413)
	%r415 = add i32 0, 2
	%r416 = add i32 0, 3
	%r414 = mul i32 %r415, %r416
	call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.nl, i32 0, i32 0), i32 %r414)
	br label %L142

L139:
	%r417 = add i32 0, 0
	call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.d.space, i32 0, i32 0), i32 %r417)
	%r419 = add i32 0, 2
	%r420 = add i32 0, 3
	%r418 = add i32 %r419, %r420
	call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.nl, i32 0, i32 0), i32 %r418)
	br label %L140

L131:
	%r421 = add i32 0, 0
	call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.nl, i32 0, i32 0), i32 %r421)
	br label %L136

L130:
	%r422 = add i32 0, 0
	call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.nl, i32 0, i32 0), i32 %r422)
	br label %L131

L129:
	%r423 = add i32 0, 1
	call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.nl, i32 0, i32 0), i32 %r423)
	br label %L130

L128:
	%r424 = add i32 0, 1
	call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.nl, i32 0, i32 0), i32 %r424)
	br label %L129

L127:
	%r425 = add i32 0, 0
	call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.nl, i32 0, i32 0), i32 %r425)
	br label %L128

L126:
	%r426 = add i32 0, 0
	call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.nl, i32 0, i32 0), i32 %r426)
	br label %L127

L125:
	%r427 = add i32 0, 1
	call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.nl, i32 0, i32 0), i32 %r427)
	br label %L126

L124:
	%r428 = add i32 0, 1
	call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.nl, i32 0, i32 0), i32 %r428)
	br label %L125

L123:
	%r429 = add i32 0, 1
	call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.nl, i32 0, i32 0), i32 %r429)
	br label %L124

L122:
	%r430 = add i32 0, 0
	call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.nl, i32 0, i32 0), i32 %r430)
	br label %L123

L121:
	%r431 = add i32 0, 0
	call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.nl, i32 0, i32 0), i32 %r431)
	br label %L122

L115:
	%r432 = add i32 0, 1
	call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.nl, i32 0, i32 0), i32 %r432)
	br label %L119

L111:
	%r433 = add i32 0, 0
	call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.nl, i32 0, i32 0), i32 %r433)
	br label %L113

L107:
	%r434 = add i32 0, 0
	call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.nl, i32 0, i32 0), i32 %r434)
	br label %L109

L103:
	%r435 = add i32 0, 0
	call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.nl, i32 0, i32 0), i32 %r435)
	br label %L105

L94:
	%r436 = add i32 0, 0
	call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.nl, i32 0, i32 0), i32 %r436)
	br label %L96

L90:
	%r437 = add i32 0, 1
	call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.nl, i32 0, i32 0), i32 %r437)
	br label %L92

L86:
	%r438 = add i32 0, 1
	call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.nl, i32 0, i32 0), i32 %r438)
	br label %L88

L82:
	%r439 = add i32 0, 1
	call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.nl, i32 0, i32 0), i32 %r439)
	br label %L84
}

