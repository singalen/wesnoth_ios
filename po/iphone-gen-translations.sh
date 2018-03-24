
LANGS=$(cd wesnoth && ls *.po | cut -d . -f 1)
#echo ${LANGS}
DOMAINS=$(find . -type d -mindepth 1 -maxdepth 1 -exec basename {} +)
#echo ${DOMAINS}

for DOMAIN in ${DOMAINS}; do
	for LANG in ${LANGS}; do
		TARGET="../res-iphone/translations/${LANG}/LC_MESSAGES/"
		mkdir -p "${TARGET}"

		echo msgfmt "${DOMAIN}/${LANG}.po" -o "${TARGET}/${DOMAIN}.mo"
		msgfmt "${DOMAIN}/${LANG}.po" -o "${TARGET}/${DOMAIN}.mo"
	done
done
