parameter USE_PACKET_25G  = 1;
parameter USE_CHANNEL_25G = 0;
parameter USE_ERROR_25G   = 1;
parameter USE_READY_25G   = 1;
parameter USE_VALID_25G   = 1;
parameter USE_EMPTY_25G   = 1;
parameter  ST_SYMBOL_W_25G   =          8;
parameter  ST_NUMSYMBOLS_25G =          8;
parameter  ST_ERROR_W_25G    =           6;
parameter  ST_EMPTY_W_25G    =           3;
parameter  ST_BEATSPERCYCLE_25G =1 ;                                                  
parameter  ST_CHANNEL_W_25G =1;
parameter  ST_FIRST_SYMBOL_IN_HIGH_ORDER_BITS_25G=1;
parameter  ST_MAX_CHANNELS_25G=1;                                                  
parameter  ST_MAX_PACKET_SIZE_25G =1000;                                                  
`ifdef RDY_LAT
parameter  ST_READY_LATENCY_25G=`RDY_LAT;                                               
`else
parameter  ST_READY_LATENCY_25G=0;                                               
`endif

`define ALTUVM_AVALON_ST_INF_TB_PARAM_INST_25G \
   .ST_CHANNEL_W                             (ST_CHANNEL_W_25G), \
   .ST_EMPTY_W                               (ST_EMPTY_W_25G), \
   .ST_ERROR_W                               (ST_ERROR_W_25G), \
   .ST_NUMSYMBOLS                            (ST_NUMSYMBOLS_25G), \
   .USE_CHANNEL                              (USE_CHANNEL_25G), \
   .USE_EMPTY                                (USE_EMPTY_25G), \
   .USE_ERROR                                (USE_ERROR_25G), \
   .USE_PACKET                               (USE_PACKET_25G), \
   .USE_READY                                (USE_READY_25G), \
   .USE_VALID                                (USE_VALID_25G)

`define ALTUVM_AVALON_ST_RTB_TB_PARAM_INST_25G \
   .ST_BEATSPERCYCLE                         (ST_BEATSPERCYCLE_25G), \
   .ST_CHANNEL_W                             (ST_CHANNEL_W_25G), \
   .ST_EMPTY_W                               (ST_EMPTY_W_25G), \
   .ST_ERROR_W                               (ST_ERROR_W_25G), \
   .ST_FIRST_SYMBOL_IN_HIGH_ORDER_BITS       (ST_FIRST_SYMBOL_IN_HIGH_ORDER_BITS_25G), \
   .ST_MAX_CHANNELS                          (ST_MAX_CHANNELS_25G), \
   .ST_MAX_PACKET_SIZE                       (ST_MAX_PACKET_SIZE_25G), \
   .ST_NUMSYMBOLS                            (ST_NUMSYMBOLS_25G), \
   .ST_READY_LATENCY                         (ST_READY_LATENCY_25G), \
   .USE_CHANNEL                              (USE_CHANNEL_25G), \
   .USE_EMPTY                                (USE_EMPTY_25G), \
   .USE_ERROR                                (USE_ERROR_25G), \
   .USE_PACKET                               (USE_PACKET_25G), \
   .USE_READY                                (USE_READY_25G), \
   .USE_VALID                                (USE_VALID_25G)
