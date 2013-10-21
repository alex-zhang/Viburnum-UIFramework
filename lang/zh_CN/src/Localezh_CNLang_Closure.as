package
{
	import com.viburnum.lang.ILangManager;

	public class Localezh_CNLang_Closure
	{
		public static var assetName:String = "zh_CN";
		public static var assetType:String = "Lang";
		
		//0:Application 1:langManager
		public static function create(... parameters):Object
		{
			var locale:Object = {};
			
			//System parts
			/******************************************************************/
			
			//common
			//----------------------------------------------------------------->
			//-----------------------------------------------------------------|
			
			//global
			//----------------------------------------------------------------->
			//-----------------------------------------------------------------|
			
			/**AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA**/
			
			//Alert
			//----------------------------------------------------------------->
			locale.Alert =
			{
				okLabel : "确定",
				cancelLabel : "取消",
				yesLabel : "是",
				noLabel : "否"
			}
			//-----------------------------------------------------------------|
			
			/**BBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBB**/
			
			/**CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC**/
			
			/**DDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDD**/
			
			//DataChooser
			//----------------------------------------------------------------->
			locale.DateChooser =
			{
				dayNames : "日,一,二,三,四,五,六",
				monthNames : "一,二,三,四,五,六,七,八,九,十,十一,十二",
				monthSymbol : "月",
				yearSymbol : "年"
			}
			//-----------------------------------------------------------------|
			
			/**EEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEE**/
			
			/**FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF**/
			
			/**GGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGG**/
			
			/**HHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHH**/
			
			/**IIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIII**/
			
			/**JJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJ**/
			
			/**KKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKK**/
			
			/**LLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLL**/
			
			/**MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM**/
			
			/**NNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNN**/
			
			/**OOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOO**/
			
			/**PPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPP**/
			
			/**QQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQ**/
			
			/**RRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRR**/
			
			/**SSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSS**/
			
			/**TTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTT**/
			
			/**UUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUU**/
			
			/**VVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVV**/
			
			/**WWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWW**/
			
			/**XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX**/
			
			/**YYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYY**/
			
			/**ZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZ**/
			
			/******************************************************************/
			
			if(parameters[1] is ILangManager)
			{
				ILangManager(parameters[1]).initializeLocaleChain(assetName, locale);
				
				
			}
			
			//Maybe Others Parts here...
			/******************************************************************/
			
			//...
			
			/******************************************************************/

			return locale;
		}
	}
}