# Notes

This is a weighted optimal route problem which is one of those believed to be NP-Hard or NP-Complete, I believe.
There are a few things that make it more tractable perhaps:

- costs of each node are only 1 to 9 - which makes it fairly unlikely that we will ever go up or left.
- size is somewhat constrained (only 100x100)

There are other optimmizations we could take to keep things under control.
For instance, we could run a first approximation by summing the first row and last column and throwing away any route that exceeds that cost.
That would keep the number of routes manaageable as we should be throwing away routes pretty quickly roughly at the point where the number of routes would otherwise start to get too large to handle.

---

I recall attending a session at a conference a few years ago that talked about "Dynamic Programming" as a way to side-step NP-challenging algorithms.
Routing was one of the topics that Dynamic Programming was good for.
I think the only challenge is that it comes up with a "good" answer, but maybe not the "best" answer.

(for the sample input)
The dynamic programming algorithm would start at the end and work backwards.
We start at the end of the sample `table[10][10]` and give it a value of 1
Next we look at (10,9) and (9,10) and give them a value of 2 and 9 respectively (their own value plus the value of (10,10))
We keep going like that through the table.
When we get to a point like (9,9) where there are two paths that we could take ((10,9) and (9,10)), we'll pick the lower-cost option.
At the end of the algorithm, we should have traversed the table once, and the value at (0,0) should be the answer