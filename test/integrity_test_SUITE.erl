-module(integrity_test_SUITE).

-include_lib("common_test/include/ct.hrl").
-include_lib("stdlib/include/assert.hrl").
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

    {?CARD_TYPE_DANKORT, [
        <<"5019717010103742">>
    ]},

    {?CARD_TYPE_VISA, [
        <<"4111111111111111">>,
        <<"4012888888881881">>,
        <<"4222222222222">>,
        <<"4462030000000000">>,
        <<"4484070000000000">>,
        <<"4921818425002311">>,
        <<"4001919257537193">>,
        <<"4987654321098769">>,
        <<"4444333322221111455">>,
        <<"4539935586467516275">>
    ]},
    {?CARD_TYPE_MASTERCARD, [
        <<"5555555555554444">>,
        <<"5454545454545454">>,
        <<"2221000002222221">>,
        <<"2223000010089800">>,
        <<"2223000048400011">>
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
            ?assertEqual({ok, Number, Type}, erlcard:valid_credit_card(Number)),
            ?assertEqual({ok, Number, Type}, erlcard:valid_credit_card(Number, Type))
        end,
        ok = lists:foreach(FunValidate, Numbers)
    end,
    ok = lists:foreach(Fun, ?TEST_CARDS),
    true.

test_numbers(_Config) ->

    % Empty number
    ?assertEqual(false, erlcard:valid_credit_card(<<>>)),

    % Number with spaces

    ?assertEqual(false, erlcard:valid_credit_card(<<"       ">>)),

    % Valid number

    ?assertEqual({ok, <<"4242424242424242">>, ?CARD_TYPE_VISA}, erlcard:valid_credit_card(<<"4242424242424242">>)),

    % Valid number with dashes

    ?assertEqual({ok, <<"4242424242424242">>, ?CARD_TYPE_VISA}, erlcard:valid_credit_card(<<"4242-4242-4242-4242">>)),

    % Valid number with spaces

    ?assertEqual({ok, <<"4242424242424242">>, ?CARD_TYPE_VISA}, erlcard:valid_credit_card(<<"4242 4242 4242 4242">>)),

    % More than 16 digits

    ?assertEqual(false, erlcard:valid_credit_card(<<"42424242424242424">>)),

    % Less than 10 digits

    ?assertEqual(false, erlcard:valid_credit_card(<<"424242424">>)),

    % Valid predefined card type

    ?assertEqual({ok, <<"4242424242424242">>, ?CARD_TYPE_VISA}, erlcard:valid_credit_card(<<"4242424242424242">>, ?CARD_TYPE_VISA)),

    % Invalid any of predefined card types

    ?assertEqual(false, erlcard:valid_credit_card(<<"4242424242424242">>, ?CARD_TYPE_MASTERCARD)),

    true.

test_luhn(_Config) ->
    ?assertEqual(false, erlcard:valid_credit_card(<<"4242424242424241">>)),
    true.

test_cvc(_Config) ->
    % empty

    ?assertEqual(false, erlcard:valid_cvc(<<"">>, ?CARD_TYPE_VISA)),

    % wrong type

    ?assertEqual(false, erlcard:valid_cvc(<<"123">>, wrong_type)),

    % valid

    ?assertEqual(true, erlcard:valid_cvc(<<"123">>, ?CARD_TYPE_VISA)),

    % non digits

    ?assertEqual(false, erlcard:valid_cvc(<<"12e">>, ?CARD_TYPE_VISA)),

    % less than 3 digits

    ?assertEqual(false, erlcard:valid_cvc(<<"12">>, ?CARD_TYPE_VISA)),

    % more than 3 digits

    ?assertEqual(false, erlcard:valid_cvc(<<"1234">>, ?CARD_TYPE_VISA)),
    true.
