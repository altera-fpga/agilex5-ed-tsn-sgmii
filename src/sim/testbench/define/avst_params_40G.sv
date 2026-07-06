parameter USE_PACKET_40G  = 1;
parameter USE_CHANNEL_40G = 0;
parameter USE_ERROR_40G   = 1;
parameter USE_READY_40G   = 1;
parameter USE_VALID_40G   = 1;
parameter USE_EMPTY_40G   = 1;
parameter  ST_SYMBOL_W_40G   =          8;
parameter  ST_NUMSYMBOLS_40G =          16;
parameter  ST_ERROR_W_40G    =           6;
parameter  ST_EMPTY_W_40G    =           4;
parameter  ST_BEATSPERCYCLE_40G =1 ;                                                  
parameter  ST_CHANNEL_W_40G =0;
parameter  ST_FIRST_SYMBOL_IN_HIGH_ORDER_BITS_40G=1;
parameter  ST_MAX_CHANNELS_40G=1;                                                  
parameter  ST_MAX_PACKET_SIZE_40G =1000;                                                  
`ifdef RDY_LAT
parameter  ST_READY_LATENCY_40G=`RDY_LAT;                                               
`else
parameter  ST_READY_LATENCY_40G=0;                                               
`endif

`define ALTUVM_AVALON_ST_INF_TB_PARAM_INST_40G \
   .ST_CHANNEL_W                             (ST_CHANNEL_W_40G), \
   .ST_EMPTY_W                               (ST_EMPTY_W_40G), \
   .ST_ERROR_W                               (ST_ERROR_W_40G), \
   .ST_NUMSYMBOLS                            (ST_NUMSYMBOLS_40G), \
   .USE_CHANNEL                              (USE_CHANNEL_40G), \
   .USE_EMPTY                                (USE_EMPTY_40G), \
   .USE_ERROR                                (USE_ERROR_40G), \
   .USE_PACKET                               (USE_PACKET_40G), \
   .USE_READY                                (USE_READY_40G), \
   .USE_VALID                                (USE_VALID_40G)

`define ALTUVM_AVALON_ST_RTB_TB_PARAM_INST_40G \
   .ST_BEATSPERCYCLE                         (ST_BEATSPERCYCLE_40G), \
   .ST_CHANNEL_W                             (ST_CHANNEL_W_40G), \
   .ST_EMPTY_W                               (ST_EMPTY_W_40G), \
   .ST_ERROR_W                               (ST_ERROR_W_40G), \
   .ST_FIRST_SYMBOL_IN_HIGH_ORDER_BITS       (ST_FIRST_SYMBOL_IN_HIGH_ORDER_BITS_40G), \
   .ST_MAX_CHANNELS                          (ST_MAX_CHANNELS_40G), \
   .ST_MAX_PACKET_SIZE                       (ST_MAX_PACKET_SIZE_40G), \
   .ST_NUMSYMBOLS                            (ST_NUMSYMBOLS_40G), \
   .ST_READY_LATENCY                         (ST_READY_LATENCY_40G), \
   .USE_CHANNEL                              (USE_CHANNEL_40G), \
   .USE_EMPTY                                (USE_EMPTY_40G), \
   .USE_ERROR                                (USE_ERROR_40G), \
   .USE_PACKET                               (USE_PACKET_40G), \
   .USE_READY                                (USE_READY_40G), \
   .USE_VALID                                (USE_VALID_40G)
