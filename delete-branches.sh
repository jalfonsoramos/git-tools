#!/bin/bash

branches=()
yesAll=false

for branch in $(git for-each-ref --format='%(refname:strip=3)' refs/remotes/ | grep "^$1") ; do
    if [[ "$(git log origin/$branch --since "4 months ago" | wc -l)" -eq 0 ]]; then
        git log -1 -s origin/"$branch" --date=relative
        echo
        if [ "$yesAll" = false ] ; then
            read -p "Do you want to delete: $branch? (y/n/a) " answer 
        fi 
        if [ "$answer" = "y" ] || [ "$answer" = "a" ] || [ "$yesAll" = true ] ; then
            branches+=($branch)
            if [ "$answer" = "a" ]; then
                yesAll=true;
            fi
        fi
    fi
done

if [ ${#branches[@]} -gt 0 ] ; then
    read -p "Do you want to delete ${#branches[@]} branches? (y/n) " answer
    if [ "$answer" = "y" ] ; then
        for branch in "${branches[@]}" ; do
            echo Deleting branch $branch            
            git push origin --delete "$branch" --no-verify
        done
    fi
else
    echo No branches found.
fi

# TO-DO-LIST
# [ ] Add date filter parameter
# [ ] Add dry-run parameter
# [ ] Save preview to file