.text
.global make_node
.global insert
.global get
.global getAtMost
make_node:
addi sp,sp,-16
sd ra,8(sp)
sd a0,0(sp)
li a0,24
call malloc
beqz a0, malloc_error
lw t0,0(sp)
sw t0,0(a0)
sd x0,8(a0)
sd x0,16(a0)
malloc_error:
ld ra,8(sp)
addi sp,sp,16
ret

insert:
addi sp,sp,-32
sd ra,16(sp)
sd a0,8(sp)
sd a1,0(sp)
bnez a0,insert_compare
mv a0,a1
call make_node
beq x0,x0, insert_done
insert_compare:
ld t0,8(sp)
lw t1,0(t0)  #root->val
lw t2,0(sp)  #val
blt t1,t2 ,insert_right
beq t1,t2,insert_equal
ld a0,8(t0)
ld a1,0(sp)
call insert
ld t0,8(sp)
sd a0,8(t0)
j insert_root


insert_right:
ld a0,16(t0)
ld a1,0(sp)
call insert
ld t0,8(sp)
sd a0,16(t0)
j insert_root

insert_equal:
j insert_done
insert_root:
ld a0,8(sp)
insert_done:
ld ra,16(sp)
addi sp,sp,32
ret

get:
addi sp,sp,-32
sd ra,16(sp)  
sd a0,8(sp)   #root
sd a1,0(sp)   #val
ld t0,8(sp)
beq t0,x0 ,get_invalid
lw t1,0(t0) #root->val
lw t2,0(sp) #val
beq t1,t2, get_found
blt t1,t2,get_right
ld a0,8(t0)
ld a1,0(sp)
call get
j get_done
get_right:
ld a0,16(t0)
ld a1,0(sp)
call get
j get_done
get_found:
ld a0,8(sp)
j get_done
get_invalid:
li a0,0
get_done:
ld ra,16(sp)
addi sp,sp,32
ret

getAtMost:
li a2,-1
getAtMost_loop:
beq a1,x0 ,getAtMost_done
lw t0,0(a1)  #t0-root->val a0-val
blt a0,t0 ,getAtMost_left
mv a2,t0
ld a1,16(a1)
j getAtMost_loop
getAtMost_left:
ld a1,8(a1)
j getAtMost_loop
getAtMost_done:
mv a0,a2
ret

