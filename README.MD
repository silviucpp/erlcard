# erlcard
 
[![Build Status](https://travis-ci.org/silviucpp/erlcard.svg?branch=master)](https://travis-ci.org/silviucpp/erlcard)
![GitHub](https://img.shields.io/github/license/silviucpp/erlcard)
![Hex.pm](https://img.shields.io/hexpm/v/erlcard) 
 
Validates popular debit and credit cards numbers against regular expressions and [Luhn algorithm][1]. The library also 
validates the CVC code. 

### Installation

Add `erlcard` as a `rebar` or `rebar3` dependency to your project:

```
{deps, [
  {erlcard, ".*", {git, "https://github.com/silviucpp/erlcard.git", "master"}},
}.
```

### Usage

All available types that can be validated are available in `erlcard.hrl` :

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

##### Validate a card number knowing the type

```erlang
{ok, <<"5500005555555559">>, mastercard} = erlcard:valid_credit_card(<<"5500005555555559">>, mastercard).
````

##### Validate a card number without knowing the type

```erlang
{ok, <<"5500005555555559">>, mastercard} = erlcard:valid_credit_card(<<"5500005555555559">>).
````

##### Validate the CVC

```erlang
true = erlcard:valid_cvc(<<"123">>, visa).
```

### Tests

You can run the tests using `make ct` from root directory.

[1]:https://en.wikipedia.org/wiki/Luhn_algorithm

