#!/usr/bin/env bash
# Copyright 2019-2020 (c) all rights reserved by S D Rausty; see LICENSE
# https://sdrausty.github.io hosted courtesy https://pages.github.com
# To create checksum files and commit use; ./do.sums.bash
# To see file tree use; awk '{print $2}' sha512.sum
# To check the files use; sha512sum -c sha512.sum
#####################################################################
set -euo pipefail
printf "%s\\n" "Creating checksum file and pushing commit from directory ${PWD##*/} : "
_GITCOMMIT_() {
	git commit -m "$SN" || (printf "%s\\n" "Cannot git commit from directory ${PWD##*/} : EXITING... : " && exit)
}

_GITCOMMITS_() {
	git commit -a -S -m "$SN" && pkill gpg-agent || (printf "%s\\n" "Cannot git commit from directory ${PWD##*/} : EXITING... : " && exit)
}

_GITPUSH_() {
	pwd
	git push || git push --set-upstream origin master || (printf "%s\\n" "Cannot git push from directory ${PWD##*/} : EXITING... : " && exit)
}
MTIME="$(ls -l --time-style=+"%s" .git/ORIG_HEAD 2>/dev/null | awk '{print $6}')" || MTIME=""
TIME="$(date +%s)"
([[ ! -z "${MTIME##*[!0-9]*}" ]]&&([[ $(($TIME - $MTIME)) -gt 43200 ]]&&git pull --ff-only)||git pull --ff-only)||(printf "%s\\n" "Signal generated at [ ! -z \${num##*[!0-9]*} ]"&&git pull --ff-only)
rm -f *.sum
.scripts/maintenance/vgen.sh
# query .gitmodules file and find paths to submodules
[[ -f .gitmodules ]] && GMODSLST="$(grep path .gitmodules | sed 's/path = //g')" || GMODSLST=""
GIMODS=""
SMDRE=""
# build directory exclusion string
for SMDRE in $GMODSLST
do
    	SMDRE="$(grep -v ".scripts" <<< $SMDRE)" ||:
    	[[ ! -z ${SMDRE:-} ]] && GIMODS+="-or -name $SMDRE "
done
# checksums will be created for these files
FINDLST="$(find . \( -type d \( -name .git -or -name .scripts $GIMODS \) -prune \) -or \( -type f -print \))"
# checksum file types to be created
CHECKLIST=(sha512sum) # md5sum sha1sum sha224sum sha256sum sha384sum
for SCHECK in "${CHECKLIST[@]}"
do
	printf "%s\\n" "Creating $SCHECK file..."
	for FILE in $FINDLST
	do
		$SCHECK "$FILE" >> ${SCHECK::-3}.sum
	done
done
chmod 400 ${SCHECK::-3}.sum
for SCHECK in  ${CHECKLIST[@]}
do
	printf "%s\\n" "Checking $SCHECK..."
	$SCHECK -c ${SCHECK::-3}.sum
done
git add . || (printf "%s\\n" "Cannot git add in directory ${PWD##*/} : EXITING... : " && exit)
WPWD="$PWD"
_IFBINEXT_() {
	[ -d "$HOME/bin" ] && cd "$HOME/bin" && curl -OL https://raw.githubusercontent.com/BuildAPKs/maintenance.BuildAPKs/master/sn.sh && chmod 700 sn.sh ; cd "$WPWD"
}
SCMD="sn.sh"
command -v $SCMD || printf "\\e[1;38;5;124mCommand \\e[1;38;5;148m%s\\e[1;38;5;124m not found: \\e[1;38;5;150mContinuing...\\n" "'$SCMD'" && _IFBINEXT_ ; printf "\\e[0m"
SN="$(sn.sh)" # sn.sh is found at https://github.com/BuildAPKs/maintenance.BuildAPKs/blob/master/sn.sh
([[ -z "${1:-}" ]]&&_GITCOMMIT_&&_GITPUSH_)||([[ "${1//-}" == [Ss]* ]]&&_GITCOMMITS_&&_GITPUSH_)||(_GITCOMMIT_&&_GITPUSH_)||printf "%s\\n" "Cannot git commit in directory ${PWD##*/} : Continuing..."
ls
[ -f .conf/VERSIONID ]&&cat .conf/VERSIONID
printf "%s\\n" "$PWD"
printf "%s\\n" "Creating checksum file and pushing commit from directory ${PWD##*/} : DONE"
# do.sums.bash EOF
