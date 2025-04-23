/* Evilson Vieira<evilson11@gmail.com>
/* gcc bib.s app.c -o app */

.globl set
.type  set, @function
set:btsw %si, (%rdi)
    ret

.globl tst
.type  tst, @function
tst:btw %si, (%rdi)
    jc ts1
    mov $0, %rax
    jmp ts0
ts1:mov $1, %rax
ts0:ret

.globl dta
.type  dta, @function
dta:mov %esi,  (%rdi) # I
    mov %edx, 4(%rdi) # J
    mov %edx, 6(%rdi)
    decw  6(%rdi)     # Jf
    mov %edx, %ecx
    add $7, %edx
    shr $3, %edx
    movw %dx, 8(%rdi) # J8
    shl $3, %dx
    dec %dx
    and $63, %dl
    movb %dl, 10(%rdi) # 8*J8-1 mod64
    and $63, %cl
    movb %cl, 11(%rdi) # J mod64
dtf:ret

fim:or  %r14,%r15
    not %r15
    and %r13,%r15
    or  %r15,%rax   #4
    mov %r14,%r15
    xor %r13,%r15
    and %r15,%rax   #0
    not %r13
    and %r13,%r14
    xor %r14,%rax   #2,3
    ret

wrk:mov $0, %rcx
    movb 11(%r11), %cl
    btr %rcx, %rax
    mov %r10, %rcx
    and $7, %rcx
 wd:or $0, %cl
    jz we
    movb %al,(%rdi)
    inc %rdi
    inc %rsi
    shr $8, %rax
    dec %cl
    jmp wd
 we:ret

su1:mov %r14,%r12 # %r12 temp
    xor %rax,%r14
    and %r12,%rax
    xor %rax,%r13
    ret

su0:mov %r15,%r12 # %r12 temp
    xor %rax,%r15
    and %r12,%rax
    call su1
    ret

prp:mov (%rbx), %rax # %r12 temp
    mov %rax, %r14
    mov %rax, %r15
    cmp $64, %rcx
    jne lx0
    shl $1, %r14
    jmp l00
lx0:mov -8(%rbx), %r12
    shld $1, %r12, %r14
l00:cmp %r9,%rcx
    jl ly0
    shr $1, %r15
    mov $0, %r12
    movb 10(%r11), %r12b
    btr %r12, %r15
    jmp lyJ
ly0:mov 8(%rbx), %r12b
    shrd $1, %r12, %r15
lyJ:ret

sum:call prp # %r12 temp
    mov %r15,%r12
    xor %r14,%r15
    and %r12,%r14
    ret

prc:push %r14
    push %r15
    call sum
    pop %rax # %r15
    call su0
    pop %rax # %r14
    call su1
    mov (%rbx), %rax
    ret

lin:mov $0,%rcx
 li:add $64,%rcx
    mov $0,%r13
    mov $0,%r14
    mov $0,%r15
    cmp $1,%rdx
    je li2
li0:mov %rsi, %rbx
    sub %r10, %rbx   # linha de cima
    call sum
    call su0
    cmp %r8,%rdx
    je li1
li2:mov %rsi, %rbx
    add %r10, %rbx  # linha de baixo
    call prc
    call su0
li1:mov %rsi, %rbx  # linha do meio
    call prc
    call fim
    cmp %r9,%rcx
    jl reb
    je ult
    call wrk
    jmp endl
ult:mov %rax,(%rdi)
    add $8, %rsi
    add $8, %rdi
    jmp endl
reb:mov %rax,(%rdi)
    add $8, %rsi
    add $8, %rdi
    jmp li
endl:ret

.globl new
.type  new, @function
new:mov $0, %r8
    mov $0, %r9
    mov $0, %r10
    mov %rdx, %r11
    movw 0(%rdx), %r8w  # I
    movw 4(%rdx), %r9w  # J
    movw 8(%rdx), %r10w # J8
    push %rdi # para limpar o start no final
    mov $0, %rdx
 ln:inc %rdx
    call lin
    cmp %r8,%rdx
    je end
    jmp ln
end:movw 6(%r11), %cx
    sub %r10, %rdi
    btrw %cx, (%rdi)
    pop %rdi
    btrw $0, (%rdi)
    ret

rot:mov $0,%rcx
 ro:add $64,%rcx
    mov $0,%r14
    mov $0,%r15
ro1:mov %rsi, %rbx  # linha do meio
    call prp
    mov %r15, %rax
    or %r14, %rax
    cmp $1,%rdx
    je ro2
ro0:mov %rsi, %rbx
    sub %r10, %rbx    # linha de cima
    or (%rbx),%rax
    cmp %r8,%rdx
    je rof
ro2:mov %rsi, %rbx
    add %r10, %rbx   # linha de baixo
    or (%rbx), %rax
rof:mov 8(%rsp), %rbx # Maze
    mov (%rbx), %r15
    not %r15
    and %r15, %rax
    cmp %r9, %rcx
    jl rob
    je rlt
    call wrk
    mov %r10b, %r12b
    and $7, %r12
    addq %r12, 8(%rsp)
    jmp rnd
rlt:mov %rax, (%rdi)
    add $8, %rdi
    add $8, %rsi
    addq $8, 8(%rsp)
    jmp rnd
rob:mov %rax, (%rdi)
    add $8, %rdi
    add $8, %rsi
    addq $8, 8(%rsp)
    jmp ro
rnd:ret

.globl trk
.type  trk, @function
trk:mov $0, %r8
    mov $0, %r9
    mov $0, %r10
    mov %rdx, %r11
    movw 0(%rdx), %r8w  # I
    movw 4(%rdx), %r9w  # J
    movw 8(%rdx), %r10w # J8
    push %rcx
    mov $0, %rdx
 tr:inc %rdx
    call rot
    cmp %r8,%rdx
    je tre
    jmp tr
tre:pop %rcx
    sub %r10, %rdi
    movw 6(%r11), %r12w
    btw %r12w, (%rdi)
    jc tk1  # finaliza
    mov $0, %rax
    ret
tk1:mov $1, %rax
    ret
# -------------------------

rop:mov $0,%rcx
op1:add $64,%rcx
    mov $0,%r14
    mov $0,%r15
op2:mov %rsi, %rbx  # linha do meio
    call prp
    mov %r15, %rax
    or %r14, %rax
    cmp $1,%rdx
    je op4
op3:mov %rsi, %rbx
    sub %r10, %rbx    # linha de cima
    or (%rbx),%rax
    cmp %r8,%rdx
    je op5
op4:mov %rsi, %rbx
    add %r10, %rbx   # linha de baixo
    or (%rbx), %rax
op5:andq (%rdi), %rax
    cmp %r9, %rcx
    jl op6
    je op7
    call wrk
    jmp ope
op7:movq %rax, (%rdi)
    add $8, %rdi
    add $8, %rsi
    jmp ope
op6:movq %rax, (%rdi)
    add $8, %rdi
    add $8, %rsi
    jmp op1
ope:ret

.globl trp
.type  trp, @function
trp:mov $0, %r8
    mov $0, %r9
    mov $0, %r10
    mov %rdx, %r11
    movw 0(%rdx), %r8w  # I
    movw 4(%rdx), %r9w  # J
    movw 8(%rdx), %r10w # J8
    mov $0, %rdx
rp1:inc %rdx
    call rop
    cmp %r8,%rdx
    je rpe
    jmp rp1
rpe:ret
