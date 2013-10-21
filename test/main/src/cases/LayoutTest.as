package cases
{
	import com.viburnum.components.Button;
	import com.viburnum.components.SimpleButton;
	import com.viburnum.components.VGroup;
	import com.viburnum.core.HorizontalAlign;
	import com.viburnum.core.VerticalAlign;
	import com.viburnum.layouts.VerticalLayout;
	
	import flash.events.MouseEvent;
	import cases.supportClasses.ComponentTestBase;

	public class LayoutTest extends ComponentTestBase
	{
		public function LayoutTest()
		{
			super();
		}
		
		override protected function createChildren():void
		{
			super.createChildren();

			var v:VGroup = new VGroup();
			
			VerticalLayout(v.layout).verticalAlign = VerticalAlign.MIDDLE;
			VerticalLayout(v.layout).horizontalAlign = HorizontalAlign.CENTER;
			componentContainer.addChild(v);

			var b1:Button = new Button();
			b1.addEventListener(MouseEvent.CLICK, function():void {b1.visible = b1.includeInLayout = false});
			v.addChild(b1);

			var b2:Button = new Button();
			b2.addEventListener(MouseEvent.CLICK, function():void {b1.visible = b1.includeInLayout = true});
			v.addChild(b2);
		}
	}
}