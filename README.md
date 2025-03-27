I got fed-up with my Python virtualenvs getting broken
every. single. time. the Python runtime gets updated by Fedora.  (And
I'm sure this isn't just an RPM-based distro problem; I imagine
DPKG-based distros have a similar issue.)

So I dropped virtualenvs like a bad habit, and instead I went full-on
old-school, and decided to do the configure / make / make-install
dance (like back in the Bad Old Days before Linux distros, when we all
had to build our own software packages).

But now we parameterize and automate these things, and they don't take
nearly as long to build as they once did.  Sure, it takes-up lots of
space, but it's a small price to pay for stability, and disk is cheap.
