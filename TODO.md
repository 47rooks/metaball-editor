# To Do

### Bugs

### Features
   * add button to each row to clear the equation
   * add error handling for xyTransform f(x)
   * expand piecewise equation restrictions to work directly with x,y so intermediate equation is not required
   * add PNG save
   * add demo pane to show how the metaballs look while moving
   * add color gradient support
   * do something about a progress bar
   * floats must have preceding 0 in formula evaluation - .9 fails where 0.8 is ok
   * refactor the removal of '=' from equations to the UI layer out of EquationSystem processing
   * refactor error and exception information so they are together
   * add shader/filter to threshold the metaballs
   * fix _saveRequired in EditorView so it properly indicates when save is required
   * add unit tests
   * add proper validation of whether there are domain variables, multiple falloff equations and XY transform and throw enforce properly any restrictions, throwing errors where needed. Currently there are cases where for example, with multiple falloff equations and no XY transform only one falloff equation is evaluated, and that without regard to it's valid domain. There is also an expectation that in the case of a XY transform being present that domains are specified for piecewise equations which is also not enforced or checked.
   * Fix corner markers around metaball when image is less than 16 x 16 pixels, which will result in a noughts and crossed grid being drawn