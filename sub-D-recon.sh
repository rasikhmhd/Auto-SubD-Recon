#!/bin/bash 
read -p "~Enter the domain: " domain
echo -e "~\033[1mScaning for sub-domains...\033[0m"
search()
{
    assetfinder $domain > tmp_sub.txt 
}
total()
{
    echo -e "~\033[1mTotal number of sub-domains is\033[0m"
    cat tmp_sub.txt | wc -l

}
live()
{
    echo -e "~\033[1mSearching for active sub domains....\033[0m"
    echo -e "~\033[1mSending HTTP/HTTPS requests..\033[0m"
    cat tmp_sub.txt | httprobe > tmp_alive.txt 
}
alive()
{
    echo -e "~\033[1Number of sub-domains which are alive is:\033[0m"
    cat tmp_alive.txt | wc -l 

}
remove()
{
    echo -e "~\033[1mFiltering sub-domains...\033[0m"
    filename="tmp_alive.txt"
    while read -r line; do
        dom="$line"
        echo "$dom" | sed 's/https\?:\/\///' >> tmp_no_http.txt 
    done < "$filename" 
    echo -e "~\033[1mThe filtered Active sub-domains are..\033[0m"
    sort tmp_no_http.txt | uniq | tee tmp_active.txt
    echo  -e "~\033[1mNumber  of Active subdomains are\033[0m"
     cat tmp_active.txt | wc -l 
    exit
     
}
  
trash1()
{
    if [ -f tmp_no_http.txt ]; then
    rm tmp_no_http.txt
    fi
    if [ -f tmp_active.txt ]; then
    rm tmp_active.txt
    fi
}

trash2()
{
    rm tmp_sub.txt
    rm tmp_alive.txt

}
trash1
search
total
live
alive
remove
trash2
