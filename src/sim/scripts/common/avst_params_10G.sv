parameter USE_PACKET_10G  = 1;
parameter USE_CHANNEL_10G = 0;
parameter USE_ERROR_10G   = 1;
parameter USE_READY_10G   = 1;
parameter USE_VALID_10G   = 1;
parameter USE_EMPTY_10G   = 1;
parameter  ST_SYMBOL_W_10G   =          8;
`ifdef ETH_MGE
parameter  ST_NUMSYMBOLS_10G =          4;
`else
parameter  ST_NUMSYMBOLS_10G =          4;
`endif
parameter  ST_ERROR_W_10G    =           6;
parameter  ST_EMPTY_W_10G    =           3;
parameter  ST_BEATSPERCYCLE_10G =1 ;                                                  
parameter  ST_CHANNEL_W_10G =1;
parameter  ST_FIRST_SYMBOL_IN_HIGH_ORDER_BITS_10G=1;
parameter  ST_MAX_CHANNELS_10G=1;                                                  
parameter  ST_MAX_PACKET_SIZE_10G =1000;                                                  
`ifdef RDY_LAT
parameter  ST_READY_LATENCY_10G=`RDY_LAT;                                               
`else
parameter  ST_READY_LATENCY_10G=0;                                               
`endif


`define ALTUVM_AVALON_ST_INF_TB_PARAM_INST_10G \
   .ST_CHANNEL_W                             (ST_CHANNEL_W_10G), \
   .ST_EMPTY_W                               (ST_EMPTY_W_10G), \
   .ST_ERROR_W                               (ST_ERROR_W_10G), \
   .ST_NUMSYMBOLS                            (ST_NUMSYMBOLS_10G), \
   .USE_CHANNEL                              (USE_CHANNEL_10G), \
   .USE_EMPTY                                (USE_EMPTY_10G), \
   .USE_ERROR                                (USE_ERROR_10G), \
   .USE_PACKET                               (USE_PACKET_10G), \
   .USE_READY                                (USE_READY_10G), \
   .USE_VALID                                (USE_VALID_10G)

`define ALTUVM_AVALON_ST_RTB_TB_PARAM_INST_10G \
   .ST_BEATSPERCYCLE                         (ST_BEATSPERCYCLE_10G), \
   .ST_CHANNEL_W                             (ST_CHANNEL_W_10G), \
   .ST_EMPTY_W                               (ST_EMPTY_W_10G), \
   .ST_ERROR_W                               (ST_ERROR_W_10G), \
   .ST_FIRST_SYMBOL_IN_HIGH_ORDER_BITS       (ST_FIRST_SYMBOL_IN_HIGH_ORDER_BITS_10G), \
   .ST_MAX_CHANNELS                          (ST_MAX_CHANNELS_10G), \
   .ST_MAX_PACKET_SIZE                       (ST_MAX_PACKET_SIZE_10G), \
   .ST_NUMSYMBOLS                            (ST_NUMSYMBOLS_10G), \
   .ST_READY_LATENCY                         (ST_READY_LATENCY_10G), \
   .USE_CHANNEL                              (USE_CHANNEL_10G), \
   .USE_EMPTY                                (USE_EMPTY_10G), \
   .USE_ERROR                                (USE_ERROR_10G), \
   .USE_PACKET                               (USE_PACKET_10G), \
   .USE_READY                                (USE_READY_10G), \
   .USE_VALID                                (USE_VALID_10G)
