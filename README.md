[![Ruby](https://github.com/matsuda0528/swallow/actions/workflows/main.yml/badge.svg)](https://github.com/matsuda0528/swallow/actions/workflows/main.yml)
# Swallow
Swallow is University Course Timetabling Problem (UCTTP) Solver with AUK.
AUK is a Domain Specific Language that can describe UCTTP.

Swallow can use SAT Solver to quickly solve for UCTTP.
An interface to SAT Solver is provided by [Ravensat](https://github.com/matsuda0528/ravensat).

## Installation

### SAT solver install
Install Minisat for Linux(Debian):

    $ sudo apt install minisat

for MacOS:

    $ brew install minisat

Install from GitHub: See [Minisat(GitHub)](https://github.com/niklasso/minisat)

### swallow setup
After cloning this repository, set it up with the following command.

    $ ./bin/setup

## Usage

    Usage: swallow [options]
            --output=[VALUE]             auk | html | csv (default: auk)

### Solve for AUK
AUK file samples are located under `example/`.
```
$ ruby exe/swallow [auk_file_path]
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/matsuda0528/swallow. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/matsuda0528/swallow/blob/master/CODE_OF_CONDUCT.md).

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Swallow project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/matsuda0528/swallow/blob/master/CODE_OF_CONDUCT.md).
