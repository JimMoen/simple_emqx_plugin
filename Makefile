## shallow clone for speed
export REBAR_GIT_CLONE_OPTIONS += --depth=1

export BUILD_WITHOUT_QUIC ?= true
export BUILD_WITHOUT_ROCKSDB ?= true

REBAR ?= $(or $(shell which rebar3 2>/dev/null),$(CURDIR)/rebar3)
## TODO: OTP vsn check
## OTP 24 not supported,
## 3.19.0-emqx-9 for OTP 25
## 3.20.0-emqx-1 for OTP 26
REBAR_VERSION ?= 3.19.0-emqx-1

.PHONY: all
all: compile

.PHONY: get-rebar3
get-rebar3:
	@$(CURDIR)/get-rebar3 $(REBAR_VERSION)

$(REBAR):
	$(MAKE) get-rebar3

.PHONY: compile
compile: $(REBAR)
	$(REBAR) compile

.PHONY: ct
ct: $(REBAR)
	$(REBAR) as test ct -v

.PHONY: eunit
eunit: $(REBAR)
	$(REBAR) as test eunit

.PHONY: xref
xref: $(REBAR)
	$(REBAR) xref

.PHONY: cover
cover: $(REBAR)
	$(REBAR) cover

.PHONY: clean
clean: distclean

.PHONY: distclean
distclean:
	@rm -rf _build
	@rm -f data/app.*.config data/vm.*.args rebar.lock

.PHONY: rel
rel: $(REBAR)
	$(REBAR) emqx_plugrel tar
