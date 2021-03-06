#!/bin/bash
set -e

# Go the sources directory to run commands
DIR="$(cd -P "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)"
cd "$DIR"
pwd


echo "Generating static fonts"
rm -rf ../fonts
mkdir -p ../fonts/ttf
fontmake -m Oxanium.designspace -i -o ttf --output-dir ../fonts/ttf/ --keep-overlaps --keep-direction


echo "Post processing static fonts"
ttfs=(../fonts/ttf/*.ttf)
for ttf in "${ttfs[@]}"; do
	gftools fix-dsig -f "$ttf"
	#ttfautohint "$ttf" "$ttf.fix"
	#mv "$ttf.fix" "$ttf"
	echo "Hinting $ttf"
	name="$(basename "$ttf" .ttf)"
	htic --define "$name" --font "$ttf" hti/tables.hti hti/fpgm.hti hti/prep.hti hti/glyphs.hti
done


echo "Generating VFs"
mkdir -p ../fonts/variable
#fontmake -m Oxanium.designspace -o variable --output-path ../fonts/variable/Oxanium[wght].ttf --keep-overlaps  --keep-direction
python3 -m fontTools.varLib Oxanium.designspace --master-finder "../fonts/ttf/{stem}.ttf" -o ../fonts/variable/Oxanium\[wght\].ttf
rm -rf master_ufo/ instance_ufo/ instance_ufos/


echo "Post processing VFs"
vfs=(../fonts/variable/*\[wght\].ttf)
for vf in "${vfs[@]}"; do
	gftools fix-dsig -f "$vf"
	#ttfautohint-vf --stem-width-mode nnn "$vf" "$vf.fix"
	#mv "$vf.fix" "$vf"
done


echo "Fixing VF meta"
gftools fix-vf-meta "${vfs[@]}"


echo "Dropping MVAR"
for vf in "${vfs[@]}"; do
	mv "$vf.fix" "$vf"
	ttx -f -x "MVAR" "$vf" # Drop MVAR. Table has issue in DW
	rtrip="$(basename "$vf" .ttf)"
	new_file="../fonts/variable/$rtrip.ttx"
	rm "$vf"
	ttx "$new_file"
	rm "$new_file"
done


echo "Fixing hinting"
for ttf in "${ttfs[@]}" "${vfs[@]}"; do
	#gftools fix-nonhinting "$ttf" "$ttf.fix"
	gftools fix-hinting "$ttf"
	if [ -f "$ttf.fix" ]; then mv "$ttf.fix" "$ttf"; fi
	gftools fix-fsselection "$ttf" --usetypometrics
done


rm -f ../fonts/variable/*.ttx
rm -f ../fonts/ttf/*.ttx
rm -f ../fonts/variable/*gasp.ttf
rm -f ../fonts/ttf/*gasp.ttf

echo "Done"
