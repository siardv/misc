#!/bin/bash
#written for bash version 3.2
coins=("0x" "1inch" "aave-token" "apecoin-ape" "alchemy-pay" "algorand" "amp" "ankr-network" "balancer" "bancor" "band-protocol" "basic-attention-token" "bitcoin" "bitcoin-cash" "cardano" "cartesi" "clover-protocol" "celo" "chainlink" "chiliz" "compound" "cosmos" "curve" "decentraland" "dogecoin" "enjin-coin" "eos" "ethereum-classic" "ethereum" "fetch-ai" "filecoin" "iexec-rlc" "internet-computer" "keep-network" "kyber-network-crystal" "litecoin" "loopring" "maker" "mask-network" "matic-network" "mirror-protocol" "NKN" "nucypher" "numeraire" "omisego" "orchid-protocol" "omisego" "origin-protocol" "polkadot" "quant-network" "ripple" "shiba-inu" "skale-network" "solana" "stellar" "storj" "sushiswap" "synthetix" "tezos" "request-network" "the-graph" "tellor" "uniswap" "uma" "wrapped-luna-token" "yearn-finance" "tether")

for coin in "${coins[@]}"; do
  url="https://coincodex.com/crypto/"$coin"/price-prediction/"
  cc=$(curl --silent -L $url)
  shorturl=$(curl --silent http://tinyurl.com/api-create.php?url=$url)
  pred=$(echo "$cc" | grep "meta name=\"description\"" | head -1 )
  change=$(echo "$pred" | grep -o -E "[-0-9.]{2,6}" | head -1 )
  send_message(){
    printf "$(tput setaf 2)$(tput setab 7)$1$(tput sgr0)\n"
  }
  if [[ 10#${change//.} -gt 1000 ]]; then
    pred=${pred#*content=} && pred=${pred#*\, } && pred=${pred::${#pred}-2}
    echo $pred | sed -E "s/([0-9.%]{3,6})/$(tput setaf 2)\1$(tput sgr0)/"
    echo $shorturl
    echo
  elif [[ 10#${change//.} -gt 0 ]]; then
    pred=${pred#*content=} && pred=${pred#*\, } && pred=${pred::${#pred}-2}
    echo $pred | sed -E "s/([0-9.%]{3,6})/$(tput setaf 3)\1$(tput sgr0)/"
    echo $shorturl
    echo
  elif [[ 10#${change//.} -lt -1000 ]]; then
    pred=${pred#*content=} && pred=${pred#*\, } && pred=${pred::${#pred}-2}
    echo $pred | sed -E "s/([0-9.%]{3,6})/$(tput setaf 1)\1$(tput sgr0)/"
    echo $shorturl
    echo
  fi
done