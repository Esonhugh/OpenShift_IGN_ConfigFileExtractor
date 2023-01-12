#!/bin/sh

export FILENAME="ign_bootstrap.json"
export RESULT="configs.mixed"

export CONFIG_WITH_BASE64_URL_FORMAT=configs.base64
export CONFIG_WITH_BASE64_EACH_LINE=configs.eachline.base64

jqed_jsonfile() {
    cat $FILENAME|jq '.storage.files[]'|jq '.contents.source' > $CONFIG_WITH_BASE64_URL_FORMAT
}

parse_jsons() {
    cat $CONFIG_WITH_BASE64_URL_FORMAT|cut -d ',' -f 2 |sed -e "s/\"//g" > $CONFIG_WITH_BASE64_EACH_LINE
}

banners() {
    echo "===============[CONFIG]================"
}

parse_base64() {
    while read line; do
        # if line is empty then skip
        if [ -z "$line" ]; then
            continue
        fi
        banners >> $RESULT
        echo $line|base64 -d >> $RESULT
    done < $CONFIG_WITH_BASE64_EACH_LINE 
}

clean_up() {
    rm $CONFIG_WITH_BASE64_URL_FORMAT $CONFIG_WITH_BASE64_EACH_LINE
}

if [ -f $FILENAME ]; then
    jqed_jsonfile
    parse_jsons
    parse_base64
    clean_up
else
    echo "File not specificed or not found."
fi

