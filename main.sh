#/bin/bash

error_country_code() {
    echo "Error: country code is blank or doesn't exist!"
    echo "Launch this bash command 'cyberghostvpn --country-code' to see all country codes avaiable"
    exit 1
}

read -p "Select country code (launch this bash command 'cyberghostvpn --country-code' to see all country codes avaiable): `echo $'\n> '`" COUNTRY_CODE

{
    if [[ -z $COUNTRY_CODE ]]; then
        error_country_code
    fi
    cyberghostvpn --traffic --country-code "$COUNTRY_CODE" 2>/dev/null
} || {
    error_country_code
}

echo ""
read -p "Select a City from avaiable (leave blank for automatic connection): `echo $'\n> '`" CITY

if [[ -z $CITY ]]; then
    sudo cyberghostvpn --traffic --country-code "$COUNTRY_CODE" --connect
else
    if [[ $(cyberghostvpn --traffic --country-code "$COUNTRY_CODE" --city "$CITY") ]]; then
        SCRAPED_VALUES=$(cyberghostvpn --traffic --country-code "$COUNTRY_CODE" --city "$CITY" | sed '$ d' | sed '1,3d' | tr -d '|' | awk '{print $(NF-1),$NF}' | sort -t' ' -k2 -n)
        
        SERVER=$(echo $SCRAPED_VALUES | awk '{print $1}')

        echo "Try to connect to the best server ($SERVER)"

        sudo cyberghostvpn --traffic --country-code "$COUNTRY_CODE" --city "$CITY" --server "$SERVER" --connect
    else
        echo "Error, no City avaiable for the country code selected"
        exit 1
    fi
fi
