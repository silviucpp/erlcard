# erlcard

[![Build Status](https://app.travis-ci.com/silviucpp/erlcard.svg?branch=master)](https://travis-ci.com/github/silviucpp/erlcard)
![GitHub License](https://img.shields.io/github/license/silviucpp/erlcard)
![Hex.pm Version](https://img.shields.io/hexpm/v/erlcard)

`erlcard` is an Erlang library that validates popular debit and credit card numbers against regular expressions and the [Luhn algorithm][1]. It also supports validation of the CVC code.

## Installation

To add `erlcard` as a dependency in your `rebar3` project, include the following in your `rebar.config`:

```erlang
{deps, [
  {erlcard, ".*", {git, "https://github.com/silviucpp/erlcard.git", "master"}}
]}.
```

## Usage

All available card types are defined in `erlcard.hrl`:

```erlang
-define(CARD_TYPE_AMEX, amex).
-define(CARD_TYPE_DANKORT, dankort).
-define(CARD_TYPE_DINERSCLUB, dinersclub).
-define(CARD_TYPE_DISCOVER, discover).
-define(CARD_TYPE_FORBRUGSFORENINGEN, forbrugsforeningen).
-define(CARD_TYPE_JCB, jcb).
-define(CARD_TYPE_MAESTRO, maestro).
-define(CARD_TYPE_MASTERCARD, mastercard).
-define(CARD_TYPE_UNIONPAY, unionpay).
-define(CARD_TYPE_VISA, visa).
-define(CARD_TYPE_VISAELECTRON, visaelectron).
```

### Validating Card Numbers

#### When the Card Type is Known

```erlang
{ok, <<"5500005555555559">>, mastercard} = erlcard:valid_credit_card(<<"5500005555555559">>, mastercard).
```

#### When the Card Type is Unknown

```erlang
{ok, <<"5500005555555559">>, mastercard} = erlcard:valid_credit_card(<<"5500005555555559">>).
```

### Validating CVC Codes

```erlang
true = erlcard:valid_cvc(<<"123">>, visa).
```

## Running Tests

To execute the test suite, run the following command from the project's root directory:

```sh
make ct
```

[1]: https://en.wikipedia.org/wiki/Luhn_algorithm
