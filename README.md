# Sparrow
sparrow is Nurse Scheduling Problem Solver with AUK.
AUK is a Domain Specific Language that can describe Scheduling Problem.
sparrow is created based on [swallow](https://github.com/matsuda0528/swallow).

An interface to SAT Solver is provided by [Ravensat](https://github.com/matsuda0528/ravensat).

## Installation

### SAT solver install
Install Minisat for Linux(Debian):

    $ sudo apt install minisat

for MacOS:

    $ brew install minisat

Install from GitHub: See [Minisat(GitHub)](https://github.com/niklasso/minisat)

### sparrow setup
After cloning this repository, set it up with the following command.

    $ ./bin/setup

## Usage

  Usage: sparrow [options] <auk_file>
    -d, --debug                                         (default: false)
    -f, --format [VALUE]             [auk | html | json] (default: auk)
    -s, --solver [VALUE]             <solver name>      (default: minisat)

### Solve for AUK
AUK file samples are located under `example/`.
```
$ ruby exe/sparrow AUK_FILE_PATH
```
## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
