# day 19

This one smells like linear algebra...

The first attempt algorithm would look like:

- start with scanner zero - assume its coordinate system is "correct"
- for each beacon, determine if that beacon can be used as an overlap reference for each other scanner
- if so, store the translation and rotation requirements for the target scanner and add more beacons into a known-locations list (i.e. relative to scanner zero)
- continue until we have rotation and translation notes for every scanner


Algorithm for determining overlap reference

- we start with a reference beacon position
- for every beacon within the target scanner's vision we'll translate it to the reference beacon location
- then check to see if other beacons in the target scanner with the same translation map up with other known beacon locations
- if not, then we should try all 21? possible rotations to see if any of them result in success

---

Since this is effectively linear algebra, we could use matrix multiplication to do the rotations and translations.
I don't know any linear algebra tricks for automagically lining up coordinate systems. Perhaps there is one that makes this relatively easy?
This might be easier to work with a library that already knows how to do linear algebra, perhaps pandas would?