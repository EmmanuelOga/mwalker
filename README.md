<p align="center">
![Moonwalker](http://github.com/EmmanuelOga/mwalker/doc/mwalker.png "Moonwalker")
</p>

# Moonwalker

**Moonwalker** walks your path tree looking for files matching a given
subsequence. A subsequence is the string you are looking for where any
number of letters has been removed.

E.G.: "hlo" is a subsequence of "hello".

In a second mode of operation **Moonwalker** can also filter lines from
standard input according to a subsequence. This can be helpful if you
don't have a tree of your files but a list of opened files, for example.

Please check [1][`mwalker(1)`] to find the modes of operation.

[1]: http://github.com/EmmanuelOga/mwalker/doc/mwalker.1.html

## EXAMPLES

Filter files from a project directory:

    $ cd ~/projects/myproject
    $ mwalker filter . -limit=20 -mode=f amodelsuser

Filter lines coming from the standard input:

    $ echo -e "line 1\nline2\nline3" | mwalker filter - -limit=1 2

Note the -mode flag has no effect when working with the standard input.

## BUILDING

**Moonwalker** is written in lua and ships with a custom C extension.
The main loader (bin/mwalker) is a bash script that should take care of
starting the program. To build the lua C module you'll need to change to
the root directory of **Moonwalker** and run `make`.

## Copying

Moonwalker is Copyright (C) 2011 [Emmanuel Oga](http://EmmanuelOga.com)<br/>
See the file LICENSE for information of licensing and distribution.
