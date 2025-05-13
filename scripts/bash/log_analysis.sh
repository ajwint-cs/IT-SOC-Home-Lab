!/bin/bash
#
# log_analysis.sh - Comprehensive automated malware analysis script
# For use in REMnux malware analysis environment
#
# Version: 1.0
# Last Updated: 2025-05-10

# Color definitions for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Default variables
OUTPUT_DIR="$HOME/malware/reports/$(date +%Y%m%d_%H%M%S)"
PCAP_FILE="$OUTPUT_DIR/network_capture.pcap"
SAMPLE_PATH=""
CAPTURE_NETWORK=false
MEMORY_ANALYSIS=false
TIMEOUT=300 # 5 minutes default analysis time

# Banner display
function show_banner {
    echo -e "${BLUE}"
    echo "=========================================================="
    echo "       AUTOMATED MALWARE ANALYSIS TOOLKIT                 "
    echo "       REMnux Environment - IT-SOC Home Lab               "
    echo "=========================================================="
    echo -e "${NC}"
}

# Usage information
function show_usage {
    echo -e "\n${YELLOW}Usage:${NC}"
    echo -e "  $0 -f <malware_file> [options]"
    echo -e "\n${YELLOW}Options:${NC}"
    echo "  -f <file>      Path to malware sample"
    echo "  -o <directory> Custom output directory (default: ~/malware/reports/YYYYMMDD_HHMMSS)"
    echo "  -n             Capture network traffic during analysis"
    echo "  -m             Perform memory analysis after execution (FlareVM only)"
    echo "  -t <seconds>   Analysis timeout duration (default: 300 seconds)"
    echo "  -h             Display this help message"
    echo -e "\n${YELLOW}Example:${NC}"
    echo "  $0 -f ~/malware/samples/suspicious.exe -n -t 600"
    exit 1
}

# Process command line arguments
while getopts "f:o:nmt:h" opt; do
    case $opt in
        f) SAMPLE_PATH="$OPTARG" ;;
        o) OUTPUT_DIR="$OPTARG" ;;
        n) CAPTURE_NETWORK=true ;;
        m) MEMORY_ANALYSIS=true ;;
        t) TIMEOUT="$OPTARG" ;;
        h) show_usage ;;
        *) show_usage ;;
    esac
done

# Check for required arguments
if [ -z "$SAMPLE_PATH" ]; then
    echo -e "${RED}Error: Malware sample file (-f) is required${NC}"
    show_usage
fi

# Check if file exists
if [ ! -f "$SAMPLE_PATH" ]; then
    echo -e "${RED}Error: File '$SAMPLE_PATH' not found${NC}"
    exit 1
fi

# Create output directory
mkdir -p "$OUTPUT_DIR"
echo -e "${GREEN}[+] Created output directory: $OUTPUT_DIR${NC}"

# Get sample filename
SAMPLE_NAME=$(basename "$SAMPLE_PATH")
SAMPLE_COPY="$OUTPUT_DIR/$SAMPLE_NAME"

# Copy sample to working directory
cp "$SAMPLE_PATH" "$SAMPLE_COPY"
echo -e "${GREEN}[+] Copied sample to analysis directory${NC}"

# Function to check INetSim status
function check_inetsim {
    if pgrep -x "inetsim" > /dev/null; then
        echo -e "${GREEN}[+] INetSim is running${NC}"
    else
        echo -e "${YELLOW}[!] INetSim is not running. Starting...${NC}"
        sudo inetsim --conf /etc/inetsim/inetsim.conf &> /dev/null &
        sleep 2
        if pgrep -x "inetsim" > /dev/null; then
            echo -e "${GREEN}[+] INetSim started successfully${NC}"
        else
            echo -e "${RED}[!] Failed to start INetSim${NC}"
        fi
    fi
}

# Begin analysis
show_banner
echo -e "${GREEN}[+] Starting analysis of: $SAMPLE_NAME${NC}"
echo -e "${GREEN}[+] Analysis results will be saved to: $OUTPUT_DIR${NC}"

# Step 1: Initial file hash generation
echo -e "\n${BLUE}[*] Generating file hashes...${NC}"
echo "# File Hashes for $SAMPLE_NAME" > "$OUTPUT_DIR/hashes.txt"
echo "MD5:    $(md5sum "$SAMPLE_COPY" | cut -d' ' -f1)" >> "$OUTPUT_DIR/hashes.txt"
echo "SHA1:   $(sha1sum "$SAMPLE_COPY" | cut -d' ' -f1)" >> "$OUTPUT_DIR/hashes.txt"
echo "SHA256: $(sha256sum "$SAMPLE_COPY" | cut -d' ' -f1)" >> "$OUTPUT_DIR/hashes.txt"
echo "SSDeep: $(ssdeep "$SAMPLE_COPY" | grep -v ssdeep | head -n 1)" >> "$OUTPUT_DIR/hashes.txt"
echo -e "${GREEN}[+] File hashes saved to: $OUTPUT_DIR/hashes.txt${NC}"

# Step 2: String extraction and analysis
echo -e "\n${BLUE}[*] Extracting strings...${NC}"
echo "# Strings Analysis for $SAMPLE_NAME" > "$OUTPUT_DIR/strings.txt"
strings "$SAMPLE_COPY" > "$OUTPUT_DIR/all_strings.txt"

# Extract potentially interesting strings
echo -e "\n## URLs and Network Indicators" >> "$OUTPUT_DIR/strings.txt"
grep -E "https?://[a-zA-Z0-9./\\-_%]+" "$OUTPUT_DIR/all_strings.txt" >> "$OUTPUT_DIR/strings.txt"
echo -e "\n## IP Addresses" >> "$OUTPUT_DIR/strings.txt"
grep -E "\b([0-9]{1,3}\.){3}[0-9]{1,3}\b" "$OUTPUT_DIR/all_strings.txt" >> "$OUTPUT_DIR/strings.txt"
echo -e "\n## Suspicious Commands" >> "$OUTPUT_DIR/strings.txt"
grep -E "cmd\.exe|powershell|regedit|sc |\bnet\b|schtasks|certutil" "$OUTPUT_DIR/all_strings.txt" >> "$OUTPUT_DIR/strings.txt"
echo -e "\n## Registry Operations" >> "$OUTPUT_DIR/strings.txt"
grep -i "HKEY_|registry" "$OUTPUT_DIR/all_strings.txt" >> "$OUTPUT_DIR/strings.txt"
echo -e "\n## File Operations" >> "$OUTPUT_DIR/strings.txt"
grep -E "\.exe|\.dll|\.dat|\.tmp|\.bat|\.ps1|\.vbs|C:\\\\|AppData|ProgramData" "$OUTPUT_DIR/all_strings.txt" >> "$OUTPUT_DIR/strings.txt"
echo -e "${GREEN}[+] String analysis saved to: $OUTPUT_DIR/strings.txt${NC}"

# Step 3: File type identification
echo -e "\n${BLUE}[*] Identifying file type...${NC}"
file "$SAMPLE_COPY" > "$OUTPUT_DIR/file_type.txt"
echo -e "${GREEN}[+] File type information saved to: $OUTPUT_DIR/file_type.txt${NC}"

# Step 4: YARA scanning
echo -e "\n${BLUE}[*] Scanning with YARA rules...${NC}"
if [ -d "/usr/share/remnux/yara-rules" ]; then
    find /usr/share/remnux/yara-rules -name "*.yar" -exec echo "# {}" \; -exec yara -w -r {} "$SAMPLE_COPY" \; > "$OUTPUT_DIR/yara_matches.txt" 2>/dev/null
    echo -e "${GREEN}[+] YARA scan results saved to: $OUTPUT_DIR/yara_matches.txt${NC}"
else
    echo -e "${YELLOW}[!] YARA rules directory not found${NC}"
fi

# Step 5: PE File Analysis (if applicable)
if file "$SAMPLE_COPY" | grep -qi "PE"; then
    echo -e "\n${BLUE}[*] Performing PE file analysis...${NC}"
    
    # peframe analysis
    echo -e "\n# PEFrame Analysis" > "$OUTPUT_DIR/pe_analysis.txt"
    peframe "$SAMPLE_COPY" >> "$OUTPUT_DIR/pe_analysis.txt" 2>&1
    
    # pedump for resources
    echo -e "\n# PE Resources" >> "$OUTPUT_DIR/pe_analysis.txt"
    pedump "$SAMPLE_COPY" --resources >> "$OUTPUT_DIR/pe_analysis.txt" 2>&1
    
    echo -e "${GREEN}[+] PE file analysis saved to: $OUTPUT_DIR/pe_analysis.txt${NC}"
fi

# Step 6: Document Analysis (if applicable)
if file "$SAMPLE_COPY" | grep -qi "Microsoft Office"; then
    echo -e "\n${BLUE}[*] Analyzing Office document...${NC}"
    olevba "$SAMPLE_COPY" > "$OUTPUT_DIR/document_analysis.txt" 2>&1
    echo -e "${GREEN}[+] Document analysis saved to: $OUTPUT_DIR/document_analysis.txt${NC}"
elif file "$SAMPLE_COPY" | grep -qi "PDF"; then
    echo -e "\n${BLUE}[*] Analyzing PDF document...${NC}"
    pdf-parser "$SAMPLE_COPY" > "$OUTPUT_DIR/document_analysis.txt" 2>&1
    echo -e "${GREEN}[+] PDF analysis saved to: $OUTPUT_DIR/document_analysis.txt${NC}"
fi

# Step 7: Network capture (if requested)
if [ "$CAPTURE_NETWORK" = true ]; then
    echo -e "\n${BLUE}[*] Starting network capture...${NC}"
    check_inetsim
    sudo tcpdump -i any -w "$PCAP_FILE" 'not port 22' &
    TCPDUMP_PID=$!
    echo -e "${GREEN}[+] Network capture started (PID: $TCPDUMP_PID)${NC}"
fi

# Step 8: Controlled execution (simulation only for this script)
echo -e "\n${BLUE}[*] This script provides analysis without execution${NC}"
echo -e "${YELLOW}[!] Actual execution should be performed in a controlled environment${NC}"
echo -e "${YELLOW}[!] For dynamic analysis, use the FlareVM platform${NC}"

# Step 9: Stop network capture
if [ "$CAPTURE_NETWORK" = true ]; then
    echo -e "\n${BLUE}[*] Stopping network capture...${NC}"
    sleep 3 # Simulated delay (in real execution, this would wait for malware activity)
    sudo kill -2 $TCPDUMP_PID
    sleep 1
    echo -e "${GREEN}[+] Network capture completed: $PCAP_FILE${NC}"
    
    # Basic PCAP analysis
    if [ -f "$PCAP_FILE" ]; then
        echo -e "\n${BLUE}[*] Analyzing captured network traffic...${NC}"
        echo -e "# Network Traffic Summary" > "$OUTPUT_DIR/network_analysis.txt"
        capinfos "$PCAP_FILE" >> "$OUTPUT_DIR/network_analysis.txt"
        
        echo -e "\n# DNS Queries" >> "$OUTPUT_DIR/network_analysis.txt"
        tshark -r "$PCAP_FILE" -Y "dns" -T fields -e dns.qry.name -e dns.resp.addr 2>/dev/null >> "$OUTPUT_DIR/network_analysis.txt"
        
        echo -e "\n# HTTP Requests" >> "$OUTPUT_DIR/network_analysis.txt"
        tshark -r "$PCAP_FILE" -Y "http.request" -T fields -e http.host -e http.request.uri 2>/dev/null >> "$OUTPUT_DIR/network_analysis.txt"
        
        echo -e "\n# IP Communications" >> "$OUTPUT_DIR/network_analysis.txt"
        tshark -r "$PCAP_FILE" -T fields -e ip.src -e ip.dst -e ip.proto 2>/dev/null | sort | uniq -c >> "$OUTPUT_DIR/network_analysis.txt"
        
        echo -e "${GREEN}[+] Network analysis saved to: $OUTPUT_DIR/network_analysis.txt${NC}"
    fi
fi

# Step 10: Generate summary report
echo -e "\n${BLUE}[*] Generating final report...${NC}"
cat << EOF > "$OUTPUT_DIR/analysis_summary.md"
# Malware Analysis Summary

## Sample Information
- **Filename:** $SAMPLE_NAME
- **Analysis Date:** $(date +"%Y-%m-%d %H:%M:%S")
- **Analyst:** $(whoami)@REMnux

## Hash Values
$(cat "$OUTPUT_DIR/hashes.txt")

## File Type
$(cat "$OUTPUT_DIR/file_type.txt")

## Key Findings

### Suspicious Indicators
$(grep -E "http|powershell|cmd|reg|dll" "$OUTPUT_DIR/strings.txt" | head -n 10)

### YARA Matches
$(if [ -f "$OUTPUT_DIR/yara_matches.txt" ]; then grep -v "^$" "$OUTPUT_DIR/yara_matches.txt" | head -n 10; else echo "No YARA matches found"; fi)

## Recommendations
- [ ] Submit sample to sandbox for dynamic analysis
- [ ] Compare with known malware families
- [ ] Extract and analyze IOCs
- [ ] Update detection rules

## Next Steps
For complete dynamic analysis, transfer this sample to the FlareVM environment
EOF

echo -e "${GREEN}[+] Analysis summary saved to: $OUTPUT_DIR/analysis_summary.md${NC}"

# Step 11: Final output
echo -e "\n${BLUE}=========================================================${NC}"
echo -e "${GREEN}[+] Analysis completed successfully!${NC}"
echo -e "${GREEN}[+] All results saved to: $OUTPUT_DIR${NC}"
echo -e "${BLUE}=========================================================${NC}"

# Create a simple HTML report if xdg-open is available
if command -v xdg-open &> /dev/null; then
    cat << EOF > "$OUTPUT_DIR/report.html"
<!DOCTYPE html>
<html>
<head>
    <title>Malware Analysis Report: $SAMPLE_NAME</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 20px; }
        h1, h2 { color: #2c3e50; }
        pre { background-color: #f8f9fa; padding: 10px; border-radius: 5px; }
        .section { margin-bottom: 20px; padding: 15px; border: 1px solid #ddd; border-radius: 5px; }
    </style>
</head>
<body>
    <h1>Malware Analysis Report</h1>
    <div class="section">
        <h2>Sample Information</h2>
        <p><strong>Filename:</strong> $SAMPLE_NAME</p>
        <p><strong>Analysis Date:</strong> $(date +"%Y-%m-%d %H:%M:%S")</p>
        <p><strong>Analyst:</strong> $(whoami)@REMnux</p>
    </div>
    
    <div class="section">
        <h2>Hash Values</h2>
        <pre>$(cat "$OUTPUT_DIR/hashes.txt")</pre>
    </div>
    
    <div class="section">
        <h2>File Type</h2>
        <pre>$(cat "$OUTPUT_DIR/file_type.txt")</pre>
    </div>
    
    <div class="section">
        <h2>Suspicious Strings</h2>
        <pre>$(head -n 20 "$OUTPUT_DIR/strings.txt")</pre>
    </div>
    
    <div class="section">
        <h2>YARA Matches</h2>
        <pre>$(if [ -f "$OUTPUT_DIR/yara_matches.txt" ]; then head -n 20 "$OUTPUT_DIR/yara_matches.txt"; else echo "No YARA matches found"; fi)</pre>
    </div>
</body>
</html>
EOF

    echo -e "${GREEN}[+] HTML report created: $OUTPUT_DIR/report.html${NC}"
    echo -e "${YELLOW}[*] Opening HTML report...${NC}"
    xdg-open "$OUTPUT_DIR/report.html" &> /dev/null
fi

exit 0
