while true
do
    date=$(date +'%A, %b %d')
    time=$(date +'%I:%M:%S %p')
    vol=$(pamixer --get-volume)
    echo "$date | $time | ♪ $vol "
    sleep 0.30
done
