# Landscape: architecture diagramming

This app is primarily for my study of the Elm language.

Someday it will be useful as a diagram-annotation program.

Right now most of its features are around observing the event model,
repeatability, and structure.

## Run the app

Play with a running version [here](http://satellite-of-love.github.io/landscape/)

What it does (in Chrome, on my mac):

* hold T and click in the landscape to add a text input
* type in the text input and press Enter to finish
* or push Esc to close it
* hold up-arrow and click to zoom in
* hold down-arrow and click to zoom out
* to save data:
   * push "chunder" and "notice" toggles to filter those
   * copy the blue "save" messages
* to restore data:
   * refresh the page to erase it
   * hold N and click to bring up the news injector
   * copy the news in. (Do not enter any blank lines, it hates that)
   * press command-Enter. Left command, that is. (works on my box!!)
* hold M and click to see the application state as a message. (it comes as Chunder, so make sure those aren't filtered.)

Meanwhile, to run locally:

* clone this repository
* ./build
* open index.html

The image displayed describes the architecture of this app.
