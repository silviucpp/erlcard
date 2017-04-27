-module(integrity_test_SUITE).

-author("silviu.caragea").

-include_lib("common_test/include/ct.hrl").
-include("erlcard.hrl").

-compile(export_all).

-define(TEST_CARDS, [
    {?CARD_TYPE_VISAELECTRON, [
        <<"4917300800000000">>
    ]},
    {?CARD_TYPE_MAESTRO, [
        <<"6759649826438453">>,
        <<"6799990100000000019">>
    ]},
    {?CARD_TYPE_FORBRUGSFORENINGEN, [
        <<"6007220000000004">>
    ]},
    {?CARD_TYPE_VISA, [
        <<"4111111111111111">>,
        <<"4012888888881881">>,
        <<"4222222222222">>,
        <<"4462030000000000">>,
        <<"4484070000000000">>
    ]},
    {?CARD_TYPE_MASTERCARD, [
        <<"5555555555554444">>,
        <<"5454545454545454">>,
        <<"2221000002222221">>,
        <<"2222000000000008">>,
        <<"2223000000000007">>,
        <<"2224000000000006">>,
        <<"2225000000000005">>,
        <<"2226000000000004">>,
        <<"2227000000000003">>,
        <<"2228000000000002">>,
        <<"2229000000000001">>,
        <<"2230000000000008">>,
        <<"2240000000000006">>,
        <<"2250000000000003">>,
        <<"2260000000000001">>,
        <<"2270000000000009">>,
        <<"2280000000000007">>,
        <<"2290000000000005">>,
        <<"2300000000000003">>,
        <<"2400000000000002">>,
        <<"2500000000000001">>,
        <<"2600000000000000">>,
        <<"2700000000000009">>,
        <<"2710000000000007">>,
        <<"2720999999999996">>
    ]},
    {?CARD_TYPE_AMEX, [
        <<"378282246310005">>,
        <<"371449635398431">>,
        <<"378734493671000">>
    ]},
    {?CARD_TYPE_DINERSCLUB, [
        <<"30569309025904">>,
        <<"38520000023237">>,
        <<"36700102000000">>,
        <<"36148900647913">>
    ]},
    {?CARD_TYPE_DISCOVER, [
        <<"6011111111111117">>,
        <<"6011000990139424">>
    ]},
    {?CARD_TYPE_UNIONPAY, [
        <<"6271136264806203568">>,
        <<"6236265930072952775">>,
        <<"6204679475679144515">>,
        <<"6216657720782466507">>
    ]},
    {?CARD_TYPE_JCB, [
        <<"3530111333300000">>,
        <<"3566002020360505">>
    ]},
    {?CARD_TYPE_HIPERCARD, [
        <<"6062824440692130">>,
        <<"6062822921732946">>,
        <<"6062827980339442">>
    ]}
]).

-define(INVALID_CARDS, [
    {?CARD_TYPE_MASTERCARD, [
        <<"2220000000000000">>,
        <<"2721000000000004">>
    ]}
]).

all() -> [
    {group, erlcard_group}
].

groups() -> [
    {erlcard_group, [sequence], [
        test_card_types,
        test_numbers,
        test_luhn,
        test_cvc
    ]}
].

init_per_suite(Config) ->
    Config.

end_per_suite(_Config) ->
    ok.

test_card_types(_Config) ->
    Fun = fun({Type, Numbers}) ->
        FunValidate = fun(Number) ->
            {ok, Number, Type} = erlcard:valid_credit_card(Number),
            {ok, Number, Type} = erlcard:valid_credit_card(Number, Type)
                      end,
        ok = lists:foreach(FunValidate, Numbers)
          end,
    ok = lists:foreach(Fun, ?TEST_CARDS),
    true.

test_invalid_cards(_Config) ->
    Fun = fun({Type, Numbers}) ->
        FunValidate = fun(Number) ->
            false = erlcard:valid_credit_card(Number),
            false = erlcard:valid_credit_card(Number, Type)
        end,
        ok = lists:foreach(FunValidate, Numbers)
    end,
    ok = lists:foreach(Fun, ?INVALID_CARDS),
    true.

test_numbers(_Config) ->
    % Empty number
    false = erlcard:valid_credit_card(<<>>),

    % Number with spaces

    false = erlcard:valid_credit_card(<<"       ">>),

    % Valid number

    {ok, <<"4242424242424242">>, ?CARD_TYPE_VISA} = erlcard:valid_credit_card(<<"4242424242424242">>),

    % Valid number with dashes

    {ok, <<"4242424242424242">>, ?CARD_TYPE_VISA} = erlcard:valid_credit_card(<<"4242-4242-4242-4242">>),

    % Valid number with spaces

    {ok, <<"4242424242424242">>, ?CARD_TYPE_VISA} = erlcard:valid_credit_card(<<"4242 4242 4242 4242">>),

    % More than 16 digits

    false = erlcard:valid_credit_card(<<"42424242424242424">>),

    % Less than 10 digits

    false = erlcard:valid_credit_card(<<"424242424">>),

    true.

test_luhn(_Config) ->
    false = erlcard:valid_credit_card(<<"4242424242424241">>),
    true.

test_cvc(_Config) ->
    %empty

    false = erlcard:valid_cvc(<<"">>, ?CARD_TYPE_VISA),

    %wrong type

    false = erlcard:valid_cvc(<<"123">>, wrong_type),

    %valid

    true = erlcard:valid_cvc(<<"123">>, ?CARD_TYPE_VISA),

    %non digits

    false = erlcard:valid_cvc(<<"12e">>, ?CARD_TYPE_VISA),

    %less than 3 digits

    false = erlcard:valid_cvc(<<"12">>, ?CARD_TYPE_VISA),

    %more than 3 digits

    false = erlcard:valid_cvc(<<"1234">>, ?CARD_TYPE_VISA),
    true.