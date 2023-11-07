while true
do
    date=$(date +'%A, %b %d')
    time=$(date +'%I%M %p')
    vol=$(pamixer --get-volume)
    echo "$date | $time | $vol"
    sleep 1
done
