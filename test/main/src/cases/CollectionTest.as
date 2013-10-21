package cases
{
	import cases.supportClasses.ComponentTestBase;
	
	import com.viburnum.components.Button;
	import com.viburnum.components.ToolTip;
	import com.viburnum.data.ArrayList;
	import com.viburnum.events.CollectionEvent;
	import com.viburnum.layouts.FlowLayout;
	import com.viburnum.layouts.HorizontalLayout;
	import com.viburnum.layouts.VerticalLayout;
	
	import flash.events.MouseEvent;

	public class CollectionTest extends ComponentTestBase
	{
		public function CollectionTest()
		{
			super();
		}
		
		override protected function createChildren():void
		{
			super.createChildren();

			componentContainer.layout = new FlowLayout();
			
			var arr:Array = ["zhangcheng01"];
			var arrlist:ArrayList = new ArrayList(arr);
			arrlist.addEventListener(CollectionEvent.COLLECTION_CHANGE, function (event:CollectionEvent):void {
//				trace(event.toString());
			});
			
			arrlist.addItemAt("zhangcheng02",65);
		}
	}
}