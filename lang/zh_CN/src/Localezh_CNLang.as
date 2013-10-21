package
{
	import com.viburnum.lang.ILangManager;

	public class Localezh_CNLang
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
			var Alert:Function = function():void
			{
				this.okLabel = "确定";
				this.cancelLabel = "取消";
				this.yesLabel = "是";
				this.noLabel = "否";
			}
			locale["Alert"] = new Alert;
			//-----------------------------------------------------------------|
			
			/**BBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBB**/
			
			/**CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC**/
			
			/**DDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDD**/
			
			//DataChooser
			//----------------------------------------------------------------->
			var DateChooser:Function = function():void
			{
				this.dayNames = "日,一,二,三,四,五,六";
				this.monthNames = "一,二,三,四,五,六,七,八,九,十,十一,十二";
				this.monthSymbol = "月";
				this.yearSymbol = "年";
			}
			locale["DateChooser"] = new DateChooser;
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