package
{
	import com.viburnum.components.Application;
	import com.viburnum.components.Group;
	import com.viburnum.components.Scroller;
	import com.viburnum.core.BitmapImage;
	
	[SWF(width="500", height="377")]
	public class VirburnumDevelopTest extends Application
	{
		public function VirburnumDevelopTest()
		{
			super();
		}
		
		override protected function onInitialize():void
		{
			super.onInitialize();
			
			
//			var button:Button = new Button();
//			button.label = "12313";
//			addContentChild(button);
		}
		
		override protected function onInitializeComplete():void
		{
			super.onInitializeComplete();
			
			Localezh_CNLang
			HaloSkinTheme;
			
			[Embed(source="asstes/Penguins.jpg")]
			var bitmapDataCls:Class;
			
			var scroller:Scroller = new Scroller();
			scroller.width = 200;
			scroller.height = 200;
			addContentChild(scroller);
			
			var image:BitmapImage = new BitmapImage();
			image.source = bitmapDataCls;
			
			var g:Group = new Group();
			g.addChild(image);
			
			scroller.viewport = g;
		}
	}
}