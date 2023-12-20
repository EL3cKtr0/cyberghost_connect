#/bin/bash

error_country_code() {
    echo "Error: country code can not be blank or doesn't exist!"
    exit 1
}

read -p "Select country code (cyberghost --country-code to see all):" COUNTRY_CODE

{
    if [[ -z $COUNTRY_CODE ]]; then
        error_country_code
    fi
    cyberghostvpn --country-code $COUNTRY_CODE 2>/dev/null
} || {
    error_country_code
}

echo ""
read -p "Select a City from avaiable:" CITY

if [[ $(cyberghostvpn --country-code $COUNTRY_CODE --city $CITY) && -n $CITY ]]; then
    SCRAPED_VALUES=$(cyberghostvpn --country-code $COUNTRY_CODE --city $CITY | sed '$ d' | sed '1,3d' | tr -d '|' | awk '{print $3,$4}' | sort -t' ' -k2 -n)
    
    SERVER=$(echo $SCRAPED_VALUES | awk '{print $1}')
   
else
    echo "Error, no City avaiable for the country code selected"
    exit 1
fi

echo "Try to connect to the best server ($SERVER)"

sudo cyberghostvpn --country-code $COUNTRY_CODE --city $CITY --server $SERVER --connect