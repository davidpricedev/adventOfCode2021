# day 17

## part 1

Solving the trajectory is the easy part. Figuring out which trajectories to try is the hard part.

We could examine the x and y velocities somewhat separately, so we have two smaller problems instead of one larger problem.

We could use the sum of 1 to n = (n * n+1)/2 formula to find the minimum possible x - where x velocity drops to zero as soon as it reaches the near edge of the target zone.
That doesn't work for the max x though - we could overshoot by quite a bit and still have a step land insize the zone.

What about y though. Technically we only need the y value, so if we calculate the values separately, maybe we ignore x altogether?
Y velocity degrades by 1 for every step, so x velocity is still relevant for determining the total number of steps.
The best way to get height though is to have lots of steps - the more steps, the more height and the more that height has time to get pulled by gravity.
The best way to get lots of steps is to have a minimum x velocity - which should be relatively easy to calculate.

If we examine only the y component and rewind from the end, it would be very similar to the initial x velocity.
Y velocity would start out largish, but lose 1 for every step until it reaches the peak at which point it would have a zero velocity.
If we use the same formula, as we did to find the best x, that should get us the answer for the y-max too.
And potentially more directly than calculating the actual trajectory.

Solving for x velocity in the sample:

```rubyish
# n is initial velocity - what we are going for
x_distance = 20
x_distance * 2 = n * (n + 1)
n = Math.sqrt(x_distance * 2).floor
```

and sure enough, the 6 that we get here matches the 6 from the sample answer

Solving for the y velocity in the sample:

```rubyish
* n is the final position, and picking max y will give us the maximum drop
n = -10
n * (n + 1) / 2 = y_distance
```

and sure enough, the 45 that we get here matces the 45 from the sample answer

So at least part 1 can be solved with metaphorical pen and paper.

---

In part 2 we need to find every initial velocity that lands in the zone.

Per previous analysis, keeping the x and y separate and then finding a way to combine them (with combinatorial stats?) is probably the best way to proceed.

We already know a few bounds:

- minimum x = 6
- maximum y = 9

The other bounds can be found by increasing the velocity to the point where we jump to the furthest point in the zone in a single step:

- maximum x = 30
- minimum y = -10

I could probably keep going and find some way of predicting which x and y velocities land in the zone, but at this point it might be more fun to just run the simulations.
