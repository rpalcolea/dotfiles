#!/bin/sh

NEBULA_ORG=nebula-plugins
BASE_FOLDER=~/Projects/github
NEBULA_REPOS=('nebula-dependency-recommender-plugin' 'gradle-nebula-integration' 'gradle-ospackage-plugin' 'nebula-docker-plugin' 'gradle-java-cross-compile-plugin' 'gradle-override-plugin' 'nebula-hollow-plugin' 'gradle-extra-configurations-plugin' 'gradle-info-plugin' 'gradle-scm-plugin' 'gradle-lint-plugin' 'nebula-publishing-plugin' 'nebula-plugin-plugin' 'nebula-dependency-base-plugin' 'gradle-metrics-plugin' 'nebula-release-plugin' 'nebula-project-plugin' 'nebula-test' 'nebula-bintray-plugin' 'gradle-stash-plugin' 'gradle-netflixoss-project-plugin' 'gradle-resolution-rules' 'nebula-grails-plugin' 'nebula-clojure-plugin' 'nebula-kotlin-plugin' 'nebula-gradle-interop' 'gradle-dependency-lock-plugin' 'gradle-contacts-plugin' 'gradle-git-scm-plugin' 'gradle-resolution-rules-plugin' 'lock-experimental' 'investigate-insight' 'gradle-aggregate-javadocs-plugin' 'nebula-core')

gh_help(){
    echo "Usage: gh <subcommand> [options]\n"
    echo "Subcommands:"
    echo "    browse   Open a GitHub project page in the default browser"
    echo "    cd       Go to the directory of the specified repository"
    echo "    clone    Clone a remote repository"
    echo ""
    echo "For help with each subcommand run:"
    echo "gh <subcommand> -h|--help"
    echo ""
}

gh_browse() {
    open `git remote -v | awk '/fetch/{print $2}' | sed -Ee 's#(git@|git://)#http://#' -e 's@com:@com/@'`| head -n1
}

gh_clone_nebula() {
    echo "Cloning nebula-plugins repos"
    for i in $NEBULA_REPOS; do
      gh_clone "$NEBULA_ORG/$i"
    done
}

gh_clone() {
    git clone "ssh://git@github.com/$1.git" $BASE_FOLDER/$1
    gh_cd "$1"
}

gh_cd() {
    cd ~/Projects/github/$1
}

gh() {
    subcommand=$1
    case $subcommand in
        "" | "-h" | "--help")
            gh_help
            ;;
        *)
            shift
            gh_${subcommand} $@
            if [ $? = 127 ]; then
                echo "Error: '$subcommand' is not a known subcommand." >&2
                echo "       Run 'ghs --help' for a list of known subcommands." >&2
                return 1
            fi
            ;;
    esac
}

compdef '_files -W ~/Projects/github' gh
