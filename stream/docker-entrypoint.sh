#!/bin/ash

# Allow CTR-C to exit while loop
exit_func() {
        echo "SIGTERM detected"            
        exit 1
}
trap exit_func SIGTERM SIGINT

# If we are called with "stream" then run ffmpeg with 
# the command line options passed in $FFMPEG_CMD. We use
# "eval" here to be able to nest environment variables
# inside environment variables for a clean yet flexible
# docker-compose file.

if [ "$1" = "stream" ]; then
    ffmpeg_cmd=$(eval echo "$FFMPEG_CMD")
    echo "Command-line for ffmpeg from FFMPEG_CMD variable:"
    echo "  $ffmpeg_cmd"
    exec ffmpeg $ffmpeg_cmd
fi

exec "$@"

# End