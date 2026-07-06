// (C) 2001-2023 Intel Corporation. All rights reserved.
// Your use of Intel Corporation's design tools, logic functions and other 
// software and tools, and its AMPP partner logic functions, and any output 
// files from any of the foregoing (including device programming or simulation 
// files), and any associated documentation or information are expressly subject 
// to the terms and conditions of the Intel Program License Subscription 
// Agreement, Intel FPGA IP License Agreement, or other applicable 
// license agreement, including, without limitation, that your use is for the 
// sole purpose of programming logic devices manufactured by Intel and sold by 
// Intel or its authorized distributors.  Please refer to the applicable 
// agreement for further details.


/*
    galois field multiply, d (x) a^k
        data_width=32, k=64,  Q: 110LE
        data_width=32, k=32,  Q: 107LE
        data_width=64, k=0,   Q: 120LE


    parameters:
        data_width      input data d, width (normally 32/64)
        k               2nd input, a^k  ( -128 <= k <= 128 )

    multiply
        input d, [data_width bits]
        input 2, (fixed = a^k), k parameter
    to give
        output m, 32 bits

    // multiply the input d by parameter a^k, in the galois field
    where g(x) = x^32 + x^26 + x^23 + x^22 + x^16 + x^12 + x^11 + x^10 + x^8 + x^7 + x^5 + x^4 + x^2 + x^1 + x^0



    if a^128, a=e8a45605, then can generate a single 32x32 matrix (for 32 bit data)
    i.e.
        (  a^159  )
        (  ...    )
        (  a^129  )
        (  a^128  )

    in general this is :
        (  a^k+31)
        (  ...   )
        (  a^k+1 )
        (  a^k   )  , where the required multiply is a^k

    for arbitary a^k, this matrix must be generated at compile time
    ( or a precompiled subset defined)
*/

`timescale 1 ps / 1 ps

module alt_em10g32_crc32_gf_mult32_kc #(
    parameter data_width = 32,
    parameter k = 32
)(
    input  wire [data_width-1:0] d,
    output reg            [31:0] m
);

wire [17407:0] h;

assign h[17407:17376] = 32'h55a05b8f;     //a^287
assign h[17375:17344] = 32'ha8b0a31c;     //a^286
assign h[17343:17312] = 32'h5458518e;     //a^285
assign h[17311:17280] = 32'h2a2c28c7;     //a^284
assign h[17279:17248] = 32'h97769ab8;     //a^283
assign h[17247:17216] = 32'h4bbb4d5c;     //a^282
assign h[17215:17184] = 32'h25dda6ae;     //a^281
assign h[17183:17152] = 32'h12eed357;     //a^280
assign h[17151:17120] = 32'h8b17e770;     //a^279
assign h[17119:17088] = 32'h458bf3b8;     //a^278
assign h[17087:17056] = 32'h22c5f9dc;     //a^277
assign h[17055:17024] = 32'h1162fcee;     //a^276
assign h[17023:16992] = 32'h08b17e77;     //a^275
assign h[16991:16960] = 32'h863831e0;     //a^274
assign h[16959:16928] = 32'h431c18f0;     //a^273
assign h[16927:16896] = 32'h218e0c78;     //a^272
assign h[16895:16864] = 32'h10c7063c;     //a^271
assign h[16863:16832] = 32'h0863831e;     //a^270
assign h[16831:16800] = 32'h0431c18f;     //a^269
assign h[16799:16768] = 32'h80786e1c;     //a^268
assign h[16767:16736] = 32'h403c370e;     //a^267
assign h[16735:16704] = 32'h201e1b87;     //a^266
assign h[16703:16672] = 32'h926f8318;     //a^265
assign h[16671:16640] = 32'h4937c18c;     //a^264
assign h[16639:16608] = 32'h249be0c6;     //a^263
assign h[16607:16576] = 32'h124df063;     //a^262
assign h[16575:16544] = 32'h8b4676ea;     //a^261
assign h[16543:16512] = 32'h45a33b75;     //a^260
assign h[16511:16480] = 32'ha0b11361;     //a^259
assign h[16479:16448] = 32'hd238076b;     //a^258
assign h[16447:16416] = 32'heb7c8d6e;     //a^257
assign h[16415:16384] = 32'h75be46b7;     //a^256
assign h[16383:16352] = 32'hb8bfad80;     //a^255
assign h[16351:16320] = 32'h5c5fd6c0;     //a^254
assign h[16319:16288] = 32'h2e2feb60;     //a^253
assign h[16287:16256] = 32'h1717f5b0;     //a^252
assign h[16255:16224] = 32'h0b8bfad8;     //a^251
assign h[16223:16192] = 32'h05c5fd6c;     //a^250
assign h[16191:16160] = 32'h02e2feb6;     //a^249
assign h[16159:16128] = 32'h01717f5b;     //a^248
assign h[16127:16096] = 32'h82d83176;     //a^247
assign h[16095:16064] = 32'h416c18bb;     //a^246
assign h[16063:16032] = 32'ha2d68286;     //a^245
assign h[16031:16000] = 32'h516b4143;     //a^244
assign h[15999:15968] = 32'haad52e7a;     //a^243
assign h[15967:15936] = 32'h556a973d;     //a^242
assign h[15935:15904] = 32'ha8d5c545;     //a^241
assign h[15903:15872] = 32'hd60a6c79;     //a^240
assign h[15871:15840] = 32'he965b8e7;     //a^239
assign h[15839:15808] = 32'hf6d252a8;     //a^238
assign h[15807:15776] = 32'h7b692954;     //a^237
assign h[15775:15744] = 32'h3db494aa;     //a^236
assign h[15743:15712] = 32'h1eda4a55;     //a^235
assign h[15711:15680] = 32'h8d0dabf1;     //a^234
assign h[15679:15648] = 32'hc4e65b23;     //a^233
assign h[15647:15616] = 32'he013a34a;     //a^232
assign h[15615:15584] = 32'h7009d1a5;     //a^231
assign h[15583:15552] = 32'hba646609;     //a^230
assign h[15551:15520] = 32'hdf52bddf;     //a^229
assign h[15519:15488] = 32'hedc9d034;     //a^228
assign h[15487:15456] = 32'h76e4e81a;     //a^227
assign h[15455:15424] = 32'h3b72740d;     //a^226
assign h[15423:15392] = 32'h9fd9b4dd;     //a^225
assign h[15391:15360] = 32'hcd8c54b5;     //a^224
assign h[15359:15328] = 32'he4a6a481;     //a^223
assign h[15327:15296] = 32'hf033dc9b;     //a^222
assign h[15295:15264] = 32'hfa796096;     //a^221
assign h[15263:15232] = 32'h7d3cb04b;     //a^220
assign h[15231:15200] = 32'hbcfed6fe;     //a^219
assign h[15199:15168] = 32'h5e7f6b7f;     //a^218
assign h[15167:15136] = 32'had5f3b64;     //a^217
assign h[15135:15104] = 32'h56af9db2;     //a^216
assign h[15103:15072] = 32'h2b57ced9;     //a^215
assign h[15071:15040] = 32'h97cb69b7;     //a^214
assign h[15039:15008] = 32'hc9853a00;     //a^213
assign h[15007:14976] = 32'h64c29d00;     //a^212
assign h[14975:14944] = 32'h32614e80;     //a^211
assign h[14943:14912] = 32'h1930a740;     //a^210
assign h[14911:14880] = 32'h0c9853a0;     //a^209
assign h[14879:14848] = 32'h064c29d0;     //a^208
assign h[14847:14816] = 32'h032614e8;     //a^207
assign h[14815:14784] = 32'h01930a74;     //a^206
assign h[14783:14752] = 32'h00c9853a;     //a^205
assign h[14751:14720] = 32'h0064c29d;     //a^204
assign h[14719:14688] = 32'h8252ef95;     //a^203
assign h[14687:14656] = 32'hc349f911;     //a^202
assign h[14655:14624] = 32'he3c47253;     //a^201
assign h[14623:14592] = 32'hf382b7f2;     //a^200
assign h[14591:14560] = 32'h79c15bf9;     //a^199
assign h[14559:14528] = 32'hbe802327;     //a^198
assign h[14527:14496] = 32'hdd209f48;     //a^197
assign h[14495:14464] = 32'h6e904fa4;     //a^196
assign h[14463:14432] = 32'h374827d2;     //a^195
assign h[14431:14400] = 32'h1ba413e9;     //a^194
assign h[14399:14368] = 32'h8fb2872f;     //a^193
assign h[14367:14336] = 32'hc5b9cd4c;     //a^192
assign h[14335:14304] = 32'h62dce6a6;     //a^191
assign h[14303:14272] = 32'h316e7353;     //a^190
assign h[14271:14240] = 32'h9ad7b772;     //a^189
assign h[14239:14208] = 32'h4d6bdbb9;     //a^188
assign h[14207:14176] = 32'ha4d56307;     //a^187
assign h[14175:14144] = 32'hd00a3f58;     //a^186
assign h[14143:14112] = 32'h68051fac;     //a^185
assign h[14111:14080] = 32'h34028fd6;     //a^184
assign h[14079:14048] = 32'h1a0147eb;     //a^183
assign h[14047:14016] = 32'h8f602d2e;     //a^182
assign h[14015:13984] = 32'h47b01697;     //a^181
assign h[13983:13952] = 32'ha1b88590;     //a^180
assign h[13951:13920] = 32'h50dc42c8;     //a^179
assign h[13919:13888] = 32'h286e2164;     //a^178
assign h[13887:13856] = 32'h143710b2;     //a^177
assign h[13855:13824] = 32'h0a1b8859;     //a^176
assign h[13823:13792] = 32'h876d4af7;     //a^175
assign h[13791:13760] = 32'hc1d62ba0;     //a^174
assign h[13759:13728] = 32'h60eb15d0;     //a^173
assign h[13727:13696] = 32'h30758ae8;     //a^172
assign h[13695:13664] = 32'h183ac574;     //a^171
assign h[13663:13632] = 32'h0c1d62ba;     //a^170
assign h[13631:13600] = 32'h060eb15d;     //a^169
assign h[13599:13568] = 32'h8167d675;     //a^168
assign h[13567:13536] = 32'hc2d365e1;     //a^167
assign h[13535:13504] = 32'he3093c2b;     //a^166
assign h[13503:13472] = 32'hf3e410ce;     //a^165
assign h[13471:13440] = 32'h79f20867;     //a^164
assign h[13439:13408] = 32'hbe998ae8;     //a^163
assign h[13407:13376] = 32'h5f4cc574;     //a^162
assign h[13375:13344] = 32'h2fa662ba;     //a^161
assign h[13343:13312] = 32'h17d3315d;     //a^160
assign h[13311:13280] = 32'h89891675;     //a^159
assign h[13279:13248] = 32'hc6a405e1;     //a^158
assign h[13247:13216] = 32'he1328c2b;     //a^157
assign h[13215:13184] = 32'hf2f9c8ce;     //a^156
assign h[13183:13152] = 32'h797ce467;     //a^155
assign h[13151:13120] = 32'hbedefce8;     //a^154
assign h[13119:13088] = 32'h5f6f7e74;     //a^153
assign h[13087:13056] = 32'h2fb7bf3a;     //a^152
assign h[13055:13024] = 32'h17dbdf9d;     //a^151
assign h[13023:12992] = 32'h898d6115;     //a^150
assign h[12991:12960] = 32'hc6a63e51;     //a^149
assign h[12959:12928] = 32'he13391f3;     //a^148
assign h[12927:12896] = 32'hf2f94622;     //a^147
assign h[12895:12864] = 32'h797ca311;     //a^146
assign h[12863:12832] = 32'hbededf53;     //a^145
assign h[12831:12800] = 32'hdd0fe172;     //a^144
assign h[12799:12768] = 32'h6e87f0b9;     //a^143
assign h[12767:12736] = 32'hb5237687;     //a^142
assign h[12735:12704] = 32'hd8f13598;     //a^141
assign h[12703:12672] = 32'h6c789acc;     //a^140
assign h[12671:12640] = 32'h363c4d66;     //a^139
assign h[12639:12608] = 32'h1b1e26b3;     //a^138
assign h[12607:12576] = 32'h8fef9d82;     //a^137
assign h[12575:12544] = 32'h47f7cec1;     //a^136
assign h[12543:12512] = 32'ha19b69bb;     //a^135
assign h[12511:12480] = 32'hd2ad3a06;     //a^134
assign h[12479:12448] = 32'h69569d03;     //a^133
assign h[12447:12416] = 32'hb6cbc05a;     //a^132
assign h[12415:12384] = 32'h5b65e02d;     //a^131
assign h[12383:12352] = 32'hafd27ecd;     //a^130
assign h[12351:12320] = 32'hd589b1bd;     //a^129
assign h[12319:12288] = 32'he8a45605;     //a^128
assign h[12287:12256] = 32'hf632a5d9;     //a^127
assign h[12255:12224] = 32'hf979dc37;     //a^126
assign h[12223:12192] = 32'hfedc60c0;     //a^125
assign h[12191:12160] = 32'h7f6e3060;     //a^124
assign h[12159:12128] = 32'h3fb71830;     //a^123
assign h[12127:12096] = 32'h1fdb8c18;     //a^122
assign h[12095:12064] = 32'h0fedc60c;     //a^121
assign h[12063:12032] = 32'h07f6e306;     //a^120
assign h[12031:12000] = 32'h03fb7183;     //a^119
assign h[11999:11968] = 32'h839d361a;     //a^118
assign h[11967:11936] = 32'h41ce9b0d;     //a^117
assign h[11935:11904] = 32'ha287c35d;     //a^116
assign h[11903:11872] = 32'hd3236f75;     //a^115
assign h[11871:11840] = 32'hebf13961;     //a^114
assign h[11839:11808] = 32'hf798126b;     //a^113
assign h[11807:11776] = 32'hf9ac87ee;     //a^112
assign h[11775:11744] = 32'h7cd643f7;     //a^111
assign h[11743:11712] = 32'hbc0baf20;     //a^110
assign h[11711:11680] = 32'h5e05d790;     //a^109
assign h[11679:11648] = 32'h2f02ebc8;     //a^108
assign h[11647:11616] = 32'h178175e4;     //a^107
assign h[11615:11584] = 32'h0bc0baf2;     //a^106
assign h[11583:11552] = 32'h05e05d79;     //a^105
assign h[11551:11520] = 32'h8090a067;     //a^104
assign h[11519:11488] = 32'hc228dee8;     //a^103
assign h[11487:11456] = 32'h61146f74;     //a^102
assign h[11455:11424] = 32'h308a37ba;     //a^101
assign h[11423:11392] = 32'h18451bdd;     //a^100
assign h[11391:11360] = 32'h8e420335;     //a^99
assign h[11359:11328] = 32'hc5418f41;     //a^98
assign h[11327:11296] = 32'he0c0497b;     //a^97
assign h[11295:11264] = 32'hf200aa66;     //a^96
assign h[11263:11232] = 32'h79005533;     //a^95
assign h[11231:11200] = 32'hbee0a442;     //a^94
assign h[11199:11168] = 32'h5f705221;     //a^93
assign h[11167:11136] = 32'hadd8a7cb;     //a^92
assign h[11135:11104] = 32'hd48cdd3e;     //a^91
assign h[11103:11072] = 32'h6a466e9f;     //a^90
assign h[11071:11040] = 32'hb743b994;     //a^89
assign h[11039:11008] = 32'h5ba1dcca;     //a^88
assign h[11007:10976] = 32'h2dd0ee65;     //a^87
assign h[10975:10944] = 32'h9488f9e9;     //a^86
assign h[10943:10912] = 32'hc824f22f;     //a^85
assign h[10911:10880] = 32'he672f7cc;     //a^84
assign h[10879:10848] = 32'h73397be6;     //a^83
assign h[10847:10816] = 32'h399cbdf3;     //a^82
assign h[10815:10784] = 32'h9eaed022;     //a^81
assign h[10783:10752] = 32'h4f576811;     //a^80
assign h[10751:10720] = 32'ha5cb3ad3;     //a^79
assign h[10719:10688] = 32'hd08513b2;     //a^78
assign h[10687:10656] = 32'h684289d9;     //a^77
assign h[10655:10624] = 32'hb641ca37;     //a^76
assign h[10623:10592] = 32'hd9406bc0;     //a^75
assign h[10591:10560] = 32'h6ca035e0;     //a^74
assign h[10559:10528] = 32'h36501af0;     //a^73
assign h[10527:10496] = 32'h1b280d78;     //a^72
assign h[10495:10464] = 32'h0d9406bc;     //a^71
assign h[10463:10432] = 32'h06ca035e;     //a^70
assign h[10431:10400] = 32'h036501af;     //a^69
assign h[10399:10368] = 32'h83d20e0c;     //a^68
assign h[10367:10336] = 32'h41e90706;     //a^67
assign h[10335:10304] = 32'h20f48383;     //a^66
assign h[10303:10272] = 32'h921acf1a;     //a^65
assign h[10271:10240] = 32'h490d678d;     //a^64
assign h[10239:10208] = 32'ha6e63d1d;     //a^63
assign h[10207:10176] = 32'hd1139055;     //a^62
assign h[10175:10144] = 32'heae946f1;     //a^61
assign h[10143:10112] = 32'hf7142da3;     //a^60
assign h[10111:10080] = 32'hf9ea980a;     //a^59
assign h[10079:10048] = 32'h7cf54c05;     //a^58
assign h[10047:10016] = 32'hbc1a28d9;     //a^57
assign h[10015:9984] = 32'hdc6d9ab7;     //a^56
assign h[9983:9952] = 32'hec564380;     //a^55
assign h[9951:9920] = 32'h762b21c0;     //a^54
assign h[9919:9888] = 32'h3b1590e0;     //a^53
assign h[9887:9856] = 32'h1d8ac870;     //a^52
assign h[9855:9824] = 32'h0ec56438;     //a^51
assign h[9823:9792] = 32'h0762b21c;     //a^50
assign h[9791:9760] = 32'h03b1590e;     //a^49
assign h[9759:9728] = 32'h01d8ac87;     //a^48
assign h[9727:9696] = 32'h828cd898;     //a^47
assign h[9695:9664] = 32'h41466c4c;     //a^46
assign h[9663:9632] = 32'h20a33626;     //a^45
assign h[9631:9600] = 32'h10519b13;     //a^44
assign h[9599:9568] = 32'h8a484352;     //a^43
assign h[9567:9536] = 32'h452421a9;     //a^42
assign h[9535:9504] = 32'ha0f29e0f;     //a^41
assign h[9503:9472] = 32'hd219c1dc;     //a^40
assign h[9471:9440] = 32'h690ce0ee;     //a^39
assign h[9439:9408] = 32'h34867077;     //a^38
assign h[9407:9376] = 32'h9823b6e0;     //a^37
assign h[9375:9344] = 32'h4c11db70;     //a^36
assign h[9343:9312] = 32'h2608edb8;     //a^35
assign h[9311:9280] = 32'h130476dc;     //a^34
assign h[9279:9248] = 32'h09823b6e;     //a^33
assign h[9247:9216] = 32'h04c11db7;     //a^32
assign h[9215:9184] = 32'h80000000;     //a^31
assign h[9183:9152] = 32'h40000000;     //a^30
assign h[9151:9120] = 32'h20000000;     //a^29
assign h[9119:9088] = 32'h10000000;     //a^28
assign h[9087:9056] = 32'h08000000;     //a^27
assign h[9055:9024] = 32'h04000000;     //a^26
assign h[9023:8992] = 32'h02000000;     //a^25
assign h[8991:8960] = 32'h01000000;     //a^24
assign h[8959:8928] = 32'h00800000;     //a^23
assign h[8927:8896] = 32'h00400000;     //a^22
assign h[8895:8864] = 32'h00200000;     //a^21
assign h[8863:8832] = 32'h00100000;     //a^20
assign h[8831:8800] = 32'h00080000;     //a^19
assign h[8799:8768] = 32'h00040000;     //a^18
assign h[8767:8736] = 32'h00020000;     //a^17
assign h[8735:8704] = 32'h00010000;     //a^16
assign h[8703:8672] = 32'h00008000;     //a^15
assign h[8671:8640] = 32'h00004000;     //a^14
assign h[8639:8608] = 32'h00002000;     //a^13
assign h[8607:8576] = 32'h00001000;     //a^12
assign h[8575:8544] = 32'h00000800;     //a^11
assign h[8543:8512] = 32'h00000400;     //a^10
assign h[8511:8480] = 32'h00000200;     //a^9
assign h[8479:8448] = 32'h00000100;     //a^8
assign h[8447:8416] = 32'h00000080;     //a^7
assign h[8415:8384] = 32'h00000040;     //a^6
assign h[8383:8352] = 32'h00000020;     //a^5
assign h[8351:8320] = 32'h00000010;     //a^4
assign h[8319:8288] = 32'h00000008;     //a^3
assign h[8287:8256] = 32'h00000004;     //a^2
assign h[8255:8224] = 32'h00000002;     //a^1
assign h[8223:8192] = 32'h00000001;     //a^0
assign h[8191:8160] = 32'h82608edb;     //a^-1
assign h[8159:8128] = 32'hc350c9b6;     //a^-2
assign h[8127:8096] = 32'h61a864db;     //a^-3
assign h[8095:8064] = 32'hb2b4bcb6;     //a^-4
assign h[8063:8032] = 32'h595a5e5b;     //a^-5
assign h[8031:8000] = 32'haecda1f6;     //a^-6
assign h[7999:7968] = 32'h5766d0fb;     //a^-7
assign h[7967:7936] = 32'ha9d3e6a6;     //a^-8
assign h[7935:7904] = 32'h54e9f353;     //a^-9
assign h[7903:7872] = 32'ha8147772;     //a^-10
assign h[7871:7840] = 32'h540a3bb9;     //a^-11
assign h[7839:7808] = 32'ha8659307;     //a^-12
assign h[7807:7776] = 32'hd6524758;     //a^-13
assign h[7775:7744] = 32'h6b2923ac;     //a^-14
assign h[7743:7712] = 32'h359491d6;     //a^-15
assign h[7711:7680] = 32'h1aca48eb;     //a^-16
assign h[7679:7648] = 32'h8f05aaae;     //a^-17
assign h[7647:7616] = 32'h4782d557;     //a^-18
assign h[7615:7584] = 32'ha1a1e470;     //a^-19
assign h[7583:7552] = 32'h50d0f238;     //a^-20
assign h[7551:7520] = 32'h2868791c;     //a^-21
assign h[7519:7488] = 32'h14343c8e;     //a^-22
assign h[7487:7456] = 32'h0a1a1e47;     //a^-23
assign h[7455:7424] = 32'h876d81f8;     //a^-24
assign h[7423:7392] = 32'h43b6c0fc;     //a^-25
assign h[7391:7360] = 32'h21db607e;     //a^-26
assign h[7359:7328] = 32'h10edb03f;     //a^-27
assign h[7327:7296] = 32'h8a1656c4;     //a^-28
assign h[7295:7264] = 32'h450b2b62;     //a^-29
assign h[7263:7232] = 32'h228595b1;     //a^-30
assign h[7231:7200] = 32'h93224403;     //a^-31
assign h[7199:7168] = 32'hcbf1acda;     //a^-32
assign h[7167:7136] = 32'h65f8d66d;     //a^-33
assign h[7135:7104] = 32'hb09ce5ed;     //a^-34
assign h[7103:7072] = 32'hda2efc2d;     //a^-35
assign h[7071:7040] = 32'hef77f0cd;     //a^-36
assign h[7039:7008] = 32'hf5db76bd;     //a^-37
assign h[7007:6976] = 32'hf88d3585;     //a^-38
assign h[6975:6944] = 32'hfe261419;     //a^-39
assign h[6943:6912] = 32'hfd7384d7;     //a^-40
assign h[6911:6880] = 32'hfcd94cb0;     //a^-41
assign h[6879:6848] = 32'h7e6ca658;     //a^-42
assign h[6847:6816] = 32'h3f36532c;     //a^-43
assign h[6815:6784] = 32'h1f9b2996;     //a^-44
assign h[6783:6752] = 32'h0fcd94cb;     //a^-45
assign h[6751:6720] = 32'h858644be;     //a^-46
assign h[6719:6688] = 32'h42c3225f;     //a^-47
assign h[6687:6656] = 32'ha3011ff4;     //a^-48
assign h[6655:6624] = 32'h51808ffa;     //a^-49
assign h[6623:6592] = 32'h28c047fd;     //a^-50
assign h[6591:6560] = 32'h9600ad25;     //a^-51
assign h[6559:6528] = 32'hc960d849;     //a^-52
assign h[6527:6496] = 32'he6d0e2ff;     //a^-53
assign h[6495:6464] = 32'hf108ffa4;     //a^-54
assign h[6463:6432] = 32'h78847fd2;     //a^-55
assign h[6431:6400] = 32'h3c423fe9;     //a^-56
assign h[6399:6368] = 32'h9c41912f;     //a^-57
assign h[6367:6336] = 32'hcc40464c;     //a^-58
assign h[6335:6304] = 32'h66202326;     //a^-59
assign h[6303:6272] = 32'h33101193;     //a^-60
assign h[6271:6240] = 32'h9be88612;     //a^-61
assign h[6239:6208] = 32'h4df44309;     //a^-62
assign h[6207:6176] = 32'ha49aaf5f;     //a^-63
assign h[6175:6144] = 32'hd02dd974;     //a^-64
assign h[6143:6112] = 32'h6816ecba;     //a^-65
assign h[6111:6080] = 32'h340b765d;     //a^-66
assign h[6079:6048] = 32'h986535f5;     //a^-67
assign h[6047:6016] = 32'hce521421;     //a^-68
assign h[6015:5984] = 32'he54984cb;     //a^-69
assign h[5983:5952] = 32'hf0c44cbe;     //a^-70
assign h[5951:5920] = 32'h7862265f;     //a^-71
assign h[5919:5888] = 32'hbe519df4;     //a^-72
assign h[5887:5856] = 32'h5f28cefa;     //a^-73
assign h[5855:5824] = 32'h2f94677d;     //a^-74
assign h[5823:5792] = 32'h95aabd65;     //a^-75
assign h[5791:5760] = 32'hc8b5d069;     //a^-76
assign h[5759:5728] = 32'he63a66ef;     //a^-77
assign h[5727:5696] = 32'hf17dbdac;     //a^-78
assign h[5695:5664] = 32'h78beded6;     //a^-79
assign h[5663:5632] = 32'h3c5f6f6b;     //a^-80
assign h[5631:5600] = 32'h9c4f396e;     //a^-81
assign h[5599:5568] = 32'h4e279cb7;     //a^-82
assign h[5567:5536] = 32'ha5734080;     //a^-83
assign h[5535:5504] = 32'h52b9a040;     //a^-84
assign h[5503:5472] = 32'h295cd020;     //a^-85
assign h[5471:5440] = 32'h14ae6810;     //a^-86
assign h[5439:5408] = 32'h0a573408;     //a^-87
assign h[5407:5376] = 32'h052b9a04;     //a^-88
assign h[5375:5344] = 32'h0295cd02;     //a^-89
assign h[5343:5312] = 32'h014ae681;     //a^-90
assign h[5311:5280] = 32'h82c5fd9b;     //a^-91
assign h[5279:5248] = 32'hc3027016;     //a^-92
assign h[5247:5216] = 32'h6181380b;     //a^-93
assign h[5215:5184] = 32'hb2a012de;     //a^-94
assign h[5183:5152] = 32'h5950096f;     //a^-95
assign h[5151:5120] = 32'haec88a6c;     //a^-96
assign h[5119:5088] = 32'h57644536;     //a^-97
assign h[5087:5056] = 32'h2bb2229b;     //a^-98
assign h[5055:5024] = 32'h97b99f96;     //a^-99
assign h[5023:4992] = 32'h4bdccfcb;     //a^-100
assign h[4991:4960] = 32'ha78ee93e;     //a^-101
assign h[4959:4928] = 32'h53c7749f;     //a^-102
assign h[4927:4896] = 32'hab833494;     //a^-103
assign h[4895:4864] = 32'h55c19a4a;     //a^-104
assign h[4863:4832] = 32'h2ae0cd25;     //a^-105
assign h[4831:4800] = 32'h9710e849;     //a^-106
assign h[4799:4768] = 32'hc9e8faff;     //a^-107
assign h[4767:4736] = 32'he694f3a4;     //a^-108
assign h[4735:4704] = 32'h734a79d2;     //a^-109
assign h[4703:4672] = 32'h39a53ce9;     //a^-110
assign h[4671:4640] = 32'h9eb210af;     //a^-111
assign h[4639:4608] = 32'hcd39868c;     //a^-112
assign h[4607:4576] = 32'h669cc346;     //a^-113
assign h[4575:4544] = 32'h334e61a3;     //a^-114
assign h[4543:4512] = 32'h9bc7be0a;     //a^-115
assign h[4511:4480] = 32'h4de3df05;     //a^-116
assign h[4479:4448] = 32'ha4916159;     //a^-117
assign h[4447:4416] = 32'hd0283e77;     //a^-118
assign h[4415:4384] = 32'hea7491e0;     //a^-119
assign h[4383:4352] = 32'h753a48f0;     //a^-120
assign h[4351:4320] = 32'h3a9d2478;     //a^-121
assign h[4319:4288] = 32'h1d4e923c;     //a^-122
assign h[4287:4256] = 32'h0ea7491e;     //a^-123
assign h[4255:4224] = 32'h0753a48f;     //a^-124
assign h[4223:4192] = 32'h81c95c9c;     //a^-125
assign h[4191:4160] = 32'h40e4ae4e;     //a^-126
assign h[4159:4128] = 32'h20725727;     //a^-127
assign h[4127:4096] = 32'h9259a548;     //a^-128
assign h[4095:4064] = 32'h492cd2a4;     //a^-129
assign h[4063:4032] = 32'h24966952;     //a^-130
assign h[4031:4000] = 32'h124b34a9;     //a^-131
assign h[3999:3968] = 32'h8b45148f;     //a^-132
assign h[3967:3936] = 32'hc7c2049c;     //a^-133
assign h[3935:3904] = 32'h63e1024e;     //a^-134
assign h[3903:3872] = 32'h31f08127;     //a^-135
assign h[3871:3840] = 32'h9a98ce48;     //a^-136
assign h[3839:3808] = 32'h4d4c6724;     //a^-137
assign h[3807:3776] = 32'h26a63392;     //a^-138
assign h[3775:3744] = 32'h135319c9;     //a^-139
assign h[3743:3712] = 32'h8bc9023f;     //a^-140
assign h[3711:3680] = 32'hc7840fc4;     //a^-141
assign h[3679:3648] = 32'h63c207e2;     //a^-142
assign h[3647:3616] = 32'h31e103f1;     //a^-143
assign h[3615:3584] = 32'h9a900f23;     //a^-144
assign h[3583:3552] = 32'hcf28894a;     //a^-145
assign h[3551:3520] = 32'h679444a5;     //a^-146
assign h[3519:3488] = 32'hb1aaac89;     //a^-147
assign h[3487:3456] = 32'hdab5d89f;     //a^-148
assign h[3455:3424] = 32'hef3a6294;     //a^-149
assign h[3423:3392] = 32'h779d314a;     //a^-150
assign h[3391:3360] = 32'h3bce98a5;     //a^-151
assign h[3359:3328] = 32'h9f87c289;     //a^-152
assign h[3327:3296] = 32'hcda36f9f;     //a^-153
assign h[3295:3264] = 32'he4b13914;     //a^-154
assign h[3263:3232] = 32'h72589c8a;     //a^-155
assign h[3231:3200] = 32'h392c4e45;     //a^-156
assign h[3199:3168] = 32'h9ef6a9f9;     //a^-157
assign h[3167:3136] = 32'hcd1bda27;     //a^-158
assign h[3135:3104] = 32'he4ed63c8;     //a^-159
assign h[3103:3072] = 32'h7276b1e4;     //a^-160
assign h[3071:3040] = 32'h393b58f2;     //a^-161
assign h[3039:3008] = 32'h1c9dac79;     //a^-162
assign h[3007:2976] = 32'h8c2e58e7;     //a^-163
assign h[2975:2944] = 32'hc477a2a8;     //a^-164
assign h[2943:2912] = 32'h623bd154;     //a^-165
assign h[2911:2880] = 32'h311de8aa;     //a^-166
assign h[2879:2848] = 32'h188ef455;     //a^-167
assign h[2847:2816] = 32'h8e27f4f1;     //a^-168
assign h[2815:2784] = 32'hc57374a3;     //a^-169
assign h[2783:2752] = 32'he0d9348a;     //a^-170
assign h[2751:2720] = 32'h706c9a45;     //a^-171
assign h[2719:2688] = 32'hba56c3f9;     //a^-172
assign h[2687:2656] = 32'hdf4bef27;     //a^-173
assign h[2655:2624] = 32'hedc57948;     //a^-174
assign h[2623:2592] = 32'h76e2bca4;     //a^-175
assign h[2591:2560] = 32'h3b715e52;     //a^-176
assign h[2559:2528] = 32'h1db8af29;     //a^-177
assign h[2527:2496] = 32'h8cbcd94f;     //a^-178
assign h[2495:2464] = 32'hc43ee27c;     //a^-179
assign h[2463:2432] = 32'h621f713e;     //a^-180
assign h[2431:2400] = 32'h310fb89f;     //a^-181
assign h[2399:2368] = 32'h9ae75294;     //a^-182
assign h[2367:2336] = 32'h4d73a94a;     //a^-183
assign h[2335:2304] = 32'h26b9d4a5;     //a^-184
assign h[2303:2272] = 32'h913c6489;     //a^-185
assign h[2271:2240] = 32'hcafebc9f;     //a^-186
assign h[2239:2208] = 32'he71fd094;     //a^-187
assign h[2207:2176] = 32'h738fe84a;     //a^-188
assign h[2175:2144] = 32'h39c7f425;     //a^-189
assign h[2143:2112] = 32'h9e8374c9;     //a^-190
assign h[2111:2080] = 32'hcd2134bf;     //a^-191
assign h[2079:2048] = 32'he4f01484;     //a^-192
assign h[2047:2016] = 32'h72780a42;     //a^-193
assign h[2015:1984] = 32'h393c0521;     //a^-194
assign h[1983:1952] = 32'h9efe8c4b;     //a^-195
assign h[1951:1920] = 32'hcd1fc8fe;     //a^-196
assign h[1919:1888] = 32'h668fe47f;     //a^-197
assign h[1887:1856] = 32'hb1277ce4;     //a^-198
assign h[1855:1824] = 32'h5893be72;     //a^-199
assign h[1823:1792] = 32'h2c49df39;     //a^-200
assign h[1791:1760] = 32'h94446147;     //a^-201
assign h[1759:1728] = 32'hc842be78;     //a^-202
assign h[1727:1696] = 32'h64215f3c;     //a^-203
assign h[1695:1664] = 32'h3210af9e;     //a^-204
assign h[1663:1632] = 32'h190857cf;     //a^-205
assign h[1631:1600] = 32'h8ee4a53c;     //a^-206
assign h[1599:1568] = 32'h4772529e;     //a^-207
assign h[1567:1536] = 32'h23b9294f;     //a^-208
assign h[1535:1504] = 32'h93bc1a7c;     //a^-209
assign h[1503:1472] = 32'h49de0d3e;     //a^-210
assign h[1471:1440] = 32'h24ef069f;     //a^-211
assign h[1439:1408] = 32'h90170d94;     //a^-212
assign h[1407:1376] = 32'h480b86ca;     //a^-213
assign h[1375:1344] = 32'h2405c365;     //a^-214
assign h[1343:1312] = 32'h90626f69;     //a^-215
assign h[1311:1280] = 32'hca51b96f;     //a^-216
assign h[1279:1248] = 32'he748526c;     //a^-217
assign h[1247:1216] = 32'h73a42936;     //a^-218
assign h[1215:1184] = 32'h39d2149b;     //a^-219
assign h[1183:1152] = 32'h9e898496;     //a^-220
assign h[1151:1120] = 32'h4f44c24b;     //a^-221
assign h[1119:1088] = 32'ha5c2effe;     //a^-222
assign h[1087:1056] = 32'h52e177ff;     //a^-223
assign h[1055:1024] = 32'hab103524;     //a^-224
assign h[1023:992] = 32'h55881a92;     //a^-225
assign h[991:960] = 32'h2ac40d49;     //a^-226
assign h[959:928] = 32'h9702887f;     //a^-227
assign h[927:896] = 32'hc9e1cae4;     //a^-228
assign h[895:864] = 32'h64f0e572;     //a^-229
assign h[863:832] = 32'h327872b9;     //a^-230
assign h[831:800] = 32'h9b5cb787;     //a^-231
assign h[799:768] = 32'hcfced518;     //a^-232
assign h[767:736] = 32'h67e76a8c;     //a^-233
assign h[735:704] = 32'h33f3b546;     //a^-234
assign h[703:672] = 32'h19f9daa3;     //a^-235
assign h[671:640] = 32'h8e9c638a;     //a^-236
assign h[639:608] = 32'h474e31c5;     //a^-237
assign h[607:576] = 32'ha1c79639;     //a^-238
assign h[575:544] = 32'hd28345c7;     //a^-239
assign h[543:512] = 32'heb212c38;     //a^-240
assign h[511:480] = 32'h7590961c;     //a^-241
assign h[479:448] = 32'h3ac84b0e;     //a^-242
assign h[447:416] = 32'h1d642587;     //a^-243
assign h[415:384] = 32'h8cd29c18;     //a^-244
assign h[383:352] = 32'h46694e0c;     //a^-245
assign h[351:320] = 32'h2334a706;     //a^-246
assign h[319:288] = 32'h119a5383;     //a^-247
assign h[287:256] = 32'h8aada71a;     //a^-248
assign h[255:224] = 32'h4556d38d;     //a^-249
assign h[223:192] = 32'ha0cbe71d;     //a^-250
assign h[191:160] = 32'hd2057d55;     //a^-251
assign h[159:128] = 32'heb623071;     //a^-252
assign h[127:96] = 32'hf7d196e3;     //a^-253
assign h[95:64] = 32'hf98845aa;     //a^-254
assign h[63:32] = 32'h7cc422d5;     //a^-255
assign h[31:0] = 32'hbc029fb1;     //a^-256

integer i,j;
reg mm;

always @(d or h)
begin
    // multiply     d x h      -> m
    //          (1xdata_width)x(data_widthxpoly_width) = (1xpoly_width)
    // number of xor's == number of 1's in column of H
    for (i=0; i<32; i=i+1)
    begin
        mm = 0;
        for(j=0; j<data_width; j=j+1)
        begin
            mm = mm ^ (d[data_width-1-j] & h[256*32 + 32*k + 32*(data_width-1-j) + (31-i)]);
        end
        m[31-i] = mm;
    end
end

endmodule

