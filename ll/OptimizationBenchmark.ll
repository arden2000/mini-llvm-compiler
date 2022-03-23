declare i8* @malloc(i32)
declare void @free(i8*)
declare i32 @printf(i8*, ...)
declare i32 @scanf(i8*, ...)

@.d = private unnamed_addr constant [3 x i8] c"%d\00", align 1
@.d.space = private unnamed_addr constant [4 x i8] c"%d \00", align 1
@.nl = private unnamed_addr constant [4 x i8] c"%d\0A\00", align 1

@.null = global i32* null
@.read = global i32 0


@global1 = global i32 0
@global2 = global i32 0
@global3 = global i32 0

define i32 @constantFolding() {
START:
	br label %END

END:
	ret i32 288
}

define i32 @constantPropagation() {
START:
	br label %END

END:
	ret i32 2306
}

define i32 @deadCodeElimination() {
START:
	br label %L64

L64:
	store i32 11, i32* @global1
	store i32 5, i32* @global1
	store i32 9, i32* @global1
	br label %END

END:
	ret i32 38
}

define i32 @sum(i32 %number) {
START:
	br label %L95

L95:
	br label %L96

L96:
	%r154 = phi i32 [ 0, %L95 ], [ %r155, %L97 ]
	%r153 = phi i32 [ %number, %L95 ], [ %r156, %L97 ]
	%r158 = icmp sgt i32 %r153, 0
	br i1 %r158, label %L97, label %END

L97:
	%r155 = add i32 %r154, %r153
	%r156 = sub i32 %r153, 1
	br label %L96

END:
	ret i32 %r154
}

define i32 @doesntModifyGlobals() {
START:
	br label %END

END:
	ret i32 3
}

define i32 @interProceduralOptimization() {
START:
	br label %L116

L116:
	store i32 1, i32* @global1
	store i32 0, i32* @global2
	store i32 0, i32* @global3
	%r172 = call i32 @sum(i32 100)
	%r175 = load i32, i32* @global1
	%r174 = icmp eq i32 %r175, 1
	br i1 %r174, label %L122, label %L124

L122:
	%r177 = call i32 @sum(i32 10000)
	br label %L132

L132:
	%r191 = phi i32 [ %r177, %L122 ], [ %r190, %EmptyNode0 ]
	br label %END

END:
	ret i32 %r191

L124:
	%r180 = load i32, i32* @global2
	%r179 = icmp eq i32 %r180, 2
	br i1 %r179, label %L125, label %L127

L125:
	%r182 = call i32 @sum(i32 20000)
	br label %L127

L127:
	%r184 = phi i32 [ %r182, %L125 ], [ %r172, %L124 ]
	%r186 = load i32, i32* @global3
	%r185 = icmp eq i32 %r186, 3
	br i1 %r185, label %L128, label %EmptyNode0

L128:
	%r188 = call i32 @sum(i32 30000)
	br label %EmptyNode0

EmptyNode0:
	%r190 = phi i32 [ %r188, %L128 ], [ %r184, %L127 ]
	br label %L132
}

define i32 @commonSubexpressionElimination() {
START:
	br label %END

END:
	ret i32 63415
}

define i32 @hoisting() {
START:
	br label %L182

L182:
	br label %L188

L188:
	%r374 = phi i32 [ 0, %L182 ], [ %r380, %L189 ]
	%r382 = icmp slt i32 %r374, 1000000
	br i1 %r382, label %L189, label %END

L189:
	%r380 = add i32 %r374, 1
	br label %L188

END:
	ret i32 2
}

define i32 @doubleIf() {
START:
	br label %L223

L223:
	br label %END

END:
	ret i32 50
}

define i32 @integerDivide() {
START:
	br label %END

END:
	ret i32 736
}

define i32 @association() {
START:
	br label %END

END:
	ret i32 4
}

define i32 @tailRecursionHelper(i32 %value, i32 %sum) {
START:
	br label %L274

L274:
	%r459 = icmp eq i32 %value, 0
	br i1 %r459, label %L275, label %L277

L275:
	br label %END

END:
	%r466 = phi i32 [ %sum, %L275 ], [ %r462, %L277 ]
	ret i32 %r466

L277:
	%r463 = sub i32 %value, 1
	%r465 = add i32 %sum, %value
	%r462 = call i32 @tailRecursionHelper(i32 %r463, i32 %r465)
	br label %END
}

define i32 @tailRecursion(i32 %value) {
START:
	br label %L283

L283:
	%r467 = call i32 @tailRecursionHelper(i32 %value, i32 0)
	br label %END

END:
	ret i32 %r467
}

define i32 @unswitching() {
START:
	br label %L293

L293:
	br label %L296

L296:
	%r476 = phi i32 [ 2, %L293 ], [ %r476, %EmptyNode2 ]
	%r475 = phi i32 [ 1, %L293 ], [ %r484, %EmptyNode2 ]
	%r485 = icmp slt i32 %r475, 1000000
	br i1 %r485, label %L297, label %END

L297:
	%r477 = icmp eq i32 %r476, 2
	br i1 %r477, label %L298, label %L300

L298:
	%r479 = add i32 %r475, 1
	br label %EmptyNode2

EmptyNode2:
	%r484 = phi i32 [ %r479, %L298 ], [ %r481, %L300 ]
	br label %L296

L300:
	%r481 = add i32 %r475, 2
	br label %EmptyNode2

END:
	ret i32 %r475
}

define i32 @randomCalculation(i32 %number) {
START:
	br label %L317

L317:
	br label %L320

L320:
	%r505 = phi i32 [ 0, %L317 ], [ %r511, %L321 ]
	%r504 = phi i32 [ 0, %L317 ], [ %r524, %L321 ]
	%r526 = icmp slt i32 %r504, %number
	br i1 %r526, label %L321, label %END

L321:
	%r511 = add i32 %r505, 19
	%r512 = mul i32 %r504, 2
	%r514 = sdiv i32 %r512, 2
	%r516 = mul i32 3, %r514
	%r518 = sdiv i32 %r516, 3
	%r520 = mul i32 %r518, 4
	%r522 = sdiv i32 %r520, 4
	%r524 = add i32 %r522, 1
	br label %L320

END:
	ret i32 %r505
}

define i32 @iterativeFibonacci(i32 %number) {
START:
	br label %L348

L348:
	br label %L352

L352:
	%r542 = phi i32 [ 0, %L348 ], [ %r547, %L353 ]
	%r540 = phi i32 [ 1, %L348 ], [ %r544, %L353 ]
	%r539 = phi i32 [ -1, %L348 ], [ %r540, %L353 ]
	%r549 = icmp slt i32 %r542, %number
	br i1 %r549, label %L353, label %END

L353:
	%r544 = add i32 %r540, %r539
	%r547 = add i32 %r542, 1
	br label %L352

END:
	ret i32 %r540
}

define i32 @recursiveFibonacci(i32 %number) {
START:
	br label %L365

L365:
	%r553 = icmp sle i32 %number, 0
	%r555 = icmp eq i32 %number, 1
	%r552 = or i1 %r553, %r555
	br i1 %r552, label %L366, label %L368

L366:
	br label %END

END:
	%r565 = phi i32 [ %number, %L366 ], [ %r558, %L368 ]
	ret i32 %r565

L368:
	%r560 = sub i32 %number, 1
	%r559 = call i32 @recursiveFibonacci(i32 %r560)
	%r563 = sub i32 %number, 2
	%r562 = call i32 @recursiveFibonacci(i32 %r563)
	%r558 = add i32 %r559, %r562
	br label %END
}

define i32 @main() {
START:
	br label %L380

L380:
	call i32 (i8*, ...) @scanf(i8* getelementptr inbounds ([3 x i8], [3 x i8]* @.d, i32 0, i32 0), i32* @.read)
	%r569 = load i32, i32* @.read
	br label %L383

L383:
	%r573 = phi i32 [ 1, %L380 ], [ %r609, %L384 ]
	%r611 = icmp slt i32 %r573, %r569
	br i1 %r611, label %L384, label %L415

L384:
	%r574 = call i32 @constantFolding()
	call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.nl, i32 0, i32 0), i32 %r574)
	%r576 = call i32 @constantPropagation()
	call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.nl, i32 0, i32 0), i32 %r576)
	%r578 = call i32 @deadCodeElimination()
	call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.nl, i32 0, i32 0), i32 %r578)
	%r580 = call i32 @interProceduralOptimization()
	call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.nl, i32 0, i32 0), i32 %r580)
	%r582 = call i32 @commonSubexpressionElimination()
	call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.nl, i32 0, i32 0), i32 %r582)
	%r584 = call i32 @hoisting()
	call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.nl, i32 0, i32 0), i32 %r584)
	%r586 = call i32 @doubleIf()
	call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.nl, i32 0, i32 0), i32 %r586)
	%r588 = call i32 @integerDivide()
	call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.nl, i32 0, i32 0), i32 %r588)
	%r590 = call i32 @association()
	call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.nl, i32 0, i32 0), i32 %r590)
	%r593 = sdiv i32 %r569, 1000
	%r592 = call i32 @tailRecursion(i32 %r593)
	call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.nl, i32 0, i32 0), i32 %r592)
	%r596 = call i32 @unswitching()
	call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.nl, i32 0, i32 0), i32 %r596)
	%r598 = call i32 @randomCalculation(i32 %r569)
	call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.nl, i32 0, i32 0), i32 %r598)
	%r602 = sdiv i32 %r569, 5
	%r601 = call i32 @iterativeFibonacci(i32 %r602)
	call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.nl, i32 0, i32 0), i32 %r601)
	%r606 = sdiv i32 %r569, 1000
	%r605 = call i32 @recursiveFibonacci(i32 %r606)
	call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.nl, i32 0, i32 0), i32 %r605)
	%r609 = add i32 %r573, 1
	br label %L383

L415:
	call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.nl, i32 0, i32 0), i32 9999)
	br label %END

END:
	ret i32 0
}

