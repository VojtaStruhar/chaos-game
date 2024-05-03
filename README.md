## TODO

- Configuration
  - [x] Ratio
  - Point colors maybe?
  - RULES
    - Probably just a bunch of checkboxes. I can't imagine leaving it up to the user with expressions or something.
    - Don't pick tha same point a again; Skip at least one; Don't pick the point 1 clockwise (order of points starts to matter?!)
      - Pre-calculate the options for each point beforehand *if possible*. You don't want to be evaluating the rules 100k times.
- Presets
  - [x] the usual interesting stuff. Regular polygons with interesting ratios.
- Snap points to a grid. Maybe just a square grid at first. Show guidance lines.
- Edit currently placed points
  - [x] Add (default click)
  - Remove (Right click?)
  - [x] Move (drag)
  - Detect input events directly in the mouse  detector. Input actions are not suitable for this I think.
  - Not sure if I can re-render for every change (smooth). Maybe with a small number of iterations? Just for a preview


## Resources

- https://en.wikipedia.org/wiki/Chaos_game
