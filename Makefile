ROOT_TEST=_build/test/lib

ifndef suite
	SUITE_EXEC=
else
	SUITE_EXEC=-suite $(suite)_SUITE
endif

compile:
	@rebar3 compile

ct:
	mkdir -p log
	rebar3 ct --compile_only
	ct_run  -no_auto_compile \
			-cover test/cover.spec \
			-dir $(ROOT_TEST)/erlcard/test $(SUITE_EXEC) \
			-pa $(ROOT_TEST)/*/ebin \
			-logdir log

