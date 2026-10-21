# Tincture APCA

[![CI](https://github.com/andycroll/tincture-apca/actions/workflows/ci.yml/badge.svg)](https://github.com/andycroll/tincture-apca/actions/workflows/ci.yml)

APCA contrast for Tincture colours

> [!WARNING]
> APCA is © Andrew Somers and Myndex Research, patent pending. Its [licence](LICENSE.md) allows use only for web content, in support of the WCAG accessibility guidelines. Other uses, such as print or PDF, fall under AGPL v3. A commercial product that uses it must give Myndex free access to audit the code on request.

## Installation

Add these lines to your Gemfile:

```ruby
gem "tincture"
gem "tincture-apca", require: false
```

Then require it where web content is built, not globally:

```ruby
require "tincture/apca"
```

## Usage

Measure APCA lightness contrast (Lc) for text on a background

```ruby
Tincture::Color.parse("#888").apca_contrast("#fff") # 63.06
Tincture::Color.parse("#fff").apca_contrast("#888") # -68.54
```

Positive is dark text on light, negative is light on dark. For body text, Lc 75 is the minimum and Lc 90 preferred.

Pick black or white text by APCA

```ruby
background.contrast_color(method: :apca)
background.contrast_color(among: ["#1f2937", "white"], method: :apca)
```

This is a port of [apca-w3](https://github.com/Myndex/apca-w3) 0.1.9 (algorithm 0.0.98G-4g), checked against its test values.

## Development

```sh
bundle install
bundle exec rake        # tests and RuboCop
bundle exec rake rdoc   # API docs in doc/
```

To release, set the version in `lib/tincture/apca/version.rb`, date the changelog entry, commit, and push a `vX.Y.Z` tag. GitHub Actions runs the checks and publishes the gem to rubygems.org through trusted publishing.
