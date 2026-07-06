parameter USE_PACKET  = 1;
parameter USE_CHANNEL = 0;
parameter USE_ERROR   = 1;
parameter USE_READY   = 1;
parameter USE_VALID   = 1;
parameter USE_EMPTY   = 1;
parameter  ST_SYMBOL_W   =          8;
`ifdef G100
parameter  ST_NUMSYMBOLS =          64;
`elsif G10_25
parameter  ST_NUMSYMBOLS =          8;
`endif
parameter  ST_ERROR_W    =           6;
`ifdef G100
parameter  ST_EMPTY_W    =           6;
`elsif G10_25
parameter  ST_EMPTY_W    =           3;
`endif
parameter  ST_BEATSPERCYCLE =1 ;                                                  
`ifdef G100
parameter  ST_CHANNEL_W =0;
`elsif G10_25
parameter  ST_CHANNEL_W =1;
`endif
parameter  ST_FIRST_SYMBOL_IN_HIGH_ORDER_BITS=1;
parameter  ST_MAX_CHANNELS=1;                                                  
parameter  ST_MAX_PACKET_SIZE =1000;                                                  
parameter  ST_READY_LATENCY=0;                                               
