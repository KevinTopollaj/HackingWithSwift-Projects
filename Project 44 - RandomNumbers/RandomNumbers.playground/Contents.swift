import GameplayKit
import UIKit

/// Generating random numbers without GameplayKit

let int1 = Int.random(in: 1...10)
let double1 = Double.random(in: 1...12)
let float1 = Float.random(in: 1..<15)
let bool1 = Bool.random()


/// Old-fashioned randomness

print(arc4random())
print(arc4random())
// generating random numbers in a range:
print(arc4random_uniform(6))

// if we want to get a random number from 20 to 30 we have to write:
func RandomInt(min: Int, max: Int) -> Int {
  if max < min { return min }
  return Int(arc4random_uniform(UInt32((max - min) + 1))) + min
}
print(RandomInt(min: 20, max: 30))


/// Generating random numbers with GameplayKit: GKRandomSource

// produces a number between -2,147,483,648 and 2,147,483,647 – yes, that's a negative number, which means it's not a drop-in replacement for arc4random().
print(GKRandomSource.sharedRandom().nextInt())

// return a random number from 0 to 5 using the system's built-in random number generator.
print(GKRandomSource.sharedRandom().nextInt(upperBound: 6))


/// Choosing a random number source: GKARC4RandomSource and other GameplayKit options

// GKLinearCongruentialRandomSource: has high performance but the lowest randomness
// GKMersenneTwisterRandomSource: has high randomness but the lowest performance
// GKARC4RandomSource: has good performance and good randomness

// to generate a random number between 0 and 19 using an ARC4 random source that you can save to disk, you'd use this:
let arc4 = GKARC4RandomSource()
arc4.nextInt(upperBound: 20)

// If you really want the maximum possible randomness for your app or game, try the Mersenne Twister source instead:
let mersenne = GKMersenneTwisterRandomSource()
mersenne.nextInt(upperBound: 20)

// Apple recommends you force flush its ARC4 random number generator before using it for anything important, otherwise it will generate sequences that can be guessed to begin with.
arc4.dropValues(1024)


/// Shaping GameplayKit random numbers: GKRandomDistribution, GKShuffledDistribution and GKGaussianDistribution

// GKShuffledDistribution ensures that sequences repeat less frequently
// GKGaussianDistribution ensures that your results naturally form a bell curve where results near to the mean average occur more frequently.


// GameplayKit lets you shape the random sources in various interesting ways using random distributions.

// rolling a six-sided dice
let d6 = GKRandomDistribution.d6()
d6.nextInt()

// creating a random number in a range 10 to 20 inclusive
let distribution = GKRandomDistribution(lowestValue: 10, highestValue: 20)
print(distribution)

// the code below generates the numbers 1 to 6 in a random order:
let shuffled = GKShuffledDistribution.d6()
print(shuffled.nextInt())
print(shuffled.nextInt())
print(shuffled.nextInt())
print(shuffled.nextInt())
print(shuffled.nextInt())
print(shuffled.nextInt())

// shuffle not so random will get the middle numbers printed more (10,11,12)
let notThatRandom = GKGaussianDistribution.d20()
print(notThatRandom.nextInt())
print(notThatRandom.nextInt())
print(notThatRandom.nextInt())
print(notThatRandom.nextInt())
print(notThatRandom.nextInt())
print(notThatRandom.nextInt())
print(notThatRandom.nextInt())
print(notThatRandom.nextInt())
print(notThatRandom.nextInt())
print(notThatRandom.nextInt())
print(notThatRandom.nextInt())
print(notThatRandom.nextInt())


/// Shuffling an array with GameplayKit: arrayByShufflingObjects(in:)

// an extension that will shuffle an array in place
extension Array {
  mutating func shuffle() {
    for i in 0..<(count - 1) {
      let j = Int(arc4random_uniform(UInt32(count - i))) + i
      swapAt(i, j)
    }
  }
}

// will return a new shuffled array
let lotteryBalls = [Int](1...49)
let shuffledBalls = GKRandomSource.sharedRandom().arrayByShufflingObjects(in: lotteryBalls)
print(shuffledBalls[0])
print(shuffledBalls[1])
print(shuffledBalls[2])
print(shuffledBalls[3])
print(shuffledBalls[4])
print(shuffledBalls[5])

// Here's our lottery example rewritten using a fixed seed value of 1001:
let fixedLotteryBalls = [Int](1...49)
let fixedShuffledBalls = GKMersenneTwisterRandomSource(seed: 1001).arrayByShufflingObjects(in: fixedLotteryBalls)
print(fixedShuffledBalls[0])
print(fixedShuffledBalls[1])
print(fixedShuffledBalls[2])
print(fixedShuffledBalls[3])
print(fixedShuffledBalls[4])
print(fixedShuffledBalls[5])
