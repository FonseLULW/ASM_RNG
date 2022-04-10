.model small
.stack 100h

.data                                   ;data segment (global variables)
    outputMsg db "Random Number between (0-9): $"
    randomNum db 0
.code                                   ;code segment
main proc                               ;start of the main procedure declaration

    mov ax, @data                       ;@data locates the addresses of the
                                        ;global variables in .data
    mov ds, ax                          ;this is basically declaring where the
                                        ;program should access the global variables

    mov ah, 09h                         ;09 is in hex, this is the DOS command code
                                        ;for writing a string to stdout
    mov dx,offset outputMsg             ;offset gets the address of outputMsg and
                                        ;puts it in dx (like pointers in C) 
    int 21h                             ;passes control to DOS, the DOS will write
                                        ;the string in dx to the console

    call generateRandomNumber           ;calls a procedure named generateRandomNumber

    mov ah,02h                          ;02 is in hex, this is the DOS command code
                                        ;for writing a character to stdout
    mov dl,randomNum                    ;this moves the number stored in randomNum into dl
    add dl, '0'                         ;adds the ASCII value of '0'=30 to randomNum
                                        ;(this converts the random number to ASCII) 
    int 21h                             ;passes control to DOS, the DOS will write
                                        ;the character in dl to the console

    mov ah, 4ch                         ;4c is in hex, this is the DOS command
                                        ;code for exiting the program
    mov al, 0                           ;exit code meaning ended without errors
    int 21h                             ;passes control to DOS, the DOS will exit the program

main endp                               ;end of the main procedure declaration

generateRandomNumber proc               ;start of the generateRandomNumber procedure declaration

    mov ah, 0h                          ;0h is in hex, this is the system clock command code for
                                        ;getting the number of clock ticks since midnight
    int 1ah                             ;passes control to system clock, which will put the number
                                        ;of ticks into dx (low) and cx (high)

    mov ax, dx                          ;we can just use dx, we need to put it in
                                        ;ax for division
    mov dx,0                            ;in division the dividend is split into
                                        ;two registers, ax:dx. we must reset 0
    mov bx,10                           ;move 10 to bx, this will make sure that
                                        ;the remainder is between 0-9
    div bx                              ;value in ax divided by the operand (bx)
                                        ;will store the quotient in ax and remainder in dx

    mov randomNum, dl                   ;we put dl into our global variable randomNum,
                                        ;dl is just a part of dx (the remainder between 0-9)
    ret                                 ;we return to the caller of this procedure

generateRandomNumber endp               ;end of the generateRandomNumber procedure declaration

end main                                ;this signifies the end of the program