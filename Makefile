compile:
	@rebar compile

clean:
	@rebar clean

ct:
	mkdir -p log
	ct_run -suite integrity_test_SUITE -pa ebin -include include -logdir log