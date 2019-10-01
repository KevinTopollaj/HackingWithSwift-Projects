# Random Numbers

#### Random Numbers is a technique project where I learned more about GameplayKit randomization. GameplayKit implementation of randomization goes a step further and for this Apple thought specifically about random needs for games, and has built a randomization system that is going to be used even when you're not making games.


## Main Points:

* GameplayKit
* GKRandomSource
* GKLinearCongruentialRandomSource: has high performance but the lowest randomness
* GKMersenneTwisterRandomSource: has high randomness but the lowest performance
* GKARC4RandomSource: has good performance and good randomness
* GKShuffledDistribution: ensures that sequences repeat less frequently
* GKGaussianDistribution ensures that your results naturally form a bell curve where results near to the mean average occur more frequently.
* Shuffling an array with GameplayKit: arrayByShufflingObjects(in:)
