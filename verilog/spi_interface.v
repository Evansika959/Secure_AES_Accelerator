module spi_interface(sclk,		mosi,		csel_AES,	csel_LDO,	miso,		//lines for SPI comms
		     valid_AES_in,	data_AES_in,	encrypt_in,	is_key,		sent,		//lines going to AES
		     valid_AES_out,	data_AES_out,	encrypt_out,					//lines coming out of AES
		     ldo_P,		ldo_I,		ldo_D,						//lines going to LDO PID control
		     reset
);
	input reset;
	//SPI comms
	input mosi;
	input sclk;
	input csel_AES;
	input csel_LDO;
	output reg miso;
	wire miso_n;

	//TO AES
	output valid_AES_in;
	output [127:0] data_AES_in;
	output encrypt_in;
	output is_key;
	output sent;

	reg neg_sent;

	//from AES
	input valid_AES_out;
	input [127:0] data_AES_out;
	input encrypt_out;

	//to PID
	output reg [3:0] ldo_P;
	output reg [3:0] ldo_I;
	output reg [3:0] ldo_D;
	
        reg	[130:0] in_shift_AES;
	wire	[130:0] in_shift_AES_n;

	wire	[130:0] out_shift_AES;
	//wire	[130:0] out_shift_AES_n;
	reg	[7:0] out_index;
	wire	[7:0] out_index_n;

	reg	[15:0] ldo_shift_in;
	wire	[15:0] ldo_shift_in_n;

	//outputing AES data
	assign out_shift_AES[130]	= valid_AES_out;
	assign out_shift_AES[129:2]	= data_AES_out[127:0];
	assign out_shift_AES[1]		= encrypt_out;
	assign out_shift_AES[0]		= 0;
	assign out_index_n		= (out_index + 1) % 131;

	assign miso_n = csel_AES ? out_shift_AES[out_index] : 0;


	//inputting AES data
	assign valid_AES_in	= in_shift_AES[130] & ~csel_AES;
	assign data_AES_in	= in_shift_AES[129:2];
	assign encrypt_in	= in_shift_AES[1];
	assign is_key		= in_shift_AES[0];

	assign in_shift_AES_n[0]= mosi;
	assign ldo_shift_in_n[0]= mosi;

	assign sent = neg_sent ? ~csel_AES : 0;

	genvar i;
	genvar j;
	generate
		for(i = 1; i < 131; i = i + 1) begin
			assign in_shift_AES_n[i]	= in_shift_AES[i-1];
		end
		for(j = 1; j < 16; j = j + 1) begin
			assign ldo_shift_in_n[j]	= ldo_shift_in[j - 1];
		end
	endgenerate


	//outputting LDO data
	always @(negedge csel_LDO) begin
		ldo_P <= ldo_shift_in[11:8];
		ldo_I <= ldo_shift_in[7:4];
		ldo_D <= ldo_shift_in[3:0];
	end


	//taking in data into our shift registers
	always @(posedge sclk) begin
		if(reset) begin
			in_shift_AES	<= 131'h0_0000_0000_0000_0000_0000_0000_0000_0000;
			out_index	<= 8'h00;
			ldo_shift_in	<= 12'h000;
			miso		<= 0;
		end else begin	
			if(csel_AES) begin
				in_shift_AES	<= in_shift_AES_n;
				out_index	<= out_index_n;
			end else begin
				out_index	<= 8'h00;
			end

			if(csel_LDO) begin
			ldo_shift_in <= ldo_shift_in_n;
			end
			miso <= miso_n;
		end
	end
	
	always @(negedge csel_AES) begin
		if(reset) begin
			neg_sent <= 0;
		end else begin
			neg_sent <= 1;
		end
	end


endmodule
