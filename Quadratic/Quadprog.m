clear all
clc

A = [
    2 3
    2 1
    ]

b = [6 4]

H = [
     2 0
     0 0
    ]

f = [2 -1]

X = quadprog(H,f,A,b,[],[],[0 0], [Inf Inf])
