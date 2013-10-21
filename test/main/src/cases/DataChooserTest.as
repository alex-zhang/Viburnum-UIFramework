package cases
{
	import cases.supportClasses.ComponentTestBase;
	
	import com.viburnum.components.Button;
	import com.viburnum.components.DateChooser;
	
	import flash.events.MouseEvent;

	public class DataChooserTest extends ComponentTestBase
	{
		public function DataChooserTest()
		{
			super();
		}
		
		override protected function createChildren():void
		{
			super.createChildren();
		
			var bt:Button = new Button();
			componentContainer.addChild(bt);
			bt.addEventListener(MouseEvent.CLICK, function():void {
				var dc:DateChooser = new DateChooser();
				componentContainer.addChild(dc);
			});
			
			var datec:DateChooser = new DateChooser();
			datec.percentWidth = 1;
			datec.percentHeight = 1;
			componentContainer.addChild(datec);
		}
	}
}