Low-level Ruby bindings for [libspotify][], the official Spotify C API
======================================================================
[![Build Status](https://secure.travis-ci.org/Burgestrand/spotify.png?branch=master)](http://travis-ci.org/Burgestrand/spotify)
[![Dependency Status](https://gemnasium.com/Burgestrand/spotify.png)](https://gemnasium.com/Burgestrand/spotify)
[![Code Climate](https://codeclimate.com/github/Burgestrand/spotify.png)](https://codeclimate.com/github/Burgestrand/spotify)
[![Gem Version](https://badge.fury.io/rb/spotify.png)](http://badge.fury.io/rb/spotify)

    The libspotify C API package allows third party developers to write
    applications that utilize the Spotify music streaming service.

[Spotify][] is a really nice music streaming service, and being able to interact
with it in an API is awesome. libspotify itself is however written in C, making
it unavailable or cumbersome to use for many developers.

This project aims to allow Ruby developers access to all of the libspotify C API,
without needing to reach down to C. However, to use this library to its full extent
you will need to learn how to use the Ruby FFI API.

The Spotify gem has:

- [100% API coverage][], including callback support. You’ll be able to use any function from the libspotify library.
- [Automatic garbage collection][]. Piggybacking on Ruby’s GC to manage pointer lifecycle.
- [Parallell function call protection][]. libspotify is not thread-safe, but Spotify protects you by providing a re-entrant mutex around function calls.
- [Type conversion and type safety][]. Special pointers for every Spotify type, protecting you from accidental mix-ups.
- [Support for JRuby and Rubinius][]. Thanks to FFI, the gem runs fine on the main three Ruby implementations!

[100% API coverage]: http://rdoc.info/github/Burgestrand/spotify/master/Spotify/API
[Automatic garbage collection]: http://rdoc.info/github/Burgestrand/spotify/master/Spotify/ManagedPointer
[Parallell function call protection]: http://rdoc.info/github/Burgestrand/spotify/master/Spotify#method_missing-class_method
[Type conversion and type safety]: http://rdoc.info/github/Burgestrand/spotify/master/Spotify/ManagedPointer
[Support for JRuby and Rubinius]: https://github.com/Burgestrand/spotify/blob/master/.travis.yml

Contact details
---------------

- __Got questions?__ Ask on the mailing list: [ruby-hallon@googlegroups.com][] (<https://groups.google.com/d/forum/ruby-hallon>)
- __Found a bug?__ Report an issue: <https://github.com/Burgestrand/spotify/issues/new>
- __Have feedback?__ I ❤ feedback! Please send it to the mailing list.

Spotify API is best used with a supporting library
--------------------------------------------------
As the raw libspotify API is exposed, the Spotify gem is best coupled with a supporting
library. This library would take a more focused approach to which kind of applications
you can write using it. The Spotify gem itself, however, has very few opinions.

Known supporting libraries:

- [Hallon](https://github.com/Burgestrand/Hallon). Hallon attempted to be a one-gem-does-all,
  at a higher abstraction level than the Spotify gem. It features a slightly more convenient
  API for certain things, and requires no ruby FFI knowledge, but it is not really an expert
  on any use case.

The Spotify API is well suited for experimentation, and it can be awfully fun to play with.
The examples/ directory contains example code for achieving certain tasks with the Spotify gem.

If you need any assitance feel free to post a message on the mailing list: [ruby-hallon@googlegroups.com][].

Questions, notes and answers
----------------------------

### A note about gem versioning

Given a version `X.Y.Z`, each segment corresponds to:

- `X` reflects supported libspotify version (12.1.45 => 12). There are __no guarantees__ of backwards-compatibility!
- `Y` is for backwards-**incompatible** changes.
- `Z` is for backwards-**compatible** changes.

You should use the following version constraint: `gem "spotify", "~> 12.5.3"`.

### How do I run the examples?

You’ll need:

1. A [Spotify](http://spotify.com/) premium account.
2. A [Spotify application key](https://developer.spotify.com/technologies/libspotify/keys/). Download the binary key,
   and put it in `examples/spotify_appkey.key`.

Enter the examples directory, and run an example as follows:

```
SPOTIFY_USERNAME="your username" SPOTIFY_PASSWORD="your password" ruby example-logging_in.rb
```

Available examples are:

- **example-audio_stream.rb**: plays songs from Spotify with the [plaything](https://github.com/Burgestrand/plaything) gem, using OpenAL.
- **example-console.rb**: logs in to Spotfify, and initiates a pry session to allow experimentation with the spotify gem API.
- **example-loading_object.rb**: loads a track using polling and the spotify gem API.
- **example-logging_in.rb**: logs in to Spotify and prints the current user's username.
- **example-random_related_artists.rb**: looks up an artist and its similar artists on spotify, then it picks a similar artist at random and does the same to that artist, over and over. I have used this example file to test prolonged usage of the API.

### Can I manually install libspotify?

By default, Spotify uses [the libspotify gem](https://rubygems.org/gems/libspotify) which means you do
not need to install libspotify yourself. However, if your platform is not supported by the libspotify
gem you will need to install libspotify yourself.

Please note, that if your platform is not supported by the libspotify gem I’d very much appreciate it
if you could create an issue on [libspotify gem issue tracker](https://github.com/Burgestrand/libspotify/issues)
so I can fix the build for your platform.

Instructions on installing libspotify manually are in the wiki: [How to install libspotify](https://github.com/Burgestrand/spotify/wiki)

[semantic versioning (semver.org)]: http://semver.org/
[ruby-hallon@googlegroups.com]: mailto:ruby-hallon@googlegroups.com
[libspotify]: https://developer.spotify.com/technologies/libspotify/
[Spotify]: https://www.spotify.com/
[Hallon]: https://github.com/Burgestrand/Hallon
