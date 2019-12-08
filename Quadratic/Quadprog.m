clear all
clc

A = [
    1 2
    2 3
    ]

b = [8 2]

H = [
     -2 0
     0 -2
    ]

f = [2 0]

X = quadprog(H,f,A,b,[],[],[0 0], [Inf Inf])
