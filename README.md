Cakecake
========
By Jens Dahl Møllerhøj

What is Cakecake?
------------

A lightning fast game development engine. It is used to build tiny HTML5 canvas games in minutes. Cakecake is written entirely in coffeescript.

Cakecake is influenced by the rails philosophy in the way that it is oppinionated, emphasizes convention over configuration, is DRY, and supports agile development.

Its API resamples the way 'Game Maker' by Mark Overmars works.

### Idea and philosopy

In classic software, an iterative development process help catch bugs early by designing incrementally. In indie game development, an iterative process gives the developer the ultimate create freedom.

It is not only more fun to develop games iteratively. It produces games that are more original, and more fun.

Just like Bret Victor believes that artists should have an imediate connection with their work, I believe that artistist need as high a number of iterations as possible. (This is almost, but not completely the same thing)

### Why is it faster to build games with Cakecake?

Cakecake generates all nesseary files for loading resourceses such as sprites and entities from predefined folders. The entities step and draw methods are automatically called. box2d is used automatically used for collision checking.

### Is cakecake ready to use?

Cakecake is useable, but not very stable. The API is still under development.

### What needs to be done?

A documentation video for the use of the API

Requirements
------------

Coffeescript requires node.js

Install
------------

With homebrew:

$ brew update $ brew install node

Add /usr/local/lib/node to your NODE_PATH environment variable. See more at: http://c.kat.pe/post/how-to-install-coffeescript-on-mac-os-x

$ npm install -g coffee-script

$ git clone git@github.com:mollerhoj/cakecake.git
