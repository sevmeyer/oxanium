#!/bin/sh
set -e

# Go the sources directory to run commands
SOURCE="${BASH_SOURCE[0]}"
DIR=$( cd -P "$( dirname "$SOURCE" )" >/dev/null 2>&1 && pwd )
cd $DIR
echo $(pwd)

rm -rf ../fonts


echo "Generating Static fonts"
mkdir -p ../fonts
fontmake -m Oxanium.designspace -i -o ttf --output-dir ../fonts/ttf/ --keep-overlaps --keep-direction

echo "Post processing"
ttfs=$(ls ../fonts/ttf/*.ttf)
for ttf in $ttfs
do
	gftools fix-dsig -f $ttf;
	#ttfautohint $ttf "$ttf.fix";
	#mv "$ttf.fix" $ttf;
done

echo "HTIC hinting"
mkdir -p temp;
cat hti/Oxanium-All-tables.hti | sed 's/#ifBold//' > temp/Oxanium-Bold.hti
cat hti/Oxanium-All-tables.hti | sed 's/#ifExtraBold//' > temp/Oxanium-ExtraBold.hti
cat hti/Oxanium-All-tables.hti | sed 's/#ifExtraLight//' > temp/Oxanium-ExtraLight.hti
cat hti/Oxanium-All-tables.hti | sed 's/#ifLight//' > temp/Oxanium-Light.hti
cat hti/Oxanium-All-tables.hti | sed 's/#ifMedium//' > temp/Oxanium-Medium.hti
cat hti/Oxanium-All-tables.hti | sed 's/#ifRegular//' > temp/Oxanium-Regular.hti
cat hti/Oxanium-All-tables.hti | sed 's/#ifSemiBold//' > temp/Oxanium-SemiBold.hti
weights=$(echo Bold ExtraBold ExtraLight Light Medium Regular SemiBold)
for weight in $weights
do
	cat hti/Oxanium-All-fpgm.hti >> temp/Oxanium-$weight.hti
	cat hti/Oxanium-All-prep.hti >> temp/Oxanium-$weight.hti
	cat hti/Oxanium-All-glyphs.hti >> temp/Oxanium-$weight.hti
	../tools/htic-ttf.py ../fonts/ttf/Oxanium-$weight.ttf temp/Oxanium-$weight.hti
done

echo "Generating VFs"
mkdir -p ../fonts/variable
# fontmake -m Oxanium.designspace -o variable --output-path ../fonts/variable/Oxanium[wght].ttf --keep-overlaps  --keep-direction
python3 -m fontTools.varLib Oxanium.designspace --master-finder "../fonts/ttf/{stem}.ttf" -o ../fonts/variable/Oxanium\[wght\].ttf

rm -rf master_ufo/ instance_ufo/ instance_ufos/



vfs=$(ls ../fonts/variable/*\[wght\].ttf)

echo "Post processing VFs"
for vf in $vfs
do
	gftools fix-dsig -f $vf;
	#ttfautohint-vf --stem-width-mode nnn $vf "$vf.fix";
	#mv "$vf.fix" $vf;
done



echo "Fix VF Meta"
gftools fix-vf-meta $vfs;

echo "Dropping MVAR"
for vf in $vfs
do
	mv "$vf.fix" $vf;
	ttx -f -x "MVAR" $vf; # Drop MVAR. Table has issue in DW
	rtrip=$(basename -s .ttf $vf)
	new_file=../fonts/variable/$rtrip.ttx;
	rm $vf;
	ttx $new_file
	rm $new_file

done

echo "Fixing Hinting"
for vf in $vfs
do
	# gftools fix-nonhinting $vf "$vf.fix";
	gftools fix-hinting $vf;
	if [ -f "$vf.fix" ]; then mv "$vf.fix" $vf; fi
	gftools fix-fsselection $vf --usetypometrics;
done
for ttf in $ttfs
do
	# gftools fix-nonhinting $ttf "$ttf.fix";
	gftools fix-hinting $ttf;
    if [ -f "$ttf.fix" ]; then mv "$ttf.fix" $ttf; fi
	gftools fix-fsselection $ttf --usetypometrics;
done

rm -f ../fonts/variable/*.ttx
rm -f ../fonts/ttf/*.ttx
rm -f ../fonts/variable/*gasp.ttf
rm -f ../fonts/ttf/*gasp.ttf

echo "Done"
