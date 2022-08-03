#!/bin/sh

js=$(echo "
var bar = document.querySelector('#playbackControlBar');
var ftr = document.querySelector('#footerPlayer');
var prg = document.querySelector('#progressBar');

var shf = bar.children[0];
var ply = bar.children[2].children[1];
var nxt = bar.children[3];
var rpt = bar.children[4];

if (shf.ariaChecked != 'true') {
  shf.click();
}
if (ply.ariaLabel == 'Play') {
  ply.click();
}
if (rpt.ariaLabel != 'Repeat' || rpt.ariaChecked != 'true') {
  rpt.click();
}

var stq = ftr.children[2].firstChild;
if (stq.innerText != 'NORMAL') {
  stq.firstChild.click();
  sleep(1000);
  Array.prototype.slice.call(document.getElementsByTagName('div')).filter(el=>el.innerText.toLowerCase() === 'normal')[0].parentNode.click();
}

var max = parseFloat(prg.ariaValueMax) * parseFloat(Math.random() * (0.9 - 0.7) + 0.7);
var now = prg.ariaValueNow;
if (now > max && now > 35) {
  nxt.click();
}")

function playing {
  p="> skipped ${1} tracks"
  for (( i = 0; i < 5; i++ ))
  do
    printf "\e[92m${p}\e[0m\r"
    sleep 0.5;
    printf "\e[92m${p}.\e[0m\r"
    sleep 0.5;
    printf "\e[92m${p}..\e[0m\r"
    sleep 0.5;
    printf "\e[92m${p}...\e[0m\r"
    sleep 0.5;
    printf "\e[92m${p}   \e[0m\r"
  done
}

function track {
  echo $(chrome-cli execute "document.querySelector('#footerPlayer').firstChild.children[1].firstChild.innerText" -t $1)
}

i=60
n=0
while true; do
  if [[ $(( i % 60 )) -eq 0 ]];
  then
    id=$(chrome-cli list tabs | grep -E 'TIDAL' | grep -E -o '[0-9]+' | tail -n1)
  fi

  a=$(track "$id")
  chrome-cli execute "$js" -t "$id"

  if [[ $a != $(track "$id") ]];
  then
    playing "$n"
    n=$(( n + 1 ))
  fi
  i=$(( i + 10 ))
done
