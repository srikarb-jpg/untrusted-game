# collecting jsx filenames in a directory and write them to $target.
target=$1
mod=$2
# "default" is the levels/ folder itself (upstream uses a symlink, which breaks on Windows)
if [ "$mod" = "default" ]; then dir=levels; else dir=mods/$mod; fi

# MOD
[ "$mod" != "default" ] && m=$mod
sed -i -e "s#\/\/%MOD%#$m#" $target

# LEVELS
levels=''
for lvl in $dir/*.jsx
do
	lvl=`basename $lvl`
	levels=`printf "$levels'%s'," $lvl`
done
levels="${levels%?}"
sed -i -e "s#\/\/%LEVELS%#$levels#g" $target

# BONUS
bonus=''
if [ -d $dir/bonus ]; then
	for lvl in $dir/bonus/*.jsx
	do
		lvl=`basename $lvl`
		bonus=`printf "$bonus'%s'," $lvl`
	done
fi
bonus="${bonus%?}"
sed -i -e "s#\/\/%BONUS%#$bonus#" $target
