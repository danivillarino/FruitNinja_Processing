# Fruit Ninja for Processing

A motion-controlled Fruit Ninja-style game made with [Processing](https://processing.org/) and a Kinect sensor. Move your right hand through the play area to control the on-screen blade and slice fruit before it falls off the screen.

## Features

- Fullscreen presentation designed for Kinect play.
- Hand-tracked blade with a visible motion trail.
- Six fruit types: apple, mango, watermelon, pear, orange, and pineapple.
- Sliced fruit separates into animated left and right halves.
- Colored particle effects appear after each successful slice.
- Score and missed-fruit counters are displayed during play.
- Start and restart actions use a hands-free hover timer.
- Game over occurs after 15 missed fruits.

## Requirements

- Windows computer.
- Processing with Java mode enabled.
- A compatible Microsoft Kinect sensor and its drivers/runtime.
- The Processing `kinect4WinSDK` library installed and available to the sketch.
- A display large enough for fullscreen play.

The sketch imports the following Kinect classes:

```java
import kinect4WinSDK.Kinect;
import kinect4WinSDK.SkeletonData;
```

Because the project uses `kinect4WinSDK`, it is intended for Windows and requires a Kinect-compatible setup. The repository does not pin a Processing or library version, so use the version supported by your Kinect hardware and installed `kinect4WinSDK` package.

## Installation

1. Install Processing and open it in Java mode.
2. Install the `kinect4WinSDK` library through Processing's Contribution Manager, or place the library in Processing's libraries directory.
3. Connect and enable the Kinect sensor before starting the sketch.
4. Open `FruitNinja.pde` from the `FruitNinja_Processing` folder.
5. Confirm that the `data` folder remains beside the `.pde` files. It contains all images required by the game.
6. Run the sketch. It opens in fullscreen mode.

## How to Play

### Start a round

On the menu screen, place your right hand over the `START` button and hold it there for approximately 2 seconds. The game begins when the start timer completes.

### Slice fruit

Move your right hand quickly across a fruit. A slice is registered when:

- The hand moves at least 10 pixels between frames.
- The hand is within 100 pixels of the fruit.

Each successful slice removes the whole fruit, displays its two halves, and creates a burst of particles.

### Game over and restart

Fruit that falls below the bottom of the screen counts as missed. After 15 misses, the game-over screen appears. Hover your right hand over `RESTART` for approximately 3 seconds to begin a new round.

## Scoring

| Fruit | Points |
| --- | ---: |
| Apple | 1 |
| Mango | 1 |
| Watermelon | 2 |
| Pear | 1 |
| Orange | 1 |
| Pineapple | 1 |

The score and missed-fruit count reset whenever a new round starts.

## Gameplay Details

- One or two fruits spawn at a time.
- New fruits spawn approximately every 0.6 to 1.2 seconds.
- Fruits launch from the lower portion of the screen with random horizontal movement.
- Fruit motion uses upward velocity, gravity, and a bounce at roughly 25% of the screen height.
- The game tracks the first detected skeleton and uses its right hand.
- Hand movement is smoothed with interpolation to reduce jitter.
- The blade trail stores the latest 15 hand positions.

## Project Structure

```text
FruitNinja_Processing/
|-- FruitNinja.pde       Main sketch, screens, Kinect events, and game loop
|-- Fruit.pde             Whole-fruit movement, selection, drawing, and colors
|-- HalfFruit.pde         Movement and rendering for sliced fruit halves
|-- Particle.pde          Slice particle behavior and fading effects
|-- README.md             Project documentation
|-- sketch.properties     Processing entry point configuration
`-- data/                 Backgrounds, interface images, and fruit artwork
```

`sketch.properties` sets `FruitNinja.pde` as the main sketch file.

## Included Assets

### Interface and backgrounds

- `logo.png`
- `start.png`
- `restart.png`
- `gameover.png`
- `fondomenu.jpg`
- `fondojuego.jpg`

### Fruit artwork

Each fruit has one complete image and two sliced-half images:

- `manzana.png`, `manzana_left.png`, `manzana_right.png` - apple
- `mango.png`, `mango_left.png`, `mango_right.png` - mango
- `sandia.png`, `sandia_left.png`, `sandia_right.png` - watermelon
- `pera.png`, `pera_left.png`, `pera_right.png` - pear
- `naranja.png`, `naranja_left.png`, `naranja_right.png` - orange
- `pina.png`, `pina_left.png`, `pina_right.png` - pineapple

The filenames are Spanish, but they are loaded directly by `FruitNinja.pde`; keep them unchanged unless the loading code is updated too.

## Troubleshooting

### The sketch does not start

Verify that Processing is running in Java mode, the `kinect4WinSDK` library is installed, and the Kinect is connected before launching the sketch.

### The hand does not appear to move

Check that the sensor can see the player and that the right hand is being tracked. Stand far enough away for the full upper body to be visible, and ensure no other person is closer to the sensor.

### Images are missing

Run the sketch from the project folder and ensure the `data` directory is in the same folder as `FruitNinja.pde`. Asset names are case-sensitive in the code.

## License

No license is currently specified for this project.