USING System.Strings;
USING System.SerDe;

NAMESPACE AXOpen.Utils
    FUNCTION PUBLIC AxoCRC_32 : DWORD
		VAR_INPUT
			In : STRING[254];
		END_VAR
		VAR
			crc : DWORD := DWORD#16#FFFFFFFF;
			i : UINT;
			maxIndex : UINT;
			serialized : ARRAY[0..255] OF BYTE;
		END_VAR
		VAR 
			//Precalculated values for polynomial generator of value 0x04C11DB7  
			CRC_TABLE : ARRAY[0..255] OF DWORD := [
				DWORD#16#00000000, DWORD#16#04C11DB7, DWORD#16#09823B6E, DWORD#16#0D4326D9, DWORD#16#130476DC, DWORD#16#17C56B6B, DWORD#16#1A864DB2, DWORD#16#1E475005, DWORD#16#2608EDB8, DWORD#16#22C9F00F, DWORD#16#2F8AD6D6, DWORD#16#2B4BCB61, DWORD#16#350C9B64, DWORD#16#31CD86D3, DWORD#16#3C8EA00A, DWORD#16#384FBDBD, 
				DWORD#16#4C11DB70, DWORD#16#48D0C6C7, DWORD#16#4593E01E, DWORD#16#4152FDA9, DWORD#16#5F15ADAC, DWORD#16#5BD4B01B, DWORD#16#569796C2, DWORD#16#52568B75, DWORD#16#6A1936C8, DWORD#16#6ED82B7F, DWORD#16#639B0DA6, DWORD#16#675A1011, DWORD#16#791D4014, DWORD#16#7DDC5DA3, DWORD#16#709F7B7A, DWORD#16#745E66CD, 
				DWORD#16#9823B6E0, DWORD#16#9CE2AB57, DWORD#16#91A18D8E, DWORD#16#95609039, DWORD#16#8B27C03C, DWORD#16#8FE6DD8B, DWORD#16#82A5FB52, DWORD#16#8664E6E5, DWORD#16#BE2B5B58, DWORD#16#BAEA46EF, DWORD#16#B7A96036, DWORD#16#B3687D81, DWORD#16#AD2F2D84, DWORD#16#A9EE3033, DWORD#16#A4AD16EA, DWORD#16#A06C0B5D, 
				DWORD#16#D4326D90, DWORD#16#D0F37027, DWORD#16#DDB056FE, DWORD#16#D9714B49, DWORD#16#C7361B4C, DWORD#16#C3F706FB, DWORD#16#CEB42022, DWORD#16#CA753D95, DWORD#16#F23A8028, DWORD#16#F6FB9D9F, DWORD#16#FBB8BB46, DWORD#16#FF79A6F1, DWORD#16#E13EF6F4, DWORD#16#E5FFEB43, DWORD#16#E8BCCD9A, DWORD#16#EC7DD02D, 
				DWORD#16#34867077, DWORD#16#30476DC0, DWORD#16#3D044B19, DWORD#16#39C556AE, DWORD#16#278206AB, DWORD#16#23431B1C, DWORD#16#2E003DC5, DWORD#16#2AC12072, DWORD#16#128E9DCF, DWORD#16#164F8078, DWORD#16#1B0CA6A1, DWORD#16#1FCDBB16, DWORD#16#018AEB13, DWORD#16#054BF6A4, DWORD#16#0808D07D, DWORD#16#0CC9CDCA, 
				DWORD#16#7897AB07, DWORD#16#7C56B6B0, DWORD#16#71159069, DWORD#16#75D48DDE, DWORD#16#6B93DDDB, DWORD#16#6F52C06C, DWORD#16#6211E6B5, DWORD#16#66D0FB02, DWORD#16#5E9F46BF, DWORD#16#5A5E5B08, DWORD#16#571D7DD1, DWORD#16#53DC6066, DWORD#16#4D9B3063, DWORD#16#495A2DD4, DWORD#16#44190B0D, DWORD#16#40D816BA, 
				DWORD#16#ACA5C697, DWORD#16#A864DB20, DWORD#16#A527FDF9, DWORD#16#A1E6E04E, DWORD#16#BFA1B04B, DWORD#16#BB60ADFC, DWORD#16#B6238B25, DWORD#16#B2E29692, DWORD#16#8AAD2B2F, DWORD#16#8E6C3698, DWORD#16#832F1041, DWORD#16#87EE0DF6, DWORD#16#99A95DF3, DWORD#16#9D684044, DWORD#16#902B669D, DWORD#16#94EA7B2A, 
				DWORD#16#E0B41DE7, DWORD#16#E4750050, DWORD#16#E9362689, DWORD#16#EDF73B3E, DWORD#16#F3B06B3B, DWORD#16#F771768C, DWORD#16#FA325055, DWORD#16#FEF34DE2, DWORD#16#C6BCF05F, DWORD#16#C27DEDE8, DWORD#16#CF3ECB31, DWORD#16#CBFFD686, DWORD#16#D5B88683, DWORD#16#D1799B34, DWORD#16#DC3ABDED, DWORD#16#D8FBA05A, 
				DWORD#16#690CE0EE, DWORD#16#6DCDFD59, DWORD#16#608EDB80, DWORD#16#644FC637, DWORD#16#7A089632, DWORD#16#7EC98B85, DWORD#16#738AAD5C, DWORD#16#774BB0EB, DWORD#16#4F040D56, DWORD#16#4BC510E1, DWORD#16#46863638, DWORD#16#42472B8F, DWORD#16#5C007B8A, DWORD#16#58C1663D, DWORD#16#558240E4, DWORD#16#51435D53, 
				DWORD#16#251D3B9E, DWORD#16#21DC2629, DWORD#16#2C9F00F0, DWORD#16#285E1D47, DWORD#16#36194D42, DWORD#16#32D850F5, DWORD#16#3F9B762C, DWORD#16#3B5A6B9B, DWORD#16#0315D626, DWORD#16#07D4CB91, DWORD#16#0A97ED48, DWORD#16#0E56F0FF, DWORD#16#1011A0FA, DWORD#16#14D0BD4D, DWORD#16#19939B94, DWORD#16#1D528623, 
				DWORD#16#F12F560E, DWORD#16#F5EE4BB9, DWORD#16#F8AD6D60, DWORD#16#FC6C70D7, DWORD#16#E22B20D2, DWORD#16#E6EA3D65, DWORD#16#EBA91BBC, DWORD#16#EF68060B, DWORD#16#D727BBB6, DWORD#16#D3E6A601, DWORD#16#DEA580D8, DWORD#16#DA649D6F, DWORD#16#C423CD6A, DWORD#16#C0E2D0DD, DWORD#16#CDA1F604, DWORD#16#C960EBB3, 
				DWORD#16#BD3E8D7E, DWORD#16#B9FF90C9, DWORD#16#B4BCB610, DWORD#16#B07DABA7, DWORD#16#AE3AFBA2, DWORD#16#AAFBE615, DWORD#16#A7B8C0CC, DWORD#16#A379DD7B, DWORD#16#9B3660C6, DWORD#16#9FF77D71, DWORD#16#92B45BA8, DWORD#16#9675461F, DWORD#16#8832161A, DWORD#16#8CF30BAD, DWORD#16#81B02D74, DWORD#16#857130C3, 
				DWORD#16#5D8A9099, DWORD#16#594B8D2E, DWORD#16#5408ABF7, DWORD#16#50C9B640, DWORD#16#4E8EE645, DWORD#16#4A4FFBF2, DWORD#16#470CDD2B, DWORD#16#43CDC09C, DWORD#16#7B827D21, DWORD#16#7F436096, DWORD#16#7200464F, DWORD#16#76C15BF8, DWORD#16#68860BFD, DWORD#16#6C47164A, DWORD#16#61043093, DWORD#16#65C52D24, 
				DWORD#16#119B4BE9, DWORD#16#155A565E, DWORD#16#18197087, DWORD#16#1CD86D30, DWORD#16#029F3D35, DWORD#16#065E2082, DWORD#16#0B1D065B, DWORD#16#0FDC1BEC, DWORD#16#3793A651, DWORD#16#3352BBE6, DWORD#16#3E119D3F, DWORD#16#3AD08088, DWORD#16#2497D08D, DWORD#16#2056CD3A, DWORD#16#2D15EBE3, DWORD#16#29D4F654, 
				DWORD#16#C5A92679, DWORD#16#C1683BCE, DWORD#16#CC2B1D17, DWORD#16#C8EA00A0, DWORD#16#D6AD50A5, DWORD#16#D26C4D12, DWORD#16#DF2F6BCB, DWORD#16#DBEE767C, DWORD#16#E3A1CBC1, DWORD#16#E760D676, DWORD#16#EA23F0AF, DWORD#16#EEE2ED18, DWORD#16#F0A5BD1D, DWORD#16#F464A0AA, DWORD#16#F9278673, DWORD#16#FDE69BC4, 
				DWORD#16#89B8FD09, DWORD#16#8D79E0BE, DWORD#16#803AC667, DWORD#16#84FBDBD0, DWORD#16#9ABC8BD5, DWORD#16#9E7D9662, DWORD#16#933EB0BB, DWORD#16#97FFAD0C, DWORD#16#AFB010B1, DWORD#16#AB710D06, DWORD#16#A6322BDF, DWORD#16#A2F33668, DWORD#16#BCB4666D, DWORD#16#B8757BDA, DWORD#16#B5365D03, DWORD#16#B1F740B4];
		END_VAR
		AxoCRC_32 := crc;

		maxIndex := UINT#0;

		maxIndex := Serialize(UINT#0, In, serialized,System.SerDe.Endianness#Little) - UINT#1;

		IF maxIndex < UINT#1 THEN
			RETURN;
		END_IF;

		FOR i := UINT#1 TO maxIndex BY UINT#1 DO
			crc := SHL(crc, UINT#8) XOR CRC_TABLE[TO_INT(SHR(crc, UINT#24) XOR serialized[i])];
		END_FOR;

		AxoCRC_32 := crc;
    END_FUNCTION
END_NAMESPACE
