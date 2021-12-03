#!/bin/bash 
read -p "~Enter the domain: " domain
echo -e "~\033[1mScaning for sub-domains...\033[0m"
mkdir $domain
search()
{
    assetfinder --subs-only $domain > tmp_sub.txt 
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
    rm tmp_sub.txt
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
    cp tmp_active.txt $domain/subdomains.txt
     
}
trash()
{
  rm tmp_active.txt
  rm tmp_alive.txt
  rm tmp_no_http.txt
}
search
total
live
remove
trash
