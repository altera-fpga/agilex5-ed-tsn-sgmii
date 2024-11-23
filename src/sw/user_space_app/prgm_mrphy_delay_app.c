#include <stdio.h>
#include <stdlib.h>
#include <errno.h>
#include <fcntl.h>
#include <unistd.h>
#include <string.h>

#define EFIFO_SAMP_CLK_PERIOD_NS		4.375		//ns for 156.25MHz
#define PCS_SAMP_CLK_PERIOD_NS 			6.4		//ns for 156.25//62.5MHz
#define MRPHY_EFIFO_LAT_MASK 			0x001FFFFF
#define MRPHY_PCS_LAT_MASK 				0x003FFFFF

#define UI_PERIOD_2_5G_NS 		0.32   //ns for 2.5G

#define DECIMAL_BITS 			13
#define DECI_MASK 				0x1FFF00
#define FRACTION_BITS 			8
#define FRAC_MASK 				0xFF

#define TX_PMA_DELAY  			15.68 //49 * UI  //UI = 0.8ns(1G)/0.32ns(2.5G) //49 * 0.32 = 15.68d //
#define RX_PMA_DELAY  			21.76 //68 * UI  //UI = 0.8ns(1G)/0.32ns(2.5G) //68 * 0.32 = 21.76d //



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

    // Combine integer and fractional parts to get the float value
    float floatValue = integerPart + (fractionalPart / 1024.0f);

    return floatValue;
}


// Function to convert Q13.8 hexadecimal to float
float hexQ13_8ToFloat(int hexValue) {
    int integerPart = (hexValue >> 8);  // Extract the integer part
    unsigned char fractionalPart = hexValue & 0xFF; // Extract the fractional part

    // Combine integer and fractional parts to get the float value
    float floatValue = integerPart + (fractionalPart / 256.0f);

    return floatValue;
}

float get_delay_in_ns(char *file_name, unsigned char q13_8)
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
	 exit(1);
    }
    //printf("read length = %u\n",len);
    buf[len] = '\0';
    hex_delay = atoi(buf);
    //printf("read hex_delay = 0x%x\n",hex_delay);

	if(q13_8)
	{
		//printf("Q13.8 HEX value readd = 0x%x\n",hex_delay);
		float_delay = hexQ13_8ToFloat(hex_delay & MRPHY_EFIFO_LAT_MASK);
		float_delay = float_delay * (EFIFO_SAMP_CLK_PERIOD_NS);
		//printf("Q13.8 HEX to Float = %f\n",float_delay);
	}
	else
	{
		//printf("Q12.10 HEX value readd = 0x%x\n",hex_delay);
		float_delay = hexQ12_10ToFloat(hex_delay & MRPHY_PCS_LAT_MASK);
		float_delay = float_delay * (PCS_SAMP_CLK_PERIOD_NS);
		//printf("Q12.10 HEX to Float = %f\n",float_delay);
	}
	close(fd);

	return float_delay;
}

int main(int argc, char **argv)
{
    	int fd;
	char file_name[256];
	char buf[128];
	ssize_t len;
	float mrphy_efifo_tx_delay;
	float mrphy_efifo_rx_delay;
	float mrphy_pcs_tx_delay;
	float mrphy_pcs_rx_delay;

	float mrphy_total_tx_delay = 0;
	float mrphy_total_rx_delay = 0;
	unsigned int total_tx_delay_Q16_16 = 0;
	unsigned int total_rx_delay_Q16_16 = 0;
	unsigned long long temp = 0;

	//if(argc < 2) {
	//	fprintf(stderr, "\nUsage:\t%s\n", argv[0]);
		//fprintf(stderr, "\nUsage:\t%s { sysfs dir }\n", argv[0]);
	//	exit(1);
	//}

	//mrphy EFIFO tx delay read
	//strcpy(file_name, argv[1]);
	if(argc < 2)
		strcpy(file_name, "/sys/devices/platform/soc\@0/10810000.ethernet/net/eth0");
	else
		strcpy(file_name, argv[1]);

	strcat(file_name, "/mrphy_efifo_tx_delay");
	mrphy_efifo_tx_delay = get_delay_in_ns(file_name, 1);
	printf("efifo TX DELAY = %f\n", mrphy_efifo_tx_delay);

	//mrphy EFIFO rx delay read
	//strcpy(file_name, argv[1]);
	if(argc < 2)
		strcpy(file_name, "/sys/devices/platform/soc\@0/10810000.ethernet/net/eth0");
	else
		strcpy(file_name, argv[1]);
	strcat(file_name, "/mrphy_efifo_rx_delay");
	mrphy_efifo_rx_delay = get_delay_in_ns(file_name, 1);
	printf("efifo RX DELAY = %f\n", mrphy_efifo_rx_delay);

	//mrphy PCS tx delay read
	//strcpy(file_name, argv[1]);
	if(argc < 2)
		strcpy(file_name, "/sys/devices/platform/soc\@0/10810000.ethernet/net/eth0");
	else
		strcpy(file_name, argv[1]);
	strcat(file_name, "/mrphy_pcs_tx_delay");
	mrphy_pcs_tx_delay = get_delay_in_ns(file_name, 0);
	printf("PCS soft TX DELAY = %f\n", mrphy_pcs_tx_delay);

	//mrphy PCS rx delay read
	//strcpy(file_name, argv[1]);
	if(argc < 2)
		strcpy(file_name, "/sys/devices/platform/soc\@0/10810000.ethernet/net/eth0");
	else
		strcpy(file_name, argv[1]);
	strcat(file_name, "/mrphy_pcs_rx_delay");
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

	//strcpy(file_name, argv[1]);
	if(argc < 2)
		strcpy(file_name, "/sys/devices/platform/soc\@0/10810000.ethernet/net/eth0");
	else
		strcpy(file_name, argv[1]);
	strcat(file_name, "/eth_tx_latency");
	fd = open(file_name, O_RDWR);
    	if (fd < 0) {
		fprintf(stderr, "open %s: %s\n", file_name, strerror(errno));
		 exit(1);
    	}
	temp = ((total_tx_delay_Q16_16 & 0xFFFF0000) >> 16) | 
		((unsigned long long)(total_tx_delay_Q16_16 & 0x0000FF00) << 32);
	//printf("sizeof(temp) = %lu\n", sizeof(temp));
        printf("TX DELAY to be programmed in ETH reg = 0x%llx\n", temp);
	printf("TX ETH reg offset-0x0D60 = 0x%x\n", (unsigned int)(temp&0xFFFFFFFF));
	printf("TX ETH reg offset-0x0D64 = 0x%x\n", (unsigned int)((temp&0xFFFFFFFF00000000)>>32));
        sprintf(buf, "%llu", temp);
        //printf("buf= %s\n",buf);
        len = write(fd, buf, strlen(buf)+1);
        if (len < (strlen(buf)+1)) {
                fprintf(stderr, "write %s: %s\n", file_name, strerror(errno));
		 exit(1);
        }
	close(fd);

	//strcpy(file_name, argv[1]);
	if(argc < 2)
		strcpy(file_name, "/sys/devices/platform/soc\@0/10810000.ethernet/net/eth0");
	else
		strcpy(file_name, argv[1]);
	strcat(file_name, "/eth_rx_latency");
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
	sprintf(buf, "%llu", temp);
	//printf("buf= %s\n",buf);
	len = write(fd, buf, strlen(buf)+1);
	if (len < (strlen(buf)+1)) {
                fprintf(stderr, "write %s: %s\n", file_name, strerror(errno));
		 exit(1);
        }
	close(fd);
	printf("Programming of ETH TX and RX\n");
	printf("SUCCESSFUL.....\n---\n");
	return 0;
}
