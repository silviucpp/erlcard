
-author("silviu.caragea").

% debit cards

-define(CARD_TYPE_VISAELECTRON, visaelectron).
-define(CARD_TYPE_MAESTRO, maestro).
-define(CARD_TYPE_FORBRUGSFORENINGEN, forbrugsforeningen).
-define(CARD_TYPE_DANKORT, dankort).

% credit cards

-define(CARD_TYPE_VISA, visa).
-define(CARD_TYPE_MASTERCARD, mastercard).
-define(CARD_TYPE_AMEX, amex).
-define(CARD_TYPE_DINERSCLUB, dinersclub).
-define(CARD_TYPE_DISCOVER, discover).
-define(CARD_TYPE_UNIONPAY, unionpay).
-define(CARD_TYPE_JCB, jcb).
-define(CARD_TYPE_HIPERCARD, hipercard).

-type card_type() :: atom().
-type card_number() :: binary().
