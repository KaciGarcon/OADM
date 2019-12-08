clear all
clc

A = [
    2 -2 3
    2 -2 1
    ]

b = [12 -4]

H = [
     2 -2  0
    -2  2  0
     0  0  2
    ]

f = [2 -2 0]

X = quadprog(H,f,A,b,[],[],[0 0 0], [Inf Inf Inf])
