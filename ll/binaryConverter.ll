declare i8* @malloc(i32)
declare void @free(i8*)
declare i32 @printf(i8*, ...)
declare i32 @scanf(i8*, ...)

@.d = private unnamed_addr constant [3 x i8] c"%d\00", align 1
@.d.space = private unnamed_addr constant [4 x i8] c"%d \00", align 1
@.nl = private unnamed_addr constant [4 x i8] c"%d\0A\00", align 1

@.null = global i32* null
@.read = global i32 0



define i32 @wait(i32 %waitTime) {
START:
	br label %L3

L3:
	%r1 = phi i32 [ %r2, %L5 ], [ %waitTime, %START ]
	%r4 = icmp sgt i32 %r1, 0
	br i1 %r4, label %L5, label %END

L5:
	%r2 = sub i32 %r1, 1
	br label %L3

END:
	ret i32 0
}

define i32 @power(i32 %base, i32 %exponent) {
START:
	br label %L15

L15:
	br label %L16

L16:
	%r12 = phi i32 [ 1, %L15 ], [ %r13, %L18 ]
	%r11 = phi i32 [ %exponent, %L15 ], [ %r14, %L18 ]
	%r16 = icmp sgt i32 %r11, 0
	br i1 %r16, label %L18, label %END

L18:
	%r13 = mul i32 %r12, %base
	%r14 = sub i32 %r11, 1
	br label %L16

END:
	ret i32 %r12
}

define i32 @recursiveDecimalSum(i32 %binaryNum, i32 %decimalSum, i32 %recursiveDepth) {
START:
	br label %L29

L29:
	%r23 = icmp sgt i32 %binaryNum, 0
	br i1 %r23, label %L31, label %L45

L31:
	%r26 = sdiv i32 %binaryNum, 10
	%r28 = mul i32 %r26, 10
	%r30 = sub i32 %binaryNum, %r28
	%r31 = icmp eq i32 %r30, 1
	br i1 %r31, label %L39, label %L42

L39:
	%r35 = call i32 @power(i32 2, i32 %recursiveDepth)
	%r34 = add i32 %decimalSum, %r35
	br label %L42

L42:
	%r42 = phi i32 [ %r34, %L39 ], [ %decimalSum, %L31 ]
	%r45 = sdiv i32 %binaryNum, 10
	%r48 = add i32 %recursiveDepth, 1
	%r44 = call i32 @recursiveDecimalSum(i32 %r45, i32 %r42, i32 %r48)
	br label %END

END:
	%r50 = phi i32 [ %r44, %L42 ], [ %decimalSum, %L45 ]
	ret i32 %r50

L45:
	br label %END
}

define i32 @convertToDecimal(i32 %binaryNum) {
START:
	br label %L52

L52:
	%r55 = call i32 @recursiveDecimalSum(i32 %binaryNum, i32 0, i32 0)
	br label %END

END:
	ret i32 %r55
}

define i32 @main() {
START:
	br label %L62

L62:
	call i32 (i8*, ...) @scanf(i8* getelementptr inbounds ([3 x i8], [3 x i8]* @.d, i32 0, i32 0), i32* @.read)
	%r62 = load i32, i32* @.read
	%r63 = call i32 @convertToDecimal(i32 %r62)
	%r65 = mul i32 %r63, %r63
	br label %L67

L67:
	%r67 = phi i32 [ %r65, %L62 ], [ %r70, %L69 ]
	%r72 = icmp sgt i32 %r67, 0
	br i1 %r72, label %L69, label %L73

L69:
	%r68 = call i32 @wait(i32 %r67)
	%r70 = sub i32 %r67, 1
	br label %L67

L73:
	call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.nl, i32 0, i32 0), i32 %r63)
	br label %END

END:
	ret i32 0
}

