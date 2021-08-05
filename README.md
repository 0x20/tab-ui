Installation
============

Clone this repo:

```
git clone --recursive git://github.com/0x20/tab-ui
```

Then, change into the resulting directory and use the Debian tools to build the package:

```
cd tab-ui
dpkg-buildpackage --no-sign
```

The last command will tell you what packages you're missing; if `dpkg-buildpackage` itself is missing, you'll find it in `dpkg-dev` (at least on Debian systems)

Configuration
=============

It works with any window manager, but at Hackerspace Gent, we use i3 with the following addition to the i3 config file:

```
for_window [class="tab"] fullscreen
exec /usr/bin/tab-ui
```

If you're using a *very* old computer that doesn't support OpenGL 2.0, instead use

```
for_window [class="tab"] fullscreen
exec env LIBGL_ALWAYS_SOFTWARE=1 /usr/bin/tab-ui
```

We recommend setting up auto-login using `nodm`, but you're on your own for configuring that.

Other notes
===========

If you're not using tab with a 1024x768 screen, you'll probably want to tweak
the dimensions. In main.qml, search for `StackLayout`, and adjust the width and
height there.

If [backtab](https://github.com/0x20/backtab) is running on another machine,
you'll need to tell tab-ui where to find it. This is easy to do; simply pass
the correct URL on the command line.

You may find further useful hints [on our wiki](https://wiki.hackerspace.gent/Spacebar).
