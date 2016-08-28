#!/bin/bash


echo "SMALL NONE"
./pc_patchavg.sh pc_humaita_small_none HUML6510C8920 5
echo

echo "SMALL DIMENSIONAL"
./pc_patchavg.sh pc_humaita_small HUML6510C8920 5
echo

echo "SMALL GHT"
./pc_patchavg.sh pc_humaita_small_ght HUML6510C8920 5
echo

echo "BIG NONE"
./pc_patchavg.sh pc_humaita_big_none HUML6470C8921 5
echo
 
echo "BIG DIMENSIONAL"
./pc_patchavg.sh pc_humaita_big HUML6470C8921 5

echo
echo "BIG GHT"
./pc_patchavg.sh pc_humaita_big_ght HUML6470C8921 5
