# erlcard
 
Validates popular debit and credit cards numbers against regular expressions and Luhn algorithm. Also validates the CVC. 

### Instalation

Add `erlcard` as a rebar dependency to your project:

```
{deps, [
  {erlcard, ".*", {git, "https://github.com/silviucpp/erlcard.git", "master"}},
}.
```

### Usage

All available types that can be validated are available in `erlcard.hrl` :

```erlang
-define(CARD_TYPE_VISA, visa).
-define(CARD_TYPE_MASTERCARD, mastercard).
-define(CARD_TYPE_AMEX, amex).
-define(CARD_TYPE_DINERSCLUB, dinersclub).
-define(CARD_TYPE_DISCOVER, discover).
-define(CARD_TYPE_UNIONPAY, unionpay).
-define(CARD_TYPE_JCB, jcb).
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


