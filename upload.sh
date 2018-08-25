mypath=${PWD} #folder name

rm -r tmp

for x in $(ls -d */)
do
  cd $mypath
  cd $x
  folder = ${PWD##*/}
  ./upload.sh
  echo "$folder"
done

