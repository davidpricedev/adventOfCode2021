# Day 24 ALU

I decided to implement the ALU, but not try to solve the problem itself.
Implementing the ALU reminds me a little of the "intcode" computer from 2019.

Using the ALU to try to solve the problem would probably take years (9**14 attempts).
The only solution is to code-review the instructions and come up with an intuition about what the instructions are doing so we can reverse-engineer what will make the z value zero.
I took a quick look and there is a lot of redundancy in the code, but I can't be bothered to read through 255 lines of assembly.