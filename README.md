Mixxx 1.12.0

# HOMEPAGE #
[Mixxx]


# ABOUT #
Mixxx is open source software for DJ'ing. You can perform
live beatmixes with MP3s, OGGs, and other formats. Mixxx
also supports a number of DJ MIDI controllers.
Mixxx works on Linux, Windows and MacOS X.

Mixxx is released under GPL v2. See LICENSE file in this
directory for a copy of the licence.

# NEWS #

Check the Mixxx blog to find out what's new in this version:
http://mixxxblog.blogspot.com

# UPGRADING #

We recommend deleting your old skins directory before
installing a new version of Mixxx. SCONS may not properly
overwrite your skins directory when you do a "scons install",
and it might cause Mixxx to crash on launch.
You can delete it by running:

   $ sudo rm -rf /usr/share/mixxx/skins
   $ sudo rm -rf /usr/local/share/mixxx/skins


# INSTALL #
Mixxx has the following dependencies:
- libid3tag
- libmad
- libchromaprint
- libogg
- libvorbis
- libvorbisfile
- libsndfile
- libflac
- libshout
- libhss1394
- taglib (New in 1.9!)
- PortAudio-v19
- portmidi
- QT 4.6+
- scons
- protocol-buffers
- libusb-1.0
- libmp4v2 (optional, m4a support)
- libfaad (optional, m4a support)
- vamp-plugin-sdk (optional, internal version included)

NOTE: If you want JACK support in Mixxx, make sure you
compile PortAudio-v19 with JACK support first.

Mixxx's build system is now SCONS as of Mixxx 1.6.0.
To compile Mixxx using SCONS, go into the "mixxx"
directory and run:

   $ scons

SCONS does both dependency checking and building, so it will
tell you if you're missing any of the dependencies listed above.
It's also possible to specify a prefix path and additional
build flags, for example:

   $ scons prefix=/usr

To install Mixxx after compilation, run:

   $ sudo scons prefix=/usr install

A full list of scons flags is available by running:

   $ scons --help

WARNING: We do not recommend building Mixxx with any
flags other than the defaults if you are going to use Mixxx
for live performance. Features that are disabled by default
may not compile or may be unstable. Be forewarned.

More detailed compiling instructions are available for your
platform on our wiki:
    http://www.mixxx.org/wiki/

# HERCULES DJ CONSOLE USERS ON LINUX #

Please see: http://www.mixxx.org/wiki/doku.php/hercules
You may need to install the official Hercules Linux drivers
from: http://www.hercules.com/

# REINSTALLING MIXXX #

Linux users may need to manually remove their Mixxx
installation directory if they need to reinstall. (This does
not apply when reinstalling from a DEB package.) Mixxx's
share directory can be removed by running:

   $ sudo rm -rf /usr/local/share/mixxx/

or

   $ sudo rm -rf /usr/share/mixxx/

# USAGE #
Please see the manual, included in this directory,
Mixxx-Manual.pdf or at:

    http://www.mixxx.org/manual

# CONTACT #
To contact the lead developer, send an email to
rryan@mixxx.org or subscribe to
mixxx-devel@lists.sourceforge.net and send a message to the
list.

# QT #
On some platforms, Mixxx may come with a pre-built copy of
Qt. This code is licensed under the LGPL and source for this
library may be obtained from:

    http://qt-project.org/downloads

# Microsoft Runtimes #
On Microsoft platforms, Mixxx may come with runtime dlls
copyright of Microsoft. These are distributed for the
purpose of allowing Mixxx to run only as per the license
agreement for Visual Studio 2005.

[Mixxx]: http://www.mixxx.org