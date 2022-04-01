#!/usr/bin/env bash
# https://stackoverflow.com/questions/40865597/generate-changelog-from-commit-and-tag


TAG=;
BASEURL=;

function buildMd() {
    
    local previous_tag=0;
    local last_tag=${TAG};
    local baseUrl=${BASEURL};

    for current_tag in $(git tag --sort=-creatordate) 0; do

        [ ${current_tag} == "0" ] && current_tag=;

        [ "$previous_tag" != 0 ] && {
            tag_date=$(git log -1 --pretty=format:'%ad' --date=short ${previous_tag});
            printf "## ${previous_tag} (${tag_date})\n\n";
            url=$( git config --get remote.origin.url | sed 's/\/\/.*@/\/\//;s/.git/\/commits\//'  );
            
            [ ! -z "${baseUrl}" ] && {
                git log ${current_tag}...${previous_tag} --pretty=format:"* %s [View](${url}%H)" --reverse | grep -v Merge | sed "s/[#]*\([A-Z]\{1,5\}-[0-9]\{1,5\}\)[ ]*/[#\1](${baseUrl//\//\\\/}\1) /g";
            } || {
                git log ${current_tag}...${previous_tag} --pretty=format:"* %s [View](${url}%H)" --reverse | grep -v Merge;
            }
            
            printf "\n\n";
            [ -z "${last_tag}" ] && break;
        }
        
        previous_tag=${current_tag};

        [ ! -z "${last_tag}" ] && [ "${previous_tag}" == "${last_tag}" ] && break;
    done
}

function usage() {
    echo "Use: changelog <options>";
    echo;
    echo "     options";
    echo "     -i, --issue-base-url  : issue tracker base url";
    echo "     -t, --start-tag       : initial tag";
    echo "     -h, --help            : this message";
}

function main() {
    set -- ${*//--issue-base-url/-I};
    set -- ${*//--start-tag/-t};
    set -- ${*//--help/-h};

    local opt=;
    local tag=;
    local baseurl=;

    while getopts hI:t: opt 2>/dev/null ; do
    
        case ${opt} in
            h) usage; exit 1;;
            I) BASEURL=${OPTARG};;
            t) TAG=${OPTARG};;
        esac
        
    done

    buildMd;
}

main ${@};