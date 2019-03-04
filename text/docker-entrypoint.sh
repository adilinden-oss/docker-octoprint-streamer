#!/bin/ash

# Running system
octopi_api_key="$OCTPPI_API_KEY"
octopi_url="$OCTOPI_URL"

# How often to poll the API
SLEEP_SEC=10

# Setup files
echo "" > /text/printer.txt
echo "" > /text/job.txt

# Setup vars
last_filename=""
celsius=$'\xc2\xb0'C

# Allow CTR-C to exit while loop
exit_func() {
        echo "SIGTERM detected"            
        exit 1
}
trap exit_func SIGTERM SIGINT

# Obtain the current status from the OctoPi API
function get_status {
    # Reset all vars
    octopi_state=""
    octopi_bed_actual=""
    octopi_bed_target=""
    octopi_tool_actual=""
    octopi_tool_target=""
    octopi_filename=""
    octopi_completion=""

    # Make sure we can connect to OctoPi with URL and API key. This should 
    # return valid JSON. If not, then jq will thow an error and we won't
    # proceed.
    curl -s -H "X-Api-Key: $octopi_api_key" "${octopi_url}/api/connection" | jq -e >/dev/null 2>&1
    ret=$?
    if [ $? -eq 0 ]; then
        # Connection state
        octopi_state=$(curl -s -H "X-Api-Key: $octopi_api_key" "${octopi_url}/api/connection" | jq -r ".current.state")

        # Printer status only relevan if "Operational"
        if [ "$octopi_state" = "Operational" -o "$octopi_state" = "Printing" -o "$octopi_state" = "Cancelling" ]; then

            # Bed temperature
            octopi_bed_actual=$(curl -s -H "X-Api-Key: $octopi_api_key" "${octopi_url}/api/printer" | jq -r ".temperature.bed.actual")
            octopi_bed_target=$(curl -s -H "X-Api-Key: $octopi_api_key" "${octopi_url}/api/printer" | jq -r ".temperature.bed.target")

            # Bed temperature
            octopi_tool_actual=$(curl -s -H "X-Api-Key: $octopi_api_key" "${octopi_url}/api/printer" | jq -r ".temperature.tool0.actual")
            octopi_tool_target=$(curl -s -H "X-Api-Key: $octopi_api_key" "${octopi_url}/api/printer" | jq -r ".temperature.tool0.target")

            # Update job status if printing
            if [ "$octopi_state" = "Printing" ]; then

                # Current job file name
                octopi_filename=$(curl -s -H "X-Api-Key: $octopi_api_key" "${octopi_url}/api/job" | jq -r ".job.file.name")
                last_filename="$octopi_filename"

                # Current job progress
                octopi_completion=$(curl -s -H "X-Api-Key: $octopi_api_key" "${octopi_url}/api/job" | jq -r ".progress.completion")
                if ! echo "$octopi_completion" | egrep -q '^[0-9]+([.][0-9]+)?$'; then
                    octopi_completion=0
                fi
                str_percentage=$(printf " (%.*f%%)" 2 "$octopi_completion")

                # Update job status
                echo -e "Job: ${octopi_filename} ${str_percentage}" > /text/job.txt
            else
                if [ -n "$last_filename" ]; then
                    # Update job status
                    echo -e "Last Job: ${last_filename}" > /text/job.txt
                fi
            fi

            # Update printer status
            echo -e "Status: $octopi_state - Tool: ${octopi_tool_actual}${celsius}/${octopi_tool_target}${celsius} - Bed: ${octopi_bed_actual}${celsius}/${octopi_bed_target}${celsius}" > /text/printer.txt
        else
            # Update status
            echo "Status: Not Connected" > /text/printer.txt
        fi
    else
        # Update status
        echo "Status: API Query Failure" > /text/printer.txt
    fi

    # Create debug data
    debug="Connection State: $octopi_state\n"
    debug="${debug}Bed Actual: $octopi_bed_actual\n"
    debug="${debug}Bed Target: $octopi_bed_target\n"
    debug="${debug}Tool0 Actual: $octopi_tool_actual\n"
    debug="${debug}Tool0 Target: $octopi_tool_target\n"
    debug="${debug}Job Filename: $octopi_filename\n"
    debug="${debug}Job Progress: $octopi_completion\n"
    debug="${debug}"$(cat /text/printer.txt)"\n"
    debug="${debug}"$(cat /text/job.txt)"\n"
}


# Allow commands other than default to be run
case "$1" in
    "do")
        while "true"; do
            # Get status from OctoPi API
            get_status

            # Pace ourselves
            sleep $SLEEP_SEC
        done
        ;;

    "debug")
        while "true"; do
            # Get status from OctoPi API
            get_status

            # Dump debug data to stdout
            echo -e "$debug"

            # Pace ourselves
            sleep $SLEEP_SEC
        done
        ;;

    *)
        exec "$@"
        ;;
esac

# End