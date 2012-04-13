            :::   :::       ::: ::::::::::: ::::::::  :::    :::
          :+:+: :+:+:    :+: :+:   :+:    :+:    :+: :+:    :+:
        +:+ +:+:+ +:+  +:+   +:+  +:+    +:+        +:+    +:+
       +#+  +:+  +#+ +#++:++#++: +#+    +#+        +#++:++#++
      +#+       +#+ +#+     +#+ +#+    +#+        +#+    +#+
     #+#       #+# #+#     #+# #+#    #+#    #+# #+#    #+#
    ###       ### ###     ### ###     ########  ###    ###

          ::::::::::   :::      :::::::: ::::::::::: ::::::::  :::::::::  :::   :::
         :+:        :+: :+:   :+:    :+:    :+:    :+:    :+: :+:    :+: :+:   :+:
        +:+       +:+   +:+  +:+           +:+    +:+    +:+ +:+    +:+  +:+ +:+
       :#::+::# +#++:++#++: +#+           +#+    +#+    +:+ +#++:++#:    +#++:
      +#+      +#+     +#+ +#+           +#+    +#+    +#+ +#+    +#+    +#+
     #+#      #+#     #+# #+#    #+#    #+#    #+#    #+# #+#    #+#    #+#
    ###      ###     ###  ########     ###     ########  ###    ###    ###

    # Method Missing for Bash!

## What is MatchFactory?

**MatchFactory handles unrecognized shell input, allowing you to teach an old shell
new tricks!**

## What does it do?

If your bash command would result in a 'command not found' response, MatchFactory
tries hard to pair your input with any of its stored Matches. If a Match is found,
MatchFactory yields a replacement command to Bash for execution instead.

If multiple Matches are found, MatchFactory will prompt you to select one.

## What tricks can it do?

Just about anything, really. MatchFactory currently knows how to:

* change directories in your shell
* run a rake task by name
* open an arbitrary URL in your favorite browser
* clone a git repository
* download and unzip a tar(gz) file
* run cucumber features by name
* install a Ruby Gem

MatchFactory is designed to be extensible. It is easy to add Matches to handle new
input. It's Ruby, so you have its power and expressive syntax at your disposal.

## How does it work

Bash provides a mechanism to execute a shell function immediately prior to executing
a shell command. This is done by trapping the DEBUG signal. This shell function tests
the command about to be executed, and if it would result in a 'command not found'
error, it invokes the MatchFactory.rb file. If MatchFactory returns any text, this is
evaluated by Bash instead of executing the original command.

## How do I use it?

### Install:
I keep my configuration files in a ~/conf directory. Extract MatchFactory to your ~/conf
directory and source the method-missing.sh file in your .bashrc. Adjust pathing according
to your tastes and setup.

### Usage:
copy/pasting bare URLs to the command line should now just work. Additionally,
specifying a full or relative path ending in '/' will 'cd' you to that directory.

MatchFactory is Rake-aware. Assuming the output of rake -T:

    > rake -T
      rake about              # List versions of all Rails frameworks and the environment
      rake test               # Runs test:units, test:functionals, test:integration

Then you can just say 'about' or 'test', and rake will be invoked accordingly.

See the file matchheads.rb for more examples.

### Caveats:
* This is known to work on osx, with Ruby 1.9. YMMV.
* Don't even think about installing something like this on a production system.
* Use of the DEBUG trap in this fashion may jack up debuggers like 'gdb'.

## Design Notes and Credits
I first encountered this awesome and crazy idea through Geoffrey Grosenbach's
[Peepcode Blog](http://peepcode.com/blog/2009/shell-method-missing).

I was motivated to restructure his setup for the following reasons:

1. I didn't like seeing 'command not found' errors after successful method-missing()
calls.
2. I wanted to easily affect the state of the parent shell (cd'ing, for example),
without resorting to [black
magic](http://fvue.nl/wiki/Bash:_Passing_variables_by_reference#Appendix_A:_upvar.sh).
3. The case logic seemed hard to maintain and ordering of the regex matches becomes
important. What if I want multiple options to match?

In order to meet my goals, I needed to have Bash eval() the output from MatchFactory.
This makes for a slightly more complex method-missing function, but I feel the
tradeoff is worth it.

Getting Bash to skip execution of the original command requires a hack involving
setting the shell option 'extdebug', and returning a value >1. Per the BASH
documentation, this simulates a RETURN trap.

## License
(The MIT License)

Copyright © 2012 Erich Smith

Permission is hereby granted, free of charge, to any person obtaining a copy of this
software and associated documentation files (the "Software"), to deal in the Software
without restriction, including without limitation the rights to use, copy, modify,
merge, publish, distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to the following
conditions:

The above copyright notice and this permission notice shall be included in all copies
or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED,
INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A
PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF
CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE
OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
