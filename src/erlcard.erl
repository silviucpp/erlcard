-module(erlcard).

-author("silviu.caragea").

-include("erlcard.hrl").

-export([
    valid_credit_card/1,
    valid_credit_card/2,
    valid_cvc/2
]).

-define(AVAILABLE_CARDS, [

    % debit cards

    #{
        type => ?CARD_TYPE_VISAELECTRON,
        pattern => <<"^4(026|17500|405|508|844|91[37])">>,
        length => 16,
        cvc_length => 3,
        luhn => true
    },

    #{
        type => ?CARD_TYPE_MAESTRO,
        pattern => <<"^(5(018|0[23]|[68])|6(39|7))">>,
        length => [12, 13, 14, 15, 16, 17, 18, 19],
        cvc_length => 3,
        luhn => true
    },

    #{
        type => ?CARD_TYPE_FORBRUGSFORENINGEN,
        pattern => <<"^600">>,
        length => 16,
        cvc_length => 3,
        luhn => true
    },

    #{
        type => ?CARD_TYPE_DANKORT,
        pattern => <<"^5019">>,
        length => 16,
        cvc_length => 3,
        luhn => true
    },

    % credit cards

    #{
        type => ?CARD_TYPE_VISA,
        pattern => <<"^4">>,
        length => [13, 16],
        cvc_length => 3,
        luhn => true
    },

    #{
        type => ?CARD_TYPE_MASTERCARD,
        pattern => <<"^(5[0-5]|2(2(2[1-9]|[3-9])|[3-6]|7(0|1|20)))">>,
        length => 16,
        cvc_length => 3,
        luhn => true
    },

    #{
        type => ?CARD_TYPE_AMEX,
        pattern => <<"^3[47]">>,
        length => 15,
        cvc_length => [3, 4],
        luhn => true
    },

    #{
        type => ?CARD_TYPE_DINERSCLUB,
        pattern => <<"^3[0689]">>,
        length => 14,
        cvc_length => 3,
        luhn => true
    },

    #{
        type => ?CARD_TYPE_DISCOVER,
        pattern => <<"^6([045]|22)">>,
        length => 16,
        cvc_length => 3,
        luhn => true
    },

    #{
        type => ?CARD_TYPE_UNIONPAY,
        pattern => <<"^(62|88)">>,
        length => [16, 17, 18, 19],
        cvc_length => 3,
        luhn => true
    },

    #{
        type => ?CARD_TYPE_JCB,
        pattern => <<"^35">>,
        length => 16,
        cvc_length => 3,
        luhn => true
    },

    #{
        type => ?CARD_TYPE_HIPERCARD,
        pattern => <<"^(606282\d{10}(\d{3})?)|(3841\d{15})$">>,
        length => 16,
        cvc_length => 3,
        luhn => true
    }
]).

-spec valid_credit_card(binary()) ->
    {ok, card_number(), card_type()} | false.

valid_credit_card(CardNumber) ->
    valid_credit_card(CardNumber, undefined).

-spec valid_credit_card(binary(), card_type()) ->
    {ok, card_number(), card_type()} | false.

valid_credit_card(CardNumber0, ExpectedCardType) ->
    CardNumber = re:replace(CardNumber0, <<"[^0-9]">>, <<"">>, [global, {return, binary}]),

    case CardNumber of
        <<>> ->
            false;
        _ ->
            case get_card_validation_rules(CardNumber, ?AVAILABLE_CARDS, ExpectedCardType) of
                {ok, ValidationRules} ->
                    case valid_card(CardNumber, ValidationRules) of
                        true ->
                            #{type := CardType} = ValidationRules,
                            {ok, CardNumber, CardType};
                        _ ->
                            false
                    end;
                _ ->
                    false
            end
    end.

-spec valid_cvc(binary(), card_type()) ->
    boolean().

valid_cvc(Cvc, CardType) ->
    case re:run(Cvc, <<"^[0-9]*$">>) of
        nomatch ->
            false;
        _ ->
            case get_card_validation_rules_by_type(?AVAILABLE_CARDS, CardType) of
                {ok, #{cvc_length := CvcExpectedLength}} ->
                    valid_length(Cvc, CvcExpectedLength);
                _ ->
                    false
            end
    end.

% internals

get_card_validation_rules(Number, AvCards, undefined) ->
    get_card_validation_rules_by_number(AvCards, Number);
get_card_validation_rules(_Number, AvCards, Type) ->
    get_card_validation_rules_by_type(AvCards, Type).

get_card_validation_rules_by_type([#{type := Type} = H | T], ExpectedType) ->
    case Type =:= ExpectedType of
        true ->
            {ok, H};
    _ ->
        get_card_validation_rules_by_type(T, ExpectedType)
    end;
get_card_validation_rules_by_type([], _ExpectedType) ->
        false.

get_card_validation_rules_by_number([#{pattern := Pattern} = H | T], Number) ->
    case valid_pattern(Number, Pattern) of
        true ->
            {ok, H};
        _ ->
            get_card_validation_rules_by_number(T, Number)
    end;
get_card_validation_rules_by_number([], _Number) ->
    false.

valid_card(Number, #{pattern := Pattern, length := Length, luhn := Luhn}) ->
    valid_pattern(Number, Pattern) andalso valid_length(Number, Length) andalso valid_luhn(Number, Luhn).

valid_pattern(Number, Pattern) ->
    re:run(Number, Pattern) =/= nomatch.

valid_length(Binary, Length) when is_integer(Length) ->
    byte_size(Binary) =:= Length;
valid_length(Binary, Length) ->
    lists:member(byte_size(Binary), Length).

valid_luhn(Number, true) ->
    case luhn_sum(lists:map(fun(D) -> D-$0 end, lists:reverse(binary_to_list(Number)))) of
        Sum when (Sum rem 10) =:= 0 ->
            true;
        _ ->
            false
    end;
valid_luhn(_Number, false) ->
    true.

luhn_sum([Odd, Even | Rest]) when Even >= 5 ->
    Odd + 2 * Even - 10 + 1 + luhn_sum(Rest);
luhn_sum([Odd, Even |Rest]) ->
    Odd + 2 * Even + luhn_sum(Rest);
luhn_sum([Odd]) ->
    Odd;
luhn_sum([]) ->
    0.
