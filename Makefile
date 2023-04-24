# include .env file and export its env vars
# (-include to ignore error if it does not exist)
-include .env

# to resolve the conflict between test directory and test command
.PHONY: test

# deps
install  :; forge install
update   :; forge update

# Build & test
build    :; forge build
clean    :; forge clean
test     :; forge test --fork-url https://eth.llamarpc.com
trace    :; forge test -vvvv --fork-url https://eth.llamarpc.com
coverage :; forge coverage --fork-url https://eth.llamarpc.com
snapshot :; forge snapshot
gas      :; forge test --fork-url https://eth.llamarpc.com --gas-report

# deploy scripts

# calls
