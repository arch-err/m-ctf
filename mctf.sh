#!/usr/bin/env bash
#!CMD: ./mctf.sh test
#!CMD: ./mctf.sh solve
#!CMD: ./mctf.sh init

# Description:
# Author:

# Dependencies:
#  - fzf
#  - yq
#  - sed
#  - grep
#  - git
#  - gh (github cli)
#  - gomplate
#  - <++>
#  - <++>


TEMPLATE_NAME="ctf-template"
GITHUB_USERNAME=$(gh auth status | grep "Logged in" | cut -d " " -f9)
SEP='\e[38;5;244m───────────────────────────────────────────────────\e[0m'

set -e

# Arguments message
function error() {
    local message="$1"
    printf "\e[0;31m$message\e[0;37m\n" >&2
}

# Arguments message
function warn() {
    local message="$1"
    printf "\e[0;38;5;215m$message\e[0;37m\n" >&2
}

# Arguments message
function success() {
    local message="$1"
    printf "\e[0;38;5;2m$message\e[0;37m\n"
}

# Arguments none
function show_help() {
    echo "Usage:"
    echo "	$0 <COMMAND> [<OPTIONS>]"
    echo ""
    echo "Script version: ${SCRIPT_VERSION}"
    echo ""
    echo " COMMAND                     OPTIONS                            DESCRIPTION"
    echo "--------------------------------------------------------------------------------------------------------------------------------"
    echo " init                                                           Initialize a new CTF"

}

# Arguments none
function print_header() {
	printf "
    [38;2;0;255;125m█[38;2;1;251;128m█[38;2;2;247;131m█[38;2;3;243;134m╗   [38;2;8;228;147m█[38;2;9;224;150m█[38;2;10;220;153m█[38;2;12;217;156m╗       [38;2;21;186;182m█[38;2;23;183;185m█[38;2;24;179;188m█[38;2;25;175;191m█[38;2;26;171;194m█[38;2;28;168;197m█[38;2;29;164;201m╗[38;2;30;160;204m█[38;2;31;156;207m█[38;2;32;152;210m█[38;2;34;149;213m█[38;2;35;145;216m█[38;2;36;141;220m█[38;2;37;137;223m█[38;2;39;134;226m█[38;2;40;130;229m╗[38;2;41;126;232m█[38;2;42;122;235m█[38;2;43;118;239m█[38;2;45;115;242m█[38;2;46;111;245m█[38;2;47;107;248m█[38;2;48;103;251m█[38;2;50;100;255m╗[0m
    [38;2;7;232;143m████╗ [38;2;7;232;144m█[38;2;8;228;147m█[38;2;9;224;150m█[38;2;10;220;153m█[38;2;12;217;156m║      [38;2;20;190;178m█[38;2;21;186;182m█[38;2;23;183;185m╔[38;2;24;179;188m═[38;2;25;175;191m═[38;2;26;171;194m═[38;2;28;168;197m═[38;2;29;164;201m╝[38;2;30;160;204m╚[38;2;31;156;207m═[38;2;32;152;210m═[38;2;34;149;213m█[38;2;35;145;216m█[38;2;36;141;220m╔[38;2;37;137;223m═[38;2;39;134;226m═[38;2;40;130;229m╝[38;2;41;126;232m█[38;2;42;122;235m█[38;2;43;118;239m╔[38;2;45;115;242m═[38;2;46;111;245m═[38;2;47;107;248m═[38;2;48;103;251m═[38;2;50;100;255m╝[0m
    [38;2;14;210;162m██╔████╔██║█[38;2;14;209;163m█[38;2;15;205;166m█[38;2;17;202;169m█[38;2;18;198;172m█[38;2;19;194;175m╗[38;2;20;190;178m█[38;2;21;186;182m█[38;2;23;183;185m║        [38;2;34;149;213m█[38;2;35;145;216m█[38;2;36;141;220m║   [38;2;41;126;232m█[38;2;42;122;235m█[38;2;43;118;239m█[38;2;45;115;242m█[38;2;46;111;245m█[38;2;47;107;248m╗  [0m
    [38;2;21;188;180m██║╚██╔╝██║╚════╝█[38;2;21;186;182m█[38;2;23;183;185m║        [38;2;34;149;213m█[38;2;35;145;216m█[38;2;36;141;220m║   [38;2;41;126;232m█[38;2;42;122;235m█[38;2;43;118;239m╔[38;2;45;115;242m═[38;2;46;111;245m═[38;2;47;107;248m╝  [0m
    [38;2;28;166;199m██║ ╚═╝ ██║      ╚██████[38;2;29;164;201m╗   [38;2;34;149;213m█[38;2;35;145;216m█[38;2;36;141;220m║   [38;2;41;126;232m█[38;2;42;122;235m█[38;2;43;118;239m║     [0m
    [38;2;35;144;217m╚═╝     ╚═╝       ╚═════╝   ╚═[38;2;36;141;220m╝   [38;2;41;126;232m╚[38;2;42;122;235m═[38;2;43;118;239m╝     [0m
                                              [0m
    \e[0m \n"

	printf "     Managed CTFs  Created by @arch-err \n\n"
}

# Arguments none
function testing() {
	pushd TestCTF >/dev/null
	# bulk_init_challenges
	# print_header
	# new_challenge "test"
	get_username
	popd >/dev/null
}

# Arguments name description
function new_challenge() {
	local name=$1
	local description=$2

	# yq e -i ".challenges += [{"name": "${name}", "description": "${description}"}]" "ctf.yaml"
	yq -e -i ".challenges += [{\"name\": \"${name}\"}]" "ctf.yaml"

	pushd challenges >/dev/null

	mkdir "${name}"
	pushd ${name} >/dev/null

	echo "#!/usr/bin/env bash
#!CMD: ./solve.sh
<++>" >> solve.sh

	echo "# ${name}
*<++>*

## Solution
1. <++>
2. \`<++>\`
3. \`./solve.sh\`


## Flag
**Flag:** \`<++>\`" >> README.md

	mkdir original_files

	popd >/dev/null

	popd >/dev/null

	echo "- [ ] ${name}" >> README.md

	printf "\e[38;5;240m ◦ Creating files in \e[38;5;244mchallenges/${name} \e[38;5;28m ✓\e[0m\n"

}

# Arguments none
function init() {
	print_header

	printf "\n${SEP}\n\n"

    get_username
    get_team

	if test -z "$CTF_NAME"; then
		printf "\e[38;5;244mCTF Name: \e[38;5;43m"
	    read CTF_NAME
		printf "\e[0m"
	fi
	if test -z "$CTF_DESCRIPTION"; then
		printf "\e[38;5;244mCTF Description: \e[0m\n"
	    read CTF_DESCRIPTION
	fi
	if test -z "$CTF_URL"; then
		printf "\e[38;5;244mCTF Upstream URL: \e[38;5;43m"
	    read CTF_URL
		printf "\e[0m"
	fi


	### Initialize Repo


	printf "\n${SEP}\n\n"


	CTF_NAME=$(echo $CTF_NAME | sed "s/ /-/g")

	gh repo create "$CTF_NAME" \
		--template "$TEMPLATE_NAME" \
		--private
	sleep 1

	REPO_URL=git@github.com:${GITHUB_USERNAME}/${CTF_NAME}.git

	echo ""
	printf "\e[38;5;240m"
	git clone $REPO_URL
	printf "\e[0m"

	printf "\n${SEP}\n\n"


	### Initialize ctf.yaml

	pushd $CTF_NAME >/dev/null

	export CTF_NAME
	export CTF_USERNAME
	export CTF_TEAM
	export CTF_DESCRIPTION
	export CTF_URL
	export REPO_URL
	export CTF_ROOT_DIR="$(pwd)"
	export MCTF_ROOT_DIR="${CTF_ROOT_DIR}"

	gomplate -f ctf.yaml > .tmp_ctf.yaml
	mv .tmp_ctf.yaml ctf.yaml

	printf "\e[38;5;240m ◦ Initializing \e[38;5;244mctf.yaml \e[38;5;28m ✓\e[0m\n"

	setup_direnv

	init_readme

	bulk_init_challenges



	popd >/dev/null
}

# Arguments none
function bulk_init_challenges() {
	### Init challenges in bulk

	echo "# Paste newline separated list of challenge-names in this file" > .challenges.txt

	$EDITOR .challenges.txt

	echo ""

	i=0

	for challenge in $(grep -Pv "^#" .challenges.txt)
	do
		new_challenge "${challenge}"
		i=$((i+1))
	done

	sed -i "s/\(.*Flags.*\/\)X/\1${i}/" README.md

	rm .challenges.txt
}

# Arguments none
function get_username() {
	printf "\e[38;5;244mUsername: \e[38;5;43m"
	read -e -i "${MCTF_USERNAME}" CTF_USERNAME
	printf "\e[0m"
}
function get_team() {
	printf "\e[38;5;244mTeam: \e[38;5;43m"
	read -e -i "${MCTF_TEAM}" CTF_TEAM
	printf "\e[0m"
}

# Arguments none
function init_readme() {
	gomplate -f README.md -d values=./ctf.yaml > .README.md
	mv .README.md README.md

	echo ""
	printf "\e[38;5;240m ◦ Initializing \e[38;5;244mREADME.md \e[38;5;28m ✓\e[0m\n"
}

# Arguments none
function setup_direnv() {
	touch .envrc

	echo "export MCTF_USERNAME=${CTF_USERNAME}" >> .envrc
	echo "export MCTF_TEAM=${CTF_USERNAME}" >> .envrc
	echo "export MCTF_CURRENT=${CTF_NAME}" >> .envrc
	echo "export MCTF_ROOT_DIR=\"${CTF_ROOT_DIR}\"" >> .envrc

	echo ""
	printf "\e[38;5;240m ◦ Setting up direnv \e[38;5;28m ✓\e[0m\n"
}

# Arguments challenge_name
function solve_challenge() {
	pushd "${MCTF_ROOT_DIR}" >/dev/null


	challenges=$(grep -P "\- \[ \]" README.md | sed "s/^\- \[ \] //")
	for c in ${challenges}
	do
		if ! ls "challenges/${c}" &>/dev/null; then
			challenges=$(echo ${challenges} | sed "s/${c}//")
		fi
	done


	chal=$(echo "${challenges}" | sed "s/^ //; s/ /\n/g" | fzf --height 15 --reverse --prompt "Challenge: ")

	sed -i "s/- \[ \] ${chal}/- \[x\] ${chal}/" README.md
	curr_solved_count=$(grep "\*\*Flags:\*\* (" README.md | sed 's/.*(\([0-9]\+\)\/.*/\1/')
	new_solved_count=$(( curr_solved_count + 1 ))

	sed -i "s/\(.*Flags.*(\)${curr_solved_count}/\1${new_solved_count}/" README.md


	# $EDITOR "challenges/${chal}/README.md"


	popd >/dev/null
}


## -allow a command to fail with !’s side effect on errexit
# -use return value from ${PIPESTATUS[0]}, because ! hosed $?
! getopt --test > /dev/null
if [[ ${PIPESTATUS[0]} -ne 4 ]]; then
    echo 'I’m sorry, `getopt --test` failed in this environment.'
    exit 1
fi

OPTIONS=h
LONGOPTS=help

# -regarding ! and PIPESTATUS see above
# -temporarily store output to be able to check for errors
# -activate quoting/enhanced mode (e.g. by writing out “--options”)
# -pass arguments only via	 -- "$@"   to separate them correctly
! PARSED=$(getopt --options=$OPTIONS --longoptions=$LONGOPTS --name "$0" -- "$@")
if [[ ${PIPESTATUS[0]} -ne 0 ]]; then
    # e.g. return value is 1
    #  then getopt has complained about wrong arguments to stdout
    exit 2
fi
# read getopt’s output this way to handle the quoting right:
eval set -- "$PARSED"

# now enjoy the options in order and nicely split until we see --
while true; do
    case "$1" in
        -h|--help)
            show_help
            exit 1
            ;;
        --)
            shift
            break
            ;;
        *)
            echo "'$1' is not a valid command/option. See '$0 --help' for available commands and options."
            exit 3
            ;;
    esac
done

# handle non-option arguments
if [[ $# -ne 1 ]]; then
    echo "$0: A command is required."
    echo ""
    show_help
    exit 4
fi
COMMAND="$1"

case "$COMMAND" in
    init)
        init
        ;;
    test)
        testing
        ;;
	solve)
		solve_challenge
		;;
	add)
		add_challenge
		;;
	status)
		status
		;;
	unsolve)
		unsolve_challenge
		;;
    *)
        echo "Unknown command"
        show_help
        exit 4
        ;;
esac
exit 0