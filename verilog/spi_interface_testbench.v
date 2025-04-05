module spi_testbench();
	

	`define TB_MAX_CYCLES 1000

	logic [130:0] AES_in;
	logic [129:0] AES_out;
	logic [129:0] AES_out_check;
	logic [11:0] ldo_IN;

	int in_dex;
	int out_dex;
	int ldo_dex;
	
	logic sclk;
	logic mosi;
	logic csel_AES;
	logic csel_LDO;
	logic miso;
	logic valid_AES_in;
	logic [127:0] data_AES_in;
	logic encrypt_in;
	logic is_key;
	logic sent;
	logic valid_AES_out;
	logic [127:0] data_AES_out;
	logic encrypt_out;
	logic [3:0] ldo_P, ldo_I, ldo_D;
	logic reset;

	spi_interface spi(.*);

	initial begin

		AES_in	= 131'h7_abcd_dead_beef_ceed_dead_beef_dead_beef;
		AES_out	= 130'h3_dead_abcd_beed_ffff_beef_dead_dead_beef;
		ldo_IN	= 12'hfab;

		in_dex	= 130;
		out_dex	= 129;
		ldo_dex = 11;

		sclk		= 0;
		mosi		= 0;
		csel_AES	= 0;
		csel_LDO	= 0;
		valid_AES_out	= AES_out[129];
		data_AES_out	= AES_out[128:1];
		encrypt_out	= AES_out[0];

		reset	= 1;

		sclk = 1;
		sclk = 0;
		reset = 0;

		csel_LDO= 1;
		mosi	= ldo_IN[ldo_dex];
		ldo_dex = ldo_dex - 1;//11
		sclk = 1;
		sclk = 0;

		mosi	= ldo_IN[ldo_dex];
		ldo_dex = ldo_dex - 1;//10
	       	sclk = 1;
		sclk = 0;


		mosi	= ldo_IN[ldo_dex];
		ldo_dex = ldo_dex - 1;//9
	       	sclk = 1;
		sclk = 0;

		mosi	= ldo_IN[ldo_dex];
		ldo_dex = ldo_dex - 1;//8
	       	sclk = 1;
		sclk = 0;

		mosi	= ldo_IN[ldo_dex];
		ldo_dex = ldo_dex - 1;//7
	       	sclk = 1;
		sclk = 0;

		mosi	= ldo_IN[ldo_dex];
		ldo_dex = ldo_dex - 1;//6
	       	sclk = 1;
		sclk = 0;

		mosi	= ldo_IN[ldo_dex];
		ldo_dex = ldo_dex - 1;//5
	       	sclk = 1;
		sclk = 0;

		mosi	= ldo_IN[ldo_dex];
		ldo_dex = ldo_dex - 1;//4
	       	sclk = 1;
		sclk = 0;

		mosi	= ldo_IN[ldo_dex];
		ldo_dex = ldo_dex - 1;//3
	       	sclk = 1;
		sclk = 0;

		mosi	= ldo_IN[ldo_dex];
		ldo_dex = ldo_dex - 1;//2
	       	sclk = 1;
		sclk = 0;

		mosi	= ldo_IN[ldo_dex];
		ldo_dex = ldo_dex - 1;//1
	       	sclk = 1;
		sclk = 0;

		mosi	= ldo_IN[ldo_dex];
		ldo_dex = ldo_dex - 1;//0
	       	sclk = 1;
		sclk = 0;

		csel_LDO = 0;

		sclk = 1;
		sclk = 0;

		assert(ldo_P == ldo_IN[11:8]);
		assert(ldo_I == ldo_IN[7:4]);
		assert(ldo_D == ldo_IN[3:0]);

		csel_AES = 1;

		for(int i = 0; i < 131; i = i + 1) begin
			mosi 	         = AES_in[0];
			if(i != 0) begin
				AES_out_check[i-1] = miso;
			end
			sclk = 1;
			sclk = 0;
		end

		csel_AES = 0;

		assert(valid_AES_in	== AES_in[130]);
		assert(data_AES_in	== AES_in[129:2]);
		assert(encrypt_in	== AES_in[1]);
		assert(is_key		== AES_in[0]);

		assert(AES_out_check	== AES_out);

		$display("correct!");
		$finish();
	end

endmodule


