#! /bin/bash

contract="${1:-$(cat /dev/stdin)}"

printf "\n\nstarting tests\n\n"

echo "fallback function"
seth send $contract
printf "^^^^^^^^^^ should fail ^^^^^^^^^^\n\n"

echo "balanceOf(ETH_FROM)"
seth call $contract 'balanceOf(address)' $ETH_FROM
printf "^^^^^^^^^^ should be 0x0 ^^^^^^^^^^\n\n"

echo "balanceOf(0x123)"
seth call $contract 'balanceOf(address)' 0x123
printf "^^^^^^^^^^ should be 0x0 ^^^^^^^^^^\n\n"

echo "totalSupply()"
seth call $contract 'totalSupply()'
printf "^^^^^^^^^^ should be 0x0 ^^^^^^^^^^\n\n"

echo "transfer(0x123, 0xa)"
seth send $contract 'transfer(address,uint256)' 0x123 0xa
printf "^^^^^^^^^^ should fail ^^^^^^^^^^\n\n"

echo "mint(ETH_FROM, 0xdada)"
seth send $contract 'mint(address,uint256)' $ETH_FROM 0xdada
printf "^^^^^^^^^^ should succeed ^^^^^^^^^^\n\n"

echo "balanceOf(ETH_FROM)"
seth call $contract 'balanceOf(address)' $ETH_FROM
printf "^^^^^^^^^^ should be 0xdada ^^^^^^^^^^\n\n"

echo "totalSupply()"
seth call $contract 'totalSupply()'
printf "^^^^^^^^^^ should be 0xdada ^^^^^^^^^^\n\n"

echo "transfer(0x123, 0xa)"
seth send $contract 'transfer(address,uint256)' 0x123 0xa
printf "^^^^^^^^^^ should succeed ^^^^^^^^^^\n\n"

echo "balanceOf(0x123)"
seth call $contract 'balanceOf(address)' 0x123
printf "^^^^^^^^^^ should be 0xa ^^^^^^^^^^\n\n"

echo "balanceOf(ETH_FROM)"
seth call $contract 'balanceOf(address)' $ETH_FROM
printf "^^^^^^^^^^ should be 0xdad0 ^^^^^^^^^^\n\n"

echo "totalSupply()"
seth call $contract 'totalSupply()'
printf "^^^^^^^^^^ should be 0xdada ^^^^^^^^^^\n\n"

echo "symbol()"
seth call $contract 'symbol()' | seth --to-ascii
printf "^^^^^^^^^^ should be DAI ^^^^^^^^^^\n\n"

echo "name()"
seth call $contract 'name()' | seth --to-ascii
printf "^^^^^^^^^^ should be Dai Stablecoin ^^^^^^^^^^\n\n"

echo "decimals()"
seth call $contract 'decimals()' | seth --to-dec
printf "^^^^^^^^^^ should be 18 ^^^^^^^^^^^\n\n"

echo "approve(0x123, 0xdddd)"
seth send $contract 'approve(address,uint256)' 0x123 0xdddd
printf "^^^^^^^^^^ should succeed ^^^^^^^^^\n\n"

echo "allowance(ETH_FROM, 0x123)"
seth call $contract 'allowance(address,address)' $ETH_FROM 0x123
printf "^^^^^^^^^^ should be 0xdddd ^^^^^^^\n\n"

echo "transferFrom(ETH_FROM, 0x123, 0xffff)"
seth send $contract 'transferFrom(address,address,uint256)' $ETH_FROM 0x123 0xffff
printf "^^^^^^^^^^ should fail ^^^^^^^^^^^\n\n"

echo "transferFrom(ETH_FROM, 0x123, 0xd0)"
seth send $contract 'transferFrom(address,address,uint256)' $ETH_FROM 0x123 0xd0
printf "^^^^^^^^^^ should succeed ^^^^^^^^^^\n\n"

echo "balanceOf(ETH_FROM)"
seth call $contract 'balanceOf(address)' $ETH_FROM
printf "^^^^^^^^^^ should be 0xda00 ^^^^^^^^\n\n"

echo "balanceOf(0x123)"
seth call $contract 'balanceOf(address)' 0x123
printf "^^^^^^^^^^ should be 0xda ^^^^^^^^^^\n\n"

echo "allowance(ETH_FROM, 0x123)"
seth call $contract 'allowance(address,address)' $ETH_FROM 0x123
printf "^^^^^^^^^^ should be 0xdd0d ^^^^^^^^\n\n"

echo "rely(0x123) -F ETH_FROM_2"
seth send $contract -F $ETH_FROM_2 'rely(address)' 0x123
printf "^^^^^^^^^^ should fail ^^^^^^^^^\n\n"

echo "rely(ETH_FROM_2)"
seth send $contract 'rely(address)' $ETH_FROM_2
printf "^^^^^^^^^^ should succeed ^^^^^\n\n"

echo "rely(0x123) -F ETH_FROM_2"
seth send $contract -F $ETH_FROM_2 'rely(address)' 0x123
printf "^^^^^^^^^^ should succeed ^^^^^^^^^\n\n"

echo "wards(0x123)"
seth call $contract 'wards(address)' 0x123
printf "                                                       should be 1\n\n"
