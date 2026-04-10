.data
filename:   .string "input.txt"
r_string: .string "r"
yes_string: .string "Yes\n"
no_string: .string "No\n"
.text
.global main
main:
addi sp,sp,-48
sd ra,40(sp)
sd s0,32(sp)  #filepointer
sd s1,24(sp)  #leftindex
sd s2,16(sp)  #rightindex
sd s3,8(sp)
sd s4,0(sp)


la a0,filename
la a1,r_string
call fopen
mv s0,a0  #storing file pointer in s0

#calling Fseek
mv a0,s0
li a1,0
li a2,2
call fseek

mv a0,s0
call ftell
li s1,0
mv s2,a0
addi s2,s2,-1

palindrome:
bge s1,s2,isplaindrome
mv a0,s0
mv a1,s1
li a2,0
call fseek
mv a0,s0
call fgetc
mv s3,a0
mv a0,s0
mv a1,s2
li a2,0
call fseek
mv a0,s0
call fgetc
mv s4,a0
bne s3,s4,notpalindrome
addi s1,s1,1
addi s2,s2,-1
j palindrome

isplaindrome:
la a0,yes_string
j exit

notpalindrome:
la a0,no_string
j exit

exit:
call printf
mv a0,s0
call fclose
ld ra,40(sp)
ld s0,32(sp)
ld s1,24(sp)
ld s2,16(sp)
ld s3,8(sp)
ld s4,0(sp)
addi sp,sp,48
ret
