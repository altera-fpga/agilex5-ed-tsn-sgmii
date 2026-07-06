parameter USE_PACKET_50G  = 1;
parameter USE_CHANNEL_50G = 0;
parameter USE_ERROR_50G   = 1;
parameter USE_READY_50G   = 1;
parameter USE_VALID_50G   = 1;
parameter USE_EMPTY_50G   = 1;
parameter  ST_SYMBOL_W_50G   =          8;
parameter  ST_NUMSYMBOLS_50G =          16;
parameter  ST_ERROR_W_50G    =           6;
parameter  ST_EMPTY_W_50G    =           4;
parameter  ST_BEATSPERCYCLE_50G =1 ;                                                  
parameter  ST_CHANNEL_W_50G =0;
parameter  ST_FIRST_SYMBOL_IN_HIGH_ORDER_BITS_50G=1;
parameter  ST_MAX_CHANNELS_50G=1;                                                  
parameter  ST_MAX_PACKET_SIZE_50G =1000;                                                  
`ifdef RDY_LAT
parameter  ST_READY_LATENCY_50G=`RDY_LAT;                                               
`else
parameter  ST_READY_LATENCY_50G=0;                                               
`endif

`define ALTUVM_AVALON_ST_INF_TB_PARAM_INST_50G \
   .ST_CHANNEL_W                             (ST_CHANNEL_W_50G), \
   .ST_EMPTY_W                               (ST_EMPTY_W_50G), \
   .ST_ERROR_W                               (ST_ERROR_W_50G), \
   .ST_NUMSYMBOLS                            (ST_NUMSYMBOLS_50G), \
   .USE_CHANNEL                              (USE_CHANNEL_50G), \
   .USE_EMPTY                                (USE_EMPTY_50G), \
   .USE_ERROR                                (USE_ERROR_50G), \
   .USE_PACKET                               (USE_PACKET_50G), \
   .USE_READY                                (USE_READY_50G), \
   .USE_VALID                                (USE_VALID_50G)

`define ALTUVM_AVALON_ST_RTB_TB_PARAM_INST_50G \
   .ST_BEATSPERCYCLE                         (ST_BEATSPERCYCLE_50G), \
   .ST_CHANNEL_W                             (ST_CHANNEL_W_50G), \
   .ST_EMPTY_W                               (ST_EMPTY_W_50G), \
   .ST_ERROR_W                               (ST_ERROR_W_50G), \
   .ST_FIRST_SYMBOL_IN_HIGH_ORDER_BITS       (ST_FIRST_SYMBOL_IN_HIGH_ORDER_BITS_50G), \
   .ST_MAX_CHANNELS                          (ST_MAX_CHANNELS_50G), \
   .ST_MAX_PACKET_SIZE                       (ST_MAX_PACKET_SIZE_50G), \
   .ST_NUMSYMBOLS                            (ST_NUMSYMBOLS_50G), \
   .ST_READY_LATENCY                         (ST_READY_LATENCY_50G), \
   .USE_CHANNEL                              (USE_CHANNEL_50G), \
   .USE_EMPTY                                (USE_EMPTY_50G), \
   .USE_ERROR                                (USE_ERROR_50G), \
   .USE_PACKET                               (USE_PACKET_50G), \
   .USE_READY                                (USE_READY_50G), \
   .USE_VALID                                (USE_VALID_50G)
