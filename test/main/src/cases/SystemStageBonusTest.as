package cases
{
	import com.viburnum.components.Button;
	import com.viburnum.components.SimpleButton;
	
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import cases.supportClasses.ComponentTestBase;

	public class SystemStageBonusTest extends ComponentTestBase
	{
		public function SystemStageBonusTest()
		{
			super();
		}
		
		override protected function createChildren():void
		{
			super.createChildren();
		
			description = "cursorDecorator, dragOnFly";
			
			var bt1:Button = new Button();
			bt1.label = "cursorDecorator 1";
			componentContainer.addChild(bt1);
			bt1.addEventListener(MouseEvent.ROLL_OVER, bt1rollOverHandler);
			bt1.addEventListener(MouseEvent.ROLL_OUT, bt1rollOutHandler);
			function bt1rollOverHandler():void
			{
				application.cursorDecorator.setCursorHangingDrop(AssetsReference.assets4, null, false);
			}
			
			function bt1rollOutHandler():void
			{
				cursorDecorator.removeCursorHangingDrop();
			}
			
			var bt2:Button = new Button();
			bt2.x = 20;
			bt2.label = "cursorDecorator 2";
			componentContainer.addChild(bt2);
			bt2.addEventListener(MouseEvent.ROLL_OVER, bt2rollOverHandler);
			bt2.addEventListener(MouseEvent.ROLL_OUT, bt2rollOutHandler);
			function bt2rollOverHandler():void
			{
				cursorDecorator.setCursorHangingDrop(AssetsReference.assets4);
			}
			
			function bt2rollOutHandler():void
			{
				cursorDecorator.removeCursorHangingDrop();
			}
			
			var bt3:Button = new Button();
			bt3.x = 70;
			bt3.label = "drag on fly";
			componentContainer.addChild(bt3);
			bt3.addEventListener(MouseEvent.MOUSE_DOWN, bt3mouseDownHandler);
			function bt3mouseDownHandler(event:MouseEvent):void
			{
				dragOnFly.doDrag(bt3, event);
			}
		}
	}
}