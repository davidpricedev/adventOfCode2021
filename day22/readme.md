# Day 22 Reactor Reboot

I can think of two different ways to approach part1.
We could do exactly as implied - build a representation in memory of the space in question and go through toggling things off/on and then count the result.
The alternative would be to consider each step as a filter of sorts and do something similar to ray-tracing to determine the end state of each "pixel".
This would eliminate the need to store everything in memory.
This second option is interesting, and I think I'll use it - even if it might be slightly harder to debug

Notes:

- Everything starts in the "off" state
- May as well use zero/one for off/on so sums can be done easier

Maybe there is a 3rd algorithm - instead of examing each step independently, maybe I could merge all the steps all at once.
This would end up being something like the original algorithm, but instead of storing all the initial "off"s, I would keep in sparse.
The representation of state would end up being a list of boxes of various sizes that represent on states.
When a box overlaps with a step, I'd have to cut one of the two cubes into 3-6 parts and re-calculate collisions
Figuring out how to cut up those cubes and handling all the edge cases, would be a challenge though.
I believe this would be the most performant algorithm - it wouldn't care much about the size of space - just the number of steps and the resulting segmented cubes of space that are on.

As I see part 2, clearly we need an algorithm such as this 3rd one where we don't try to keep track of every voxel in space.