
winkbd
======

This project ist a backup of my personal keyboard setup for Windows.

Keyboard Layout
---------------

The keyboard layout is based on the Apple US International keyboard layout, which
is exactly like the usual US layout until alt gr is used. Many keys using alt gr are
mapped to dead keys, making it possible to enter accents for many letters. Examples:

* alt+s: ß
* alt+e: grave accent (typing before aeiou it becomes áéíóú)
* alt+u: umlaut (aeou → äëöü)
* alt+j: double grave accent (ou → őű)

Scancode Map
------------

The registry files in the scancode map folder are used to disable the caps lock and
windows keys. The left alt works like the right alt (ie. alt gr), and the normal alt
key is mapped onto the windows keys.

AutoHotkey
----------

There is an AutoHotkey script that makes writing Vim-like digraphs in other windows.
Original version was based on the one from
[Ingo Karkat](http://ingo-karkat.de/downloads/tools/AutoHotkey/index.html).
All digraphs from Vim are supported.

