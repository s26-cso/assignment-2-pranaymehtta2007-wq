.text
    .globl make_node
    .globl insert
    .globl get
    .globl getAtMost

make_node:
    addi sp, sp, -16
    sd ra, 8(sp)
    sd a0, 0(sp)
    li a0, 24
    call malloc
    beqz a0, malloc_error
    lw t0, 0(sp)
    sw t0, 0(a0)
    sd x0, 8(a0)
    sd x0, 16(a0)
malloc_error:
    ld ra, 8(sp)
    addi sp, sp, 16
    ret

insert:
    addi sp, sp, -32
    sd ra, 24(sp)
    sd a0, 16(sp)
    sd a1, 8(sp)
    
    bnez a0, insert_compare
    mv a0, a1
    call make_node
    j insert_done

insert_compare:
    ld t0, 16(sp)
    lw t1, 0(t0)         # root->val
    lw t2, 8(sp)         # val
    
    blt t1, t2, insert_right
    beq t1, t2, insert_equal
    
    ld a0, 8(t0)
    ld a1, 8(sp)
    call insert
    ld t0, 16(sp)
    sd a0, 8(t0)
    j insert_root

insert_right:
    ld a0, 16(t0)
    ld a1, 8(sp)
    call insert
    ld t0, 16(sp)
    sd a0, 16(t0)
    j insert_root

insert_equal:
    j insert_root

insert_root:
    ld a0, 16(sp)        

insert_done:
    ld ra, 24(sp)
    addi sp, sp, 32
    ret

get:
    addi sp, sp, -32
    sd ra, 24(sp)  
    sd a0, 16(sp)        # root
    sd a1, 8(sp)         # val
    
    ld t0, 16(sp)
    beqz t0, get_invalid
    
    lw t1, 0(t0)         # root->val
    lw t2, 8(sp)         # val
    
    beq t1, t2, get_found
    blt t1, t2, get_right
    
    # --- Left Path ---
    ld a0, 8(t0)
    ld a1, 8(sp)
    call get
    j get_done

get_right:
    ld a0, 16(t0)
    ld a1, 8(sp)
    call get
    j get_done

get_found:
    ld a0, 16(sp)
    j get_done

get_invalid:
    li a0, 0

get_done:
    ld ra, 24(sp)
    addi sp, sp, 32
    ret

getAtMost:
    li a2, -1
getAtMost_loop:
    beqz a1, getAtMost_done
    
    lw t0, 0(a1)         # t0 = root->val
    blt a0, t0, getAtMost_left
    
    mv a2, t0
    ld a1, 16(a1)
    j getAtMost_loop

getAtMost_left:
    ld a1, 8(a1)
    j getAtMost_loop

getAtMost_done:
    mv a0, a2
    ret