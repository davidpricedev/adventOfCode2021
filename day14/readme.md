# Notes

Using the naive algorithm that I started with in part1 is too slow for part2.
Using buckets like we did in the earlier, squid aging seems like it might work here too.
However, we'll end up double-counting everything except the first and last element (the first "N" and last "B" of the sample input).
The numbers here are well beyond int32, but ruby apparently automatically handles integers larger than int32 just fine