# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

# @ECLASS: prefix.eclass
# @MAINTAINER:
# Feel free to contact the Prefix team through <prefix@gentoo.org> if
# you have problems, suggestions or questions.
# @BLURB: Eclass to provide Prefix functionality
# @DESCRIPTION:
# Gentoo Prefix allows users to install into a self defined offset
# located somewhere in the filesystem.  Prefix ebuilds require
# additional functions and variables which are defined by this eclass.

# @ECLASS-VARIABLE: EPREFIX
# @DESCRIPTION:
# The offset prefix of a Gentoo Prefix installation.  When Gentoo Prefix
# is not used, ${EPREFIX} should be "".  Prefix Portage sets EPREFIX,
# hence this eclass has nothing to do here in that case.
# Note that setting EPREFIX in the environment with Prefix Portage sets
# Portage into cross-prefix mode.
if [[ ! ${EPREFIX+set} ]]; then
	export EPREFIX=''
fi


# @FUNCTION: eprefixify
# @USAGE: <list of to be eprefixified files>
# @DESCRIPTION:
# Replaces @GENTOO_PORTAGE_EPREFIX@ with ${EPREFIX} for the given files,
# Dies if no arguments are given, a file does not exist, or changing a
# file failed.
eprefixify() {
	[[ $# -lt 1 ]] && die "at least one file operand is required"
	einfo "Adjusting to prefix ${EPREFIX:-/}"
	local x
	for x in "$@" ; do
		if [[ -e ${x} ]] ; then
			ebegin "  ${x##*/}"
			sed -i -e "s|@GENTOO_PORTAGE_EPREFIX@|${EPREFIX}|g" "${x}"
			eend $? || die "failed to eprefixify ${x}"
		else
			die "${x} does not exist"
		fi
	done

	return 0
}

# @FUNCTION: hprefixify
# @USAGE: [ -w <line matching regex> ] [-e <extended regex>] <list of files>
# @DESCRIPTION:
#
# Tries a set of heuristics to prefixify the given files, Dies if no
# arguments are given, a file does not exist, or changing a file failed.
#
# Additional extended regular expression can be passed by -e or
# environment variable PREFIX_EXTRA_REGEX.  The default heuristics can
# be constrained to lines matching regular expressions passed by -w or
# environment variable PREFIX_LINE_MATCH.
hprefixify() {
	local PREFIX_EXTRA_REGEX PREFIX_LINE_MATCH xl=() x
	while [[ $# -gt 0 ]]; do
		case $1 in
			-e)
				PREFIX_EXTRA_REGEX="$2"
				shift
				;;
			-w)
				PREFIX_LINE_MATCHING="$2"
				shift
				;;
			*)
				xl+=( "$1" )
				;;
		esac
		shift
	done

	[[ ${#xl[@]} -lt 1 ]] && die "at least one file operand is required"
	einfo "Adjusting to prefix ${EPREFIX:-/}"
	for x in "${xl[@]}" ; do
		if [[ -e ${x} ]] ; then
			ebegin "  ${x##*/}"
			sed -r \
				-e "${PREFIX_LINE_MATCH}s,([^[:alnum:]}\)\.])/(usr|lib(|[onx]?32|n?64)|etc|bin|sbin|var|opt),\1${EPREFIX}/\2,g" \
				-e "${PREFIX_EXTRA_REGEX}" \
				-i "${x}"
			eend $? || die "failed to prefixify ${x}"
		else
			die "${x} does not exist"
		fi
	done
}

# @FUNCTION: __temp_prefixify
# @USAGE: a single file. Internal use only.
# @DESCRIPTION:
# copies the files to ${T}, calls eprefixify, echos the new file.
__temp_prefixify() {
	if [[ -e $1 ]] ; then
		local f=${1##*/}
		cp "$1" "${T}" || die "failed to copy file"
		local x="${T}"/${f}
		if grep -qs @GENTOO_PORTAGE_EPREFIX@ "${x}" ; then
			eprefixify "${T}"/${f} > /dev/null
		else
			hprefixify "${T}"/${f} > /dev/null
		fi
		echo "${x}"
	else
		die "$1 does not exist"
	fi
}

# @FUNCTION: fprefixify
# @USAGE: <function> <files>
# @DESCRIPTION:
# prefixify a function call.
# copies the files to ${T}, calls eprefixify, and calls the function.
# @EXAMPLE:
# fprefixify doexe ${FILESDIR}/fix_libtool_files.sh
# fprefixify epatch ${FILESDIR}/${PN}-4.0.2-path.patch
fprefixify() {
	[[ $# -lt 2 ]] && die "at least two arguments required"

	local func=$1 f
	einfo "Adjusting ${func} to prefix ${EPREFIX:-/}"
	shift
	case ${func} in
		new*)
			[[ $# -ne 2 ]] && die "${func} takes two arguments"
			ebegin "  ${1##*/}"
			f=$(__temp_prefixify "$1")
			${func} "${f}" "$2"
			eend $? || die "failed to execute ${func}"
			;;
		*)
			for x in "$@" ; do
				ebegin "  ${x##*/}"
				f=$(__temp_prefixify "${x}")
				${func} "${f}"
				eend $? || die "failed to execute ${func}"
			done
			;;
	esac

	return 0
}

# vim: tw=72:
