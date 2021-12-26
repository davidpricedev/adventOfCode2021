# Amphipod

## Part 1

I solved part1 by hand fairly easily:

My input:

```bash
#############
#...........#
###D#D#B#A###
  #C#A#B#C#
  #########
```

At bare minimum, the moves needed to get each to their correct place is:

- 15 moves for D
- 13 moves for C
- 10 moves for B
- 14 moves for A

So 16414 is the lower bound of what it could be

16508 is the answer I came up with:

Move the Bs and the A out of the way (where to put the Bs is the most challenging part):

`9 * 1 + 11 * 10 = 119`

```bash
#############
#AB.B.......#
###D#D#.#.###
  #C#A#.#C#
  #########
```

Move the free C and D to their home locations:

`6 * 100 + 7 * 1000 = 7600`

```bash
#############
#AB.B.......#
###D#.#.#.###
  #C#A#C#D#
  #########
```

Move the second A out of the way and the Bs to their home locations:

`7 * 1 + 7 * 10 = 77`

```bash
#############
#A........A.#
###D#B#.#.###
  #C#B#C#D#
  #########
```

Finish up:

`8 * 1000 + 7 * 100 + 12 * 1 = 8712`

## Part 2

I was also able to solve part2 by hand.

```bash
#############
#...........#
###D#D#B#A###
  #D#C#B#A#
  #D#B#A#C#
  #C#A#B#C#
  #########
```

Move As and Cs out of the way and Ds to their home location:

`18 * 1 + 10 * 100 + 39 * 1000 = 40018`

```bash
#############
#AA.......CC#
###.#.#B#D###
  #.#C#B#D#
  #.#B#A#D#
  #C#A#B#D#
  #########
```

Move the C out of the way, the first 3 As to their home location, and first two Bs out of the C room:

`9 * 100 + 10 * 1 + 14 * 10 + 9 * 1 = 1059`

```bash
#############
#BB.....C.CC#
###.#.#.#D###
  #A#C#.#D#
  #A#B#.#D#
  #A#A#B#D#
  #########
```

Move the last B out of the C room and all the Cs to their home location:

`7 * 10 + 22 * 100 = 2270`

```bash
#############
#BB.B.......#
###.#.#C#D###
  #A#.#C#D#
  #A#B#C#D#
  #A#A#C#D#
  #########
```

Move the last A out of the B room and the Bs out of the hallway:

`6 * 10 + 5 * 1 + 17 * 10 = 235`

```bash
#############
#.....A.B...#
###.#.#C#D###
  #A#B#C#D#
  #A#B#C#D#
  #A#B#C#D#
  #########
```

Finish up:

`4 * 1 + 4 * 10 = 44`
