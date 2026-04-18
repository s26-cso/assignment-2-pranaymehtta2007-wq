.data
format_str: .string "%d "       
newline:    .string "\n"

.text
.global main
main:
addi sp,sp,-64
sd ra,56(sp)

sd s0,48(sp)
sd s1,40(sp)
addi t0,a0,-1
sd t0,16(sp)   #store n-1
addi t1,a1,8
sd t1,8(sp)    #store current arg poniter skipping arg[0]
ld a0,16(sp)
slli a0,a0,2  #n=n*4
call malloc
sd a0,0(sp)    #base adress of result array

li s0,0        #loop counter

loop:
ld t1,16(sp)
bge s0,t1,done
ld t2,8(sp)
ld a0,0(t2)
call atoi
ld t3,0(sp)
slli t4,s0,2
add t4,t4,t3
sw a0,0(t4)
ld t2,8(sp)
addi t2,t2,8
sd t2,8(sp)
addi s0,s0,1
j loop

done:
#malloc for final array
ld a0, 16(sp)
slli a0, a0, 2       
call malloc
sd a0, 8(sp)

#malloc for stack
ld a0, 16(sp)
slli a0, a0, 2       
call malloc
sd a0,24(sp) 

li s1,0   #stack index
ld s0,16(sp)
addi s0,s0,-1  # i=n-1

forloop:
bltz s0,phase3
whileloop:
beqz s1,end_while

ld t1,24(sp)  
addi t0,s1,-1
slli t0,t0,2
add t1,t1,t0
lw t2,0(t1)   #t2=stack[top]

ld t0,0(sp)
slli t3,t2,2
add t0,t0,t3
lw t4,0(t0)   #t4=arr[stack[top]]

slli t5,s0,2
ld t0,0(sp)
add t0,t0,t5
lw t6,0(t0)  #t6=arr[i]

bgt t4,t6,end_while
addi s1,s1,-1
j whileloop

end_while:
ld t0,8(sp)
slli t1,s0,2
add t0,t0,t1

beqz s1, stack_empty
sw t2, 0(t0)
j push_i

stack_empty:
li t3, -1            # Load -1
sw t3, 0(t0)

push_i:
# stack.push(i)
ld t0, 24(sp)  
slli t1, s1, 2       
add t1, t0, t1      
sw s0, 0(t1)         # stack[top] = i
addi s1, s1, 1       # top++
addi s0, s0, -1   
j forloop

phase3:
li s0,0  #i=0
print_loop:
ld t0,16(sp)
bge s0,t0,exit
ld t1,8(sp)
slli t2,s0,2
add t1,t1,t2
lw a1,0(t1)
la a0,format_str
call printf
addi s0,s0,1
j print_loop

exit:
ld ra, 56(sp)      
ld s0, 48(sp)   
ld s1, 40(sp)          
addi sp, sp, 64       
li a0, 0            
ret
