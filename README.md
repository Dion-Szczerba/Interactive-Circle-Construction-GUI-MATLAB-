# Interactive Circle Construction GUI (MATLAB)

An interactive MATLAB application for classical geometric constructions with circles — built from scratch with no toolboxes. Click points on a canvas and the program constructs tangential circles, perpendicular bisectors, a circumscribed circle through snapped points, circle–circle intersections, and applies affine transformations in homogeneous coordinates.

<!-- TODO: add a screenshot or a short GIF of the GUI in action here.
     Run gui.m, draw a full construction, and capture the window.
     A GIF (e.g. via ScreenToGif or LICEcap) is worth 100 words to a recruiter. -->
<!-- ![Demo](docs/demo.gif) -->

## Features

- **Point-and-click input** — all geometry is entered with the mouse directly on the axes
- **Circle from centre + circumference point** — radius derived via Euclidean distance, drawn with parametric equations
- **Tangential circle construction** — computes the radius of a second circle that touches the first, with validity checking for overlapping centres
- **Circumscribed third circle** — snaps user clicks to the *closest point on the closest circle*, snaps a third point onto the perpendicular bisector of the two centres, then solves for the unique circle through all three points via intersecting perpendicular bisectors
- **Circle–circle intersections** — analytic solution handling the 0-, 1- and 2-intersection cases
- **Geometric transformations** — translation and rotation matrices in homogeneous coordinates, composed into a single transform that re-maps every element on the canvas
- **Save / load** — serialise the full construction (points and circles) to a plain-text file and replay it later
- **Show/hide toggles** for construction elements

## The maths under the hood

| Function | What it solves |
|---|---|
| `circleSolve.m` | Centre and radius of the circle through 3 points, via the intersection of two perpendicular bisectors |
| `centreBisector.m` | Perpendicular bisector `y = mx + c` of the segment joining two circle centres |
| `closestPointBisector.m` | Orthogonal projection of a point onto a line (snap-to-line) |
| `closestPointsOnCircle.m` | Nearest circle to a point and the nearest point on its circumference (snap-to-circle), via normalised direction vectors |
| `intersections2circles.m` | Intersection points of two circles using the radical-line construction |
| `radiusTangentialCircle.m` | Radius of a circle tangent to an existing one, given its centre |
| `transformationMatrices.m` | 3×3 homogeneous translation + rotation matrices and their composition |

## Running it

Requires MATLAB (R2020a or later; no toolboxes needed).

```matlab
cd src
gui
```

1. Click **Draw Circle**, then click a centre and a circumference point.
2. Click **Draw Tangential Circle** and choose a centre for the second circle.
3. Click **Draw third circle** and click two points — each snaps to the nearest circle (they must snap to *different* circles).
4. Click **Draw Bisector** and click a point — it snaps onto the perpendicular bisector, completing three points; the circumscribed circle is drawn and its intersections with circles 1 and 2 are marked.
5. **Apply Transformation** translates the third circle's centre to the origin and rotates the construction so the centre line of circles 1 and 2 aligns with the x-axis.
6. **Save Data** / **Load Data** round-trip the construction to a text file (see `examples/sample-data.txt`).

## Repository layout

```
src/        MATLAB source (GUI + geometry functions)
examples/   Sample saved construction for the Load Data feature
```

## Author

Dion Szczerba — [LinkedIn](#) · [GitHub](#)
