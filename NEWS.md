# MatchThem <img src="man/figure/logo.png" align="right" width="150" />

<!-- badges: start -->
#### Matching and Weighting Multiply Imputed Datasets
<!-- badges: end -->

[![](https://img.shields.io/badge/CRAN%20version-0.9.3-success.svg?color=informational&style=for-the-badge)](https://cran.r-project.org/package=MatchThem)
[![](https://img.shields.io/badge/github%20version-0.9.3-success.svg?color=informational&style=for-the-badge)](https://github.com/FarhadPishgar/MatchThem)

## What's New

### Version 1.0.0

* `mimira` and `mimipo` objects (the output of `with()` and `pool()`, respectively) now inherit from the `mice` classes `mira` and `mipo`. This means `mice` methods work with these objects, so their special methods have been removed from `MatchThem`, thinning out the package code. `mice` does not need to be attached (i.e., with `library()`) for its methods to be dispatched. 

* `coxph()` when used with `with()` now correctly uses the robust standard errors. 

* A `cluster` argument has been added to `with.mimids()` to control whether cluster-robust standard errors should be used to account for pair membership when the model is a `svyglm()`-type model from the `survey` package. The default is to include pair membership  when present and there are 20 or more unique subclasses (i.e., pairs). This works by supplying the pair membership variable (`subclass`) to the `ids` argument of `svydesign()`.

* `cbind()` methods have been exported and documented. 

* Printed messages can now be suppressed with `supressMessages()` or by setting the new `printFlag` option in `matchthem()` and `weightthem()`. 

* `MatchIt` and `WeightIt` have been moved from `Depends` to `Imports` since they do not need to be attached to use `MatchThem` functions. Several packages have been removed from `Imports`. `mice` has been added to Depends.

* `mimids` and `wimids` objects are now much smaller, now containing only the supplied `mids` object and the `matchit()` or `weightit()` outputs. This may make old code that directly interfaced with the `mimids` and `wimids` internals no longer operate correctly, but any code that relied on `with()`, `pool()`, and `complete()` should still operate as before.

* Added `trim.wimids()` to trim estimated weights. This relies on `WeightIt::trim()` and uses the same syntax. Unless `WeightIt` has been attached (i.e., using `library(WeightIt)`), `trim.wimids()` must be called using `WeightIt::trim(.)`.

### Version 0.9.3

This is an update to kill few bugs.

### Version 0.9.2

This is an update to change the definition of the `complete()` function to evade name clashes with the [`tidyr`](https://cran.r-project.org/package=tidyr) package.

### Version 0.9.1

This is an update to improve documentation and to fix minor bugs.

### Version 0.9.0

This is an update to improve documentation and to implement compatibility for robust estimation of standard errors (compatibility with the `svyglm()` and `svycoxph()`, from the [`survey`](https://cran.r-project.org/package=survey) package, to be used as expressions within the `with()` function) and for new matching and weighting methods (e.g. the `full`, `genetic`, and `cem` matching methods as well as `ebal` and `optweight` weighting methods). Moreover, `complete()` function is included in the package to replace the `matchthem.data()` and `weightthem.data()`.

### Version 0.8.2

This is a spit and polish update to improve documentation and to fix minor bugs.

### Version 0.8.1

This is the first release of the [`MatchThem`](https://cran.r-project.org/package=MatchThem) package both on the [Github](https://github.com/FarhadPishgar/MatchThem) and the [Comprehensive R Archive Network (CRAN)](https://cran.r-project.org/package=MatchThem).

## Authors
Farhad Pishgar

[![](https://img.shields.io/twitter/follow/FarhadPishgar.svg?color=informational&style=for-the-badge)](https://twitter.com/FarhadPishgar)

Noah Greifer

[![](https://img.shields.io/twitter/follow/Noah_Greifer.svg?color=informational&style=for-the-badge)](https://twitter.com/Noah_Greifer)

Clémence Leyrat

[![](https://img.shields.io/twitter/follow/LeyClem.svg?color=informational&style=for-the-badge)](https://twitter.com/LeyClem)

Elizabeth Stuart

[![](https://img.shields.io/twitter/follow/Lizstuartdc.svg?color=informational&style=for-the-badge)](https://twitter.com/LizStuartdc)
