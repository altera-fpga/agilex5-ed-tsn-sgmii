#include <stdio.h>
#include <stdlib.h>
#include <errno.h>
#include <fcntl.h>
#include <unistd.h>
#include <string.h>
#include <dirent.h>
#include <sys/stat.h>

#define EFIFO_SAMP_CLK_PERIOD_NS        4.375           //ns for 156.25MHz
#define PCS_SAMP_CLK_PERIOD_NS          6.4             //ns for 156.25//62.5MHz
#define MRPHY_EFIFO_LAT_MASK            0x001FFFFF
#define MRPHY_PCS_LAT_MASK              0x003FFFFF

#define UI_PERIOD_2_5G_NS               0.32   //ns for 2.5G

#define DECIMAL_BITS                    13
#define DECI_MASK                       0x1FFF00
#define FRACTION_BITS                   8
#define FRAC_MASK                       0xFF

#define TX_PMA_DELAY                    15.68 //49 * UI  //UI = 0.8ns(1G)/0.32ns(2.5G) //49 * 0.32 = 15.68d //
#define RX_PMA_DELAY                    21.76 //68 * UI  //UI = 0.8ns(1G)/0.32ns(2.5G) //68 * 0.32 = 21.76d //

#define MAX_PATH 1024
#define SUFFIX_EFIFO_TX "/mrphy_efifo_tx_delay"
#define SUFFIX_EFIFO_RX "/mrphy_efifo_rx_delay"
#define SUFFIX_PCS_TX   "/mrphy_pcs_tx_delay"
#define SUFFIX_PCS_RX   "/mrphy_pcs_rx_delay"
#define SUFFIX_ETH_TX   "/eth_tx_latency"
#define SUFFIX_ETH_RX   "/eth_rx_latency"

// Function to convert float to Q16.16 format
unsigned int floatToQ16_16(float floatValue) {
    unsigned int uint_q16_16 = ((unsigned int)floatValue) << 16; //integer part
    uint_q16_16 |= (unsigned int)((floatValue - ((unsigned int)floatValue)) * (1 << 16)) & 0xFFFF; //fraction part
    return uint_q16_16;
}

// Function to convert Q12.10 hexadecimal to float
float hexQ12_10ToFloat(int hexValue) {
    int integerPart = (hexValue >> 10);  // Extract the integer part
    unsigned short fractionalPart = hexValue & 0x3FF; // Extract the fractional part
    float floatValue = integerPart + (fractionalPart / 1024.0f);
    return floatValue;
}

// Function to convert Q13.8 hexadecimal to float
float hexQ13_8ToFloat(int hexValue) {
    int integerPart = (hexValue >> 8);  // Extract the integer part
    unsigned char fractionalPart = hexValue & 0xFF; // Extract the fractional part
    float floatValue = integerPart + (fractionalPart / 256.0f);
    return floatValue;
}

float get_delay_in_ns(const char *file_name, unsigned char q13_8)
{
    ssize_t len;
    char buf[128];
    int hex_delay = 0;
    float float_delay = 0;
    int fd;

    fd = open(file_name, O_RDONLY);
    if (fd < 0) {
        fprintf(stderr, "open %s: %s\n", file_name, strerror(errno));
        exit(1);
    }
    len = read(fd, buf, sizeof(buf)-1);
    if (len < 0) {
        fprintf(stderr, "read %s: %s", file_name, strerror(errno));
        close(fd);
        exit(1);
    }
    buf[len] = '\0';
    hex_delay = atoi(buf);

    if(q13_8) {
        float_delay = hexQ13_8ToFloat(hex_delay & MRPHY_EFIFO_LAT_MASK);
        float_delay = float_delay * (EFIFO_SAMP_CLK_PERIOD_NS);
    } else {
        float_delay = hexQ12_10ToFloat(hex_delay & MRPHY_PCS_LAT_MASK);
        float_delay = float_delay * (PCS_SAMP_CLK_PERIOD_NS);
    }
    close(fd);

    return float_delay;
}

void process_interface(const char *base_path, const char *ifname)
{
    char file_name[MAX_PATH];
    char buf[128];
    ssize_t len;
    int fd;
    float mrphy_efifo_tx_delay;
    float mrphy_efifo_rx_delay;
    float mrphy_pcs_tx_delay;
    float mrphy_pcs_rx_delay;
    float mrphy_total_tx_delay = 0;
    float mrphy_total_rx_delay = 0;
    unsigned int total_tx_delay_Q16_16 = 0;
    unsigned int total_rx_delay_Q16_16 = 0;
    unsigned long long temp = 0;

    printf("\n==== Interface: %s ====\n", ifname);

    // efifo TX
    snprintf(file_name, sizeof(file_name), "%.*s%s",
             (int)(sizeof(file_name) - sizeof(SUFFIX_EFIFO_TX)),
             base_path, SUFFIX_EFIFO_TX);
    mrphy_efifo_tx_delay = get_delay_in_ns(file_name, 1);
    printf("efifo TX DELAY = %f\n", mrphy_efifo_tx_delay);

    // efifo RX
    snprintf(file_name, sizeof(file_name), "%.*s%s",
             (int)(sizeof(file_name) - sizeof(SUFFIX_EFIFO_RX)),
             base_path, SUFFIX_EFIFO_RX);
    mrphy_efifo_rx_delay = get_delay_in_ns(file_name, 1);
    printf("efifo RX DELAY = %f\n", mrphy_efifo_rx_delay);

    // PCS TX
    snprintf(file_name, sizeof(file_name), "%.*s%s",
             (int)(sizeof(file_name) - sizeof(SUFFIX_PCS_TX)),
             base_path, SUFFIX_PCS_TX);
    mrphy_pcs_tx_delay = get_delay_in_ns(file_name, 0);
    printf("PCS soft TX DELAY = %f\n", mrphy_pcs_tx_delay);

    // PCS RX
    snprintf(file_name, sizeof(file_name), "%.*s%s",
             (int)(sizeof(file_name) - sizeof(SUFFIX_PCS_RX)),
             base_path, SUFFIX_PCS_RX);
    mrphy_pcs_rx_delay = get_delay_in_ns(file_name, 0);
    printf("PCS soft RX DELAY = %f\n", mrphy_pcs_rx_delay);

    //calculate total TX delay and convert to Q16.16
    mrphy_total_tx_delay = mrphy_efifo_tx_delay + mrphy_pcs_tx_delay + TX_PMA_DELAY;
    printf("TOTAL TX DELAY = %f\n", mrphy_total_tx_delay);
    total_tx_delay_Q16_16 = floatToQ16_16(mrphy_total_tx_delay);
    printf("TOTAL TX DELAY in Q16.16 = 0x%x\n", total_tx_delay_Q16_16);

    //calculate total RX delay and convert to Q16.16
    mrphy_total_rx_delay = mrphy_efifo_rx_delay + mrphy_pcs_rx_delay + RX_PMA_DELAY;
    printf("TOTAL RX DELAY = %f\n", mrphy_total_rx_delay);
    total_rx_delay_Q16_16 = floatToQ16_16(mrphy_total_rx_delay);
    printf("TOTAL RX DELAY in Q16.16 = 0x%x\n", total_rx_delay_Q16_16);

    // Write TX delay
    snprintf(file_name, sizeof(file_name), "%.*s%s",
             (int)(sizeof(file_name) - sizeof(SUFFIX_ETH_TX)),
             base_path, SUFFIX_ETH_TX);
    fd = open(file_name, O_RDWR);
    if (fd < 0) {
        fprintf(stderr, "open %s: %s\n", file_name, strerror(errno));
        exit(1);
    }
    temp = ((total_tx_delay_Q16_16 & 0xFFFF0000) >> 16) |
           ((unsigned long long)(total_tx_delay_Q16_16 & 0x0000FF00) << 32);
    printf("TX DELAY to be programmed in ETH reg = 0x%llx\n", temp);
    printf("TX ETH reg offset-0x0D60 = 0x%x\n", (unsigned int)(temp&0xFFFFFFFF));
    printf("TX ETH reg offset-0x0D64 = 0x%x\n", (unsigned int)((temp&0xFFFFFFFF00000000)>>32));
    snprintf(buf, sizeof(buf), "%llu", temp);
    len = write(fd, buf, strlen(buf)+1);
    if (len < (ssize_t)(strlen(buf)+1)) {
        fprintf(stderr, "write %s: %s\n", file_name, strerror(errno));
        close(fd);
        exit(1);
    }
    close(fd);

    // Write RX delay
    snprintf(file_name, sizeof(file_name), "%.*s%s",
             (int)(sizeof(file_name) - sizeof(SUFFIX_ETH_RX)),
             base_path, SUFFIX_ETH_RX);
    fd = open(file_name, O_RDWR);
    if (fd < 0) {
        fprintf(stderr, "open %s: %s\n", file_name, strerror(errno));
        exit(1);
    }
    temp = ((total_rx_delay_Q16_16 & 0xFFFF0000) >> 16) |
           ((unsigned long long)(total_rx_delay_Q16_16 & 0x0000FF00) << 32);
    printf("RX DELAY to be programmed in ETH reg = 0x%llx\n", temp);
    printf("RX ETH reg offset-0x0D58 = 0x%x\n", (unsigned int)(temp&0xFFFFFFFF));
    printf("RX ETH reg offset-0x0D5c = 0x%x\n", (unsigned int)((temp&0xFFFFFFFF00000000)>>32));
    snprintf(buf, sizeof(buf), "%llu", temp);
    len = write(fd, buf, strlen(buf)+1);
    if (len < (ssize_t)(strlen(buf)+1)) {
        fprintf(stderr, "write %s: %s\n", file_name, strerror(errno));
        close(fd);
        exit(1);
    }
    close(fd);

    printf("Programming of ETH TX and RX for %s SUCCESSFUL.\n", base_path);
}

int file_exists(const char *filename)
{
    struct stat buffer;
    return (stat(filename, &buffer) == 0);
}

int main()
{
    const char *net_class_dir = "/sys/class/net/";
    DIR *dir;
    struct dirent *entry;

    dir = opendir(net_class_dir);
    if (!dir) {
        perror("opendir /sys/class/net/");
        exit(1);
    }

    printf("Auto-detecting Ethernet interfaces...\n");

    int found = 0;
    while ((entry = readdir(dir)) != NULL) {
        if (entry->d_type != DT_LNK && entry->d_type != DT_DIR)
            continue;
        if (strcmp(entry->d_name, ".") == 0 || strcmp(entry->d_name, "..") == 0)
            continue;

        // Only pick names starting with "eth" (or adjust as needed)
        if (strncmp(entry->d_name, "eth", 3) != 0)
            continue;

        // Compose base path for delay files (assumed under /sys/class/net/ethX/)
        char sysfs_path[MAX_PATH];
        snprintf(sysfs_path, sizeof(sysfs_path), "/sys/class/net/%s", entry->d_name);

        // Test for presence of expected delay file
        char testfile[MAX_PATH];
        snprintf(testfile, sizeof(testfile), "%.*s%s",
                 (int)(sizeof(testfile) - sizeof(SUFFIX_EFIFO_TX)),
                 sysfs_path, SUFFIX_EFIFO_TX);

        if (file_exists(testfile)) {
            found++;
            process_interface(sysfs_path, entry->d_name);
        }
    }

    closedir(dir);

    if (!found) {
        printf("No Ethernet interfaces with required sysfs files found.\n");
        return 1;
    }
    printf("All detected interfaces processed.\n");
    return 0;
}
