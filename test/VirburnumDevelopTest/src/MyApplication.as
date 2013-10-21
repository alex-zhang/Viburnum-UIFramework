package
{
	import com.viburnum.components.Application;
	import com.viburnum.components.Button;
	import com.viburnum.components.Container;
	import com.viburnum.components.HDividedContainer;

	public class MyApplication extends Application
	{
		protected var myHDividedContainer:HDividedContainer;
		protected var leftContainer:Container;
		protected var rightContainer:Container;
		
		public function MyApplication()
		{
			super();
		}
		
		override protected function onInitialize():void
		{
			super.onInitialize();
			
			var btn:Button = new Button();
//			btn.width = 300;
//			btn.height = 200;
			btn.toolTip = "12312313";
			addContentChild(btn);
//			myHDividedContainer = new HDividedContainer();
//			myHDividedContainer.percentWidth = 1;
//			myHDividedContainer.percentHeight = 1;
//			addContentChild(myHDividedContainer);
//			
//			leftContainer = new Container();
//			leftContainer.setStyle("backgroundSkin_backgroundColor", 0xFF0000);
//			rightContainer = new Container();
//			
//			myHDividedContainer.addViewPage(leftContainer);
//			myHDividedContainer.addViewPage(rightContainer);
		}
	}
}