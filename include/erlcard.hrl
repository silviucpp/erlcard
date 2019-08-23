
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

-type card_type() ::
    ?CARD_TYPE_AMEX |
    ?CARD_TYPE_DANKORT |
    ?CARD_TYPE_DINERSCLUB |
    ?CARD_TYPE_DISCOVER |
    ?CARD_TYPE_FORBRUGSFORENINGEN|
    ?CARD_TYPE_JCB |
    ?CARD_TYPE_MAESTRO |
    ?CARD_TYPE_MASTERCARD |
    ?CARD_TYPE_UNIONPAY |
    ?CARD_TYPE_VISA |
    ?CARD_TYPE_VISAELECTRON.

-type card_number() :: binary().
